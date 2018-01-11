#! python2

import time
class Memoize:
    def __init__(self, fn):
        self.fn = fn
        self.memo = {}
    def __call__(self, *args):
        if args not in self.memo:
            self.memo[args] = self.fn(*args)
        return self.memo[args]

@Memoize
def getNextCollatz(n):
    if n%2:
        return 3*n+1
    return n//2

def getCollatzSeq(n):
    out = []
    while n>1:
        n = getNextCollatz(n)
        out.append(n)
    return out

def problem14():
    inputValues = range(1000000,0,-1)
    discovered = {}
    maximum = (0,0)
    for x in inputValues:
        sq = getCollatzSeq(x)
        if len(sq) > maximum[1]:
            maximum = (x,len(sq))
        removeMe = []
        for new in sq:
            if new < 1000000:
                if not new in discovered:
                    discovered[new] = 1
                    removeMe.append(new)
        for x in removeMe:
            inputValues.remove(x)
        print len(inputValues)
    return maximum

def euler14():
    maxLength = 0
    maxI = 0
    numsToCheck = range(1,1000000)
    return nextCollatzArray(numsToCheck)

def nextCollatzArray(array):
    arr = [ [elem, elem] for elem in array ]
    length = len(arr)
    while length > 1:
        for i in range(length):
            arr[i] = [ arr[i][0], nextCollatzNum( arr[i][1]) ]
        arr = [ elem for elem in arr if elem[1] ]
        length = len(arr)
    return arr[0][0]
     
def nextCollatzNum(num):
    if num == 1:
        return None
    elif num%2 == 0:
        return num/2
    else:
        return 3*num+1 

def main():
    # print problem14()
    # t0 =time.time()
    # result = euler14()
    # t1 = time.time()
    # print result
    # print t1-t0
    rsq = getCollatzSeq(837799)
    print len(rsq)
    print rsq
    rsq = getCollatzSeq(910107)
    print len(rsq)
    print rsq

if __name__ == "__main__":
    main()