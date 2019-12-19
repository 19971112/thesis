#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
#PBS -V

cd ${PBS_O_WORKDIR}

mkdir -p ./data && cd $_
mkdir -p $(date +%F) 

# Downloading assembly_summary_refseq.txt files
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt

TYPE="_genomic.gbff.gz"
organism_name='Desulfuromonas|Desulfuromusa|Malonomonas|Geopsychrobacter|Geoalkalibacter|Pelobacter|Geobacter' # Desulfuromonadales
organism_name2='Stigmatella|Corallococcus|Myxococcus|Anaeromyxobacter|Haliangium|Sorangium' # Myxococcales

cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 > DL_list
cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name2"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 >> DL_list
cat DL_list | while read FILE; do LINE=$(echo $FILE | sed -n 1p); NAME=$(echo $LINE | cut -d "/" -f 10 ); echo $LINE/$NAME$TYPE >> DL_path.txt; done
wget -i DL_path.txt
gunzip *.gz

mv *.gbff $(date +%F) 
