#PBS -q small
#PBS -l mem=80G
#PBS -l ncpus=40
#PBS -V
cd ${PBS_O_WORKDIR}

cd analysis/ls-bsr
# run LS-BSR
python /home/t16965tw/downloads/LS-BSR/ls_bsr.py -p 40 -d db -g query/all.fasta
