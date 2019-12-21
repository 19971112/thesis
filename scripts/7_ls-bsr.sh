#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
#PBS -V

mkdir -p analysis/ls-bsr && cd $_

mkdir {data,db,query}

# make database (fna)
cp ../../data/dataset/*.gbff ./data
for f in ./data/*.gbff; do python ../../scripts/gbk2fna.py $f; done
mv data/*.fasta db

# make query (faa)
for f in ./data/*.gbff; do python ../../scripts/gbk2faa.py $f > ./data/$f.faa; done

