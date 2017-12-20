
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

__global__ void myFirstKernel() {

}

__global__ void simpleAddKernel(int *x, int *y, int *z) {
	*z = *x + *y;
}

__global__ void simpleVectorAdd(int *x, int *y, int *z, int n) {//I can just pass that int in if I dont want it back out? Maybe not. A large static data structure may still need to be copied and referenced
	int index = threadIdx.x + blockIdx.x*blockDim.x;
	z[index] = x[index] + y[index];
}

__global__ void appendTwoStrings(char* u, char* v, char* w) {
	int index = threadIdx.x + blockIdx.x*blockDim.x;

}

#define N (2048*2048)
#define THREADS_PER_BLOCK 512
class util {
public:
	static void random_ints(int *a, int n);
	static char** getDictionary(char *filePath);
};

char** getDictionary(char *filePath) {
	vector<vector<string>> wordBag;
	for (int i = 0; i < 16; i++) {
		wordBag.push_back(vector<string>());
	}
	char * dict[16];
	string word;
	ifstream dictFile;
	dictFile.open(filePath);
	
	while (!dictFile.eof()) {
		dictFile >> word;
		wordBag[word.length()].push_back(word);
	}
	dictFile.close();

	for (int i = 0; i < 16; i++) {
		int wordVectorLength = wordBag[i].size();
		char *flattenedArray = (char *)malloc(wordVectorLength*i * sizeof(char));
		for (int j = 0; j < wordVectorLength; j++) {
			for (int k = 0; k < i; k++) {
				flattenedArray[i*j+k] = wordBag[i][j][k];
			}
		}
		dict[i] = flattenedArray;
	}
	
	getchar();
	return dict;
}


void util::random_ints(int* a, int n)
{
	int i;
	for (i = 0; i < n; ++i)
		a[i] = rand() % 100;
}

int main()
{
	char** dictionary = getDictionary("C:\\Users\\DrMur\\dict.txt");
	char* d_dictionary;

	char* encodedStrings;


	//C:\Users\DrMur\dict.txt
    //const int arraySize = 5;
    //const int a[arraySize] = { 1, 2, 3, 4, 5 };
    //const int b[arraySize] = { 10, 20, 30, 40, 50 };
    //int c[arraySize] = { 0 };

	int *x, *y, *z;
	int *d_x, *d_y, *d_z;

	// int size = sizeof(int);
	int size = N * sizeof(int);

	cudaMalloc((void**)&d_x, size);
	cudaMalloc((void**)&d_y, size);
	cudaMalloc((void**)&d_z, size);

	x = (int *)malloc(size); util::random_ints(x, N);
	y = (int *)malloc(size); util::random_ints(y, N);
	z = (int *)malloc(size);
	
	cudaMemcpy(d_x, x, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_y, y, size, cudaMemcpyHostToDevice);

	simpleVectorAdd<<<N/ THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>(d_x, d_y, d_z,N);

	cudaMemcpy(z, d_z, size, cudaMemcpyDeviceToHost);
	for (int i = 0; i < N; i++) {
		printf("[z%d,%d],", i,z[i]);
	}
	free(x);
	free(y);
	free(z);
	cudaFree(d_x);
	cudaFree(d_y);
	cudaFree(d_z);

	//myFirstKernel<<<100,100>>>();
	printf("Hello world!\n");
	getchar();

    //// Add vectors in parallel.
    //cudaError_t cudaStatus = addWithCuda(c, a, b, arraySize);
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "addWithCuda failed!");
    //    return 1;
    //}

    //printf("{1,2,3,4,5} + {10,20,30,40,50} = {%d,%d,%d,%d,%d}\n",
    //    c[0], c[1], c[2], c[3], c[4]);

    //// cudaDeviceReset must be called before exiting in order for profiling and
    //// tracing tools such as Nsight and Visual Profiler to show complete traces.
    //cudaStatus = cudaDeviceReset();
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "cudaDeviceReset failed!");
    //    return 1;
    //}

    return 0;
}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size)
{
    int *dev_a = 0;
    int *dev_b = 0;
    int *dev_c = 0;
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        goto Error;
    }

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
    addKernel<<<1, size>>>(dev_c, dev_a, dev_b);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
    return cudaStatus;
}
