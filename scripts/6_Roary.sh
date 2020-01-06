#!/bin/sh
#PBS -q small
#PBS -l ncpus=40
#PBS -V
cd ${PBS_O_WORKDIR}

mkdir -p analysis/Roary && cd $_

mkdir -p {gbff,gff}

# データセットのコピー
# cp ../../data/dataset/*.gbff ./gbff

cd gff
perl ../../../scripts/bp_genbank2gff3.pl ../../../data/dataset/*.gbff
cd ..

# Roaryの実行
roary -f ./i90/ -e -p 40 -n -i 90 -g 500000 -v ./dataset/*.gff
roary -f ./i95/ -e -p 40 -n -i 95 -g 500000 -v ./dataset/*.gff
# roary -f ./roary_Geobacter_spp_i90/ -e -p 40 -n -i 90 -g 500000 -v ./dataset/*.gff
