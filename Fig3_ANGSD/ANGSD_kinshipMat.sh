#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH --partition tres72
#SBATCH --output zzz.%j.out
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR 
module load bwa
module load samtools
module load gsl

### mapping w/bwa
bwa mem -t 32 StrigaHer_500.fasta $R1 $R2 >$SAMPLE.pe.sam
samtools view -b -F 4 -q 20 -@ 32 $SAMPLE.pe.sam | samtools sort -@ 32 - >$SAMPLE.sort.bam
samtools index $SAMPLE.sort.bam
rm -rf $SAMPLE.pe.sam

### 
