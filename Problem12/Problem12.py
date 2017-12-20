#! python3

# from itertools import *
from decimal import Decimal
from copy import copy
from math import floor
import sys

GetNthTriangleNumber = lambda n: n*(n+1)/2

def GetDivisors(n):
    divisors = []
    start = floor(n**(.5))+1
    while start > 0:
        if not n%start:
            divisors.append(start)
        start -= 1
    return divisors + [n]

def GetFirstTriangleNumberWithNDivisors(n):
    leap = 1
    while len(GetDivisors(GetNthTriangleNumber(leap)))<n:
        leap += leap
    peak = leap
    offset = int(peak/4)
    while offset>1:#peak-offset > floor(peak/2):
        if len(GetDivisors(GetNthTriangleNumber(peak-offset)))>n:
            offset += offset/2
        else:
            offset -= offset/2
    return GetNthTriangleNumber(peak-offset)      

def test():
    print("3 == GetDivisors(9)", GetDivisors(378))
    #print("Get first triangle number with 500 divisors",GetFirstTriangleNumberWithNDivisors(10))
    past = (0,0)
    x=1
    while past[0] < 500:
        current = len(GetDivisors(GetNthTriangleNumber(x)))
        if current > past[0]:
            past = (current,GetNthTriangleNumber(x))
            print(past)
        x+=1
def main():
    test()

if __name__ == "__main__":
    main()
