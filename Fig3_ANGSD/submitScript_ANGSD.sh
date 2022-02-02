#!/bin/bash
#SBATCH --job-name=aby
#SBATCH --partition comp01
#SBATCH --output zzz.%j.out
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --time=01:00:00

cd $SLURM_SUBMIT_DIR 

##### estimate site frequency spectrum
#angsd -bam k.bamlist -doSaf 1 -GL 1 -P 32 -only_proper_pairs 0 -anc ../StrigaHer_500.fasta -out out.kisii -rf regions_1kb 

##### calculate per site thetas
#~/tools/angsd/misc/realSFS out.kisii.saf.idx -P 32 -fold 1 >out.kisii.sfs
#~/tools/angsd/misc/realSFS saf2theta out.kisii.saf.idx -P 32 -outname out.kisii -fold 1 -sfs out.kisii.sfs

##### estimate for every chromosome
~/tools/angsd/misc/thetaStat do_stat out.kisii.thetas.idx -win 1000 -step 1000 -outnames kisii.theta1x1kb.gz

