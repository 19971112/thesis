#PBS -q small
#PBS -l ncpus=40
#PBS -V
cd ${PBS_O_WORKDIR}
conda activate ls_bsr

mkdir -p analysis/ls-bsr && cd $_
mkdir {data,db,query}

# make database (fna)
cp ../../data/dataset/*.gbff ./data
for f in ./data/*.gbff; do python ../../scripts/gbk2fna.py $f; done
mv data/*.fasta db

# make query (faa)
for f in ./data/*.gbff; do python ../../scripts/gbk2faa.py $f > $f.faa; done
cat data/*.faa > data/all.faa
mv data/all.faa query

# run LS-BSR
python /home/t16965tw/downloads/LS-BSR/ls_bsr.py -p 40 -d db -g query/all.faa
