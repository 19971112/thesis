#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}


# Creating directories
mkdir -p ./data/genbank && cd $_

# Downloading assembly_summary_refseq.txt files
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt
organism_name="Geobacter"
outgroup="Pelobacter propionicus"
TYPE="_genomic.gbff.gz"
cat assembly_summary_refseq.txt | awk -F "\t" '$5 ~ /reference|representative/ && $8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /Complete Genome/ {print $0}' | cut -f20 > filepath_$organism_name
cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$outgroup"'/ && $11=="latest" {print $0}' | cut -f20 >> filepath_$organism_name
cat filepath_$organism_name | while read FILE; do LINE=$(echo $FILE | sed -n 1p); NAME=$(echo $LINE | cut -d "/" -f 10 ); echo $LINE/$NAME$TYPE >> lists$organism_name.txt; done
wget -i lists$organism_name.txt
gunzip *.gz
