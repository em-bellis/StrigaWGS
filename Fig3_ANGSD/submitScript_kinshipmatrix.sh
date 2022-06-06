#!/bin/bash
#SBATCH --job-name=aby
#SBATCH --partition tres72
#SBATCH --output zzz.%j.out
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR 
module load gsl

### estimate genotype probabilities
angsd -GL 1 -out genolike -nThreads 32 -doCounts 1 -setMinDepth 50 -setMaxDepth 500 -doMajorMinor 1 -doMaf 1 -doGeno 8 -doPost 1 -SNP_pval 1e-6 -skipTriallelic 1 -bam bam.filelist -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -ref ../../StrigaHer_500.fasta 

### 
