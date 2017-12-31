#! python3

def prob16():
    powerProduct = 2**1000
    pProdStr = str(powerProduct)
    sum = 0
    for digit in pProdStr:
        sum += int(digit)
    return sum

def main():
    print(prob16())


if __name__ == "__main__":
    main()