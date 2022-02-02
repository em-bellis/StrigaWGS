## author: Alan Kronberger

files = ["pvals_case_top_merged_sorted.txt", "pvals_control_top_merged_sorted.txt"]
output = open("output.txt", "w")
for file in files:
    fd = open(file, "r")
    line = fd.readline()
    while line != '':
        parts = line.split("\t")
        print(parts)
        kmer = parts[1]
        pop1 = 0
        pop2 = 0
        for i in range(5, 17):
            if int(parts[i]) > 0:
                pop1 += 1
        for i in range(17, 29):
            if int(parts[i]) > 0:
                pop2 += 1

        output.write(f"{kmer}\t{pop1}\t{pop2}\n")
        line = fd.readline()
    fd.close()
output.close()
