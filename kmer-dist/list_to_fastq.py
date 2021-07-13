import sys

### open files from command line args
inKmers = open(sys.argv[1], 'r')
outKmers = open(sys.argv[2], 'w')

### read through infile list and print reformatted fastq
count = 0
for line in inKmers:
    outKmers.write(f'@{count}\n')
    outKmers.write(f'{line.strip()}\n')
    outKmers.write(f'+\n')
    outKmers.write(f'{"Z"*31}\n')
    count += 1
    

inKmers.close()
outKmers.close()
