#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}

mkdir -p analysis/RSCU && cd $_
python ../../scripts/list.py "../../data/dataset3/*.gbff" | grep -vi "plasmid" > list.txt
for i in $(cut -f1 list.txt); do Rscript ../../scripts/RSCU.R $i; done


