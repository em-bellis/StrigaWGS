#!/bin/bash
#SBATCH --job-name=krakenbuild
#SBATCH --partition comp01
#SBATCH --output zzz.%j.out
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --time=00:30:00

cd $SLURM_SUBMIT_DIR 
module load blast/2.9.0+
#kraken2-build --download-library plant --db plant_wSH --threads 32
#kraken2-build --add-to-library doi_10/SGA.v2.krak.fa --db plant_wSH --threads 32
#kraken2-build --add-to-library StHeBC4.krak.fasta --db plant_wSH --threads 32
#kraken2-build --build --db plant_wSH --threads 1
kraken2 --db plant_wSH --gzip-compressed --paired --report kraken_report --use-names --threads 32 --classified-out SH009#.fq 19137Ljy_N19121/SH009_S29_L004_R1_001.fastq.gz 19137Ljy_N19121/SH009_S29_L004_R2_001.fastq.gz >kraken_out
