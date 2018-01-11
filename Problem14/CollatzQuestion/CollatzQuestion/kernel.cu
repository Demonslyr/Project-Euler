
#include <cuda.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <chrono> //for the cpu timing
#include <inttypes.h> //To fprint int64
#include <stdio.h>

#define MAX_THREADS 1000

__global__ void collatzKernel(int *c)
{
	int s = blockDim.x*blockIdx.x + threadIdx.x;
	c[s] = 0;
	unsigned i = s;
	int count = 1;
	while (i>1) {
		++count;
		if (i % 2)
			i = i * 3 + 1;
		else
			i /= 2;
	}
	c[s] = count;
}

using namespace std::chrono;

int main()
{
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);



	const int arraySize = 1000000;
	int *c = new int[arraySize];

	int *dev_c;

	cudaMalloc((void**)&dev_c, arraySize * sizeof(int));
	high_resolution_clock::time_point t1 = high_resolution_clock::now();
	cudaEventRecord(start);
	collatzKernel << <arraySize / MAX_THREADS, MAX_THREADS >> > (dev_c);
	cudaEventRecord(stop);

	cudaEventSynchronize(stop);
	cudaDeviceSynchronize();

	cudaMemcpy(c, dev_c, arraySize * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(dev_c);

	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);

	printf("calc concluded after %f ms.\n", milliseconds);

	int maxCollatzIdx = 0;
	for (int i = 0; i < arraySize; i++) {
		if (c[maxCollatzIdx] <= c[i])
			maxCollatzIdx = i;
	}
	high_resolution_clock::time_point t2 = high_resolution_clock::now();
	auto duration = duration_cast<microseconds>(t2 - t1).count();
	printf("calc and search concluded after %" PRId64 "microseconds.\n", duration);
	printf("%d with a %d length chain.\n", maxCollatzIdx, c[maxCollatzIdx]);
	getchar();
	return 0;
}
