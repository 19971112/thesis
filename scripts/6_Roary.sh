#!/bin/sh
#PBS -q small
#PBS -l ncpus=40
#PBS -l mem=95G
#PBS -V
cd ${PBS_O_WORKDIR}

# 新しいデータセットの作成
cd ./data

mkdir -p dataset2

TYPE="_genomic.gbff.gz"
organism_name='Geobacter'
organism_name2='Pelobacter' # Desulfuromonadales

cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 > DL_list
cat assembly_summary_refseq.txt | awk -F "\t" '$5 ~ /reference|representative/ && $8 ~ /'"$organism_name2"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 >> DL_list
cat DL_list | while read FILE; do LINE=$(echo $FILE | sed -n 1p); NAME=$(echo $LINE | cut -d "/" -f 10 ); echo $LINE/$NAME$TYPE >> DL_path.txt; done
wget -i DL_path.txt
gunzip *.gz
cp /home/t16965tw/data/GSbR/Geobacter_sp._SbR.gbff .
mv *.gbff dataset2
cd ..

# Roaryの実行
mkdir -p analysis/Roary/gff && cd $_
perl ../../../scripts/bp_genbank2gff3.pl ../../../data/dataset2/*.gbff
cd ..

# Roaryの実行
roary -f ./i90/ -e -p 40 -n -i 90 -g 500000 -v ./gff/*.gff
roary -f ./i95/ -e -p 40 -n -i 95 -g 500000 -v ./gff/*.gff
# roary -f ./roary_Geobacter_spp_i90/ -e -p 40 -n -i 90 -g 500000 -v ./dataset/*.gff



