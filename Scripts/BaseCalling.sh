#!/bin/bash

#$ -l gpu,A100,gpu_mem=1G,h_rt=01:00:00
#$ -pe shared 1
#$ -N KEARBaseCalling
#$ -cwd
#$ -m bea
#$ -o /u/scratch/d/dechavez/Bioinformatica-PUCE/RepotenBio/KEAPUNTE/OXFORD-Nanopore/log/BaseCalling.out
#$ -e /u/scratch/d/dechavez/Bioinformatica-PUCE/RepotenBio/KEAPUNTE/OXFORD-Nanopore/log/BaseCalling.err
#$ -M dechavezv

source /u/local/Modules/default/init/modules.sh

# load anaconda
module load anaconda3/2023.03

# activate conda enviroments
conda activate NGSpeciesID

# Basecalling with SUP highest precission
dorado basecaller sup pod5/ --kit-name EXP-NBD196 > calls.bam

mkdir -p Demultiplex

# Demultiplex barcodes
dorado demux --output-dir Demultiplex/ --no-classify calls.bam 

conda deactivate
