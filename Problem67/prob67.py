#! python3
def loadData(baseCase = True):
    data = []
    with open('prob67.dat') as f:
        for line in f:
            data.append([int(elem) for elem in line.split(' ')])
    return data

def compare(n,m,tri):
    return tri[n][m] + tri[n+1][m] if tri[n+1][m] >= tri[n+1][m+1] else tri[n][m] + tri[n+1][m+1]

def prob67(data):
    for dataRowIdx in range(len(data)-2,-1,-1):
        data[dataRowIdx] = [compare(dataRowIdx, elemIdx, data) for elemIdx in range(len(data[dataRowIdx]))]
    return data[0][0]

def main():
    print(prob67(loadData()))


if __name__ == "__main__":
    main()