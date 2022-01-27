popSizes = [12, 12]
temp = 0
for i in range(len(popSizes)):
    temp += 1 / popSizes[i]

hMean = len(popSizes) / temp

def calculateHS(absent, present):
    subEF = []
    for i in range(len(popSizes)):
        subEF.append(1 - (pow(absent[i], 2) + pow(present[i], 2)))
    return (hMean/(hMean - 1)) * (sum(subEF) / len(popSizes))
    

def calculateHT(absent, present, HS):
    absentMean = sum(absent) / len(absent)
    presentMean = sum(present) / len(present)
    return (1 - (pow(absentMean, 2) + pow(presentMean, 2))) + (HS / (hMean * len(popSizes)))

def calculateDST(HS, HT):
    return HT - HS

def calculateGST(DST, HT):
    GST = 0.0
    if HT > 0:
        GST = DST / HT
    return GST

inFile = open("GST_Input.txt", "r")
outFile = open("GST_Output.txt", "w")

line = inFile.readline()
while line != "":
    parts = line.split("\t")
    kMer = parts[0]
    print(kMer)
    absent = []
    present = []
    for i in range(1, len(popSizes) + 1):
        present.append(int(parts[i]) / popSizes[i - 1])
        absent.append((popSizes[i - 1] - int(parts[i])) / popSizes[i - 1])
    HS = calculateHS(absent, present)
    HT = calculateHT(absent, present, HS)
    DST = calculateDST(HS, HT)
    GST = calculateGST(DST, HT)
    outFile.write(f"{kMer}\t{HS}\t{HT}\t{DST}\t{GST}\n")
    line = inFile.readline()
inFile.close()
outFile.close()
