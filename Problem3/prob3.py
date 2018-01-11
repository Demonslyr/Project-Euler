#! python2

import math

'''
The prime factors of 13195 are 5, 7, 13 and 29.
What is the largest prime factor of the number 600851475143 ?
'''
class Memoize:
    def __init__(self, fn):
        self.fn = fn
        self.memo = {}
    def __call__(self, *args):
        if args not in self.memo:
            self.memo[args] = self.fn(*args)
        return self.memo[args]

@Memoize
def isPrime(num):
    for x in range(4,int(math.sqrt(num))+1):
        if num%x == 0:
            return False
    return True

#Todo
def getFactors(x):
    pass

#Todo
def getPrimeFactors(x):
    pass

def getLargestPrimeFactor(num):
    startingPoint = int(math.ceil(math.sqrt(num)))
    if startingPoint%2 == 0:
        startingPoint+=1
    for x in range(startingPoint,1,-2):
        if(num%x == 0 and isPrime(x)):
            return x

def main():
    print(getLargestPrimeFactor(600851475143))

if __name__ == "__main__":
    main()