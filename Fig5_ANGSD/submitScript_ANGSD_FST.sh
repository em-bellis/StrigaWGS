#!/bin/bash
#SBATCH --job-name=aby
#SBATCH --partition comp72
#SBATCH --output zzz.%j.out
#SBATCH --nodes=1
#SBATCH --tasks-per-node=32
#SBATCH --time=72:00:00

cd $SLURM_SUBMIT_DIR 

##### estimate site frequency spectrum
#angsd -bam kf.bamlist -doSaf 1 -GL 1 -P 32 -only_proper_pairs 0 -anc ../StrigaHer_500.fasta -out kf -rf regions_1kb
~/tools/angsd/angsd -bam km.bamlist -doSaf 1 -GL 1 -P 32 -only_proper_pairs 0 -anc ../StrigaHer_500.fasta -out km -rf regions_1kb

##### calculate 2dsfs prior
~/tools/angsd/misc/realSFS kf.saf.idx km.saf.idx -P 32 -fold 1 >kf.km.ml

##### prepare the fst for easy window analysis
~/tools/angsd/misc/realSFS fst index kf.saf.idx km.saf.idx -P 32 -sfs kf.km.ml -fold 1 -fstout kf.km

##### get the global estimate
~/tools/angsd/misc/realSFS fst stats kf.km.fst.idx -fold 1

##### estimate for every chromosome
~/tools/angsd/misc/realSFS fst stats2 kf.km.fst.idx -fold 1 -win 1000 -step 1000 >kf.km.fst_1x1
