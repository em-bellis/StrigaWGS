import sys
import os
import codecs

### open files from command line args
inBlastPGP = open(sys.argv[1], 'r')
inBlastSh = open(sys.argv[2],'r')
inAnn = codecs.open(sys.argv[3], 'r', encoding='utf-8', errors='ignore')
outTable = open(sys.argv[4], 'w')

### open Sh14 annotation file and save annotation for each contig name
contigs = inAnn.readline().strip().split("\t")
annotations = {}

try:
    while contigs != "":
        SeqName = contigs[0]
        desc = contigs[1].replace('"','')
        annotations[SeqName] = desc
        contigs = inAnn.readline().strip("\n").split("\t")
except:
    print('') # not sure why I'm getting index error...just escape it

### read in blast table 1 and save hit name if it's good
line = inBlastPGP.readline()
blastPGP = {}
while line != '':
    lineParts = line.split("\t")
    if (int(lineParts[3]) >= 45) & (float(lineParts[2]) >= 85.00):
        blastPGP[str(lineParts[0])] = lineParts[1]
    line = inBlastPGP.readline()

### read in blast table 2 and save hit name if it's good
line = inBlastSh.readline()
blastSh = {}
while line != '':
    lineParts = line.split("\t")
    if (int(lineParts[3]) >= 45) & (float(lineParts[2]) >= 85.00):
        blastSh[str(lineParts[0])] = lineParts[1]
    line = inBlastSh.readline()

### get a list of unique kmers
shKeys = list(blastSh.keys())
pgppKeys = list(blastPGP.keys())
kmers = shKeys + list(set(pgppKeys) - set(shKeys))

### write table to file
outTable.write(f'Kmer\thitPGPP\thitSh\tDesc\n')
for i in kmers:
    i = str(i)
    if i in blastSh:
        hitSh = blastSh[i]
        if blastSh[i] in annotations:
            desc = annotations[blastSh[i]]
    else:
        hitSh = 'None'
        desc = 'None'
    if i in blastPGP:
        hitPGP = blastPGP[i]
    else:
        hitPGP = 'None'

    outTable.write(f'{i}\t{hitPGP}\t{hitSh}\t{desc}\n')

inAnn.close()
inBlastPGP.close()
inBlastSh.close()
outTable.close()
