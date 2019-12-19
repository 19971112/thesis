#!/bin/sh
#PBS -q small
#PBS -l ncpus=1
#PBS -V

cd ${PBS_O_WORKDIR}

mkdir -p ./data && cd $_
mkdir -p dataset3

# Downloading assembly_summary_refseq.txt files
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt

TYPE="_genomic.gbff.gz"
organism_name='Geobacter'
organism_name2='Desulfuromonas|Desulfuromusa|Malonomonas|Geopsychrobacter|Geoalkalibacter|Pelobacter|Stigmatella|Corallococcus|Myxococcus|Anaeromyxobacter|Haliangium|Sorangium' # Desulfuromonadales

cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 > DL_list3
cat assembly_summary_refseq.txt | awk -F "\t" '$5 ~ /reference|representative/ && $8 ~ /'"$organism_name2"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 >> DL_list3

cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f8,9,12 | sort -k1,1 -k2,2 > DL_Name_list3
cat assembly_summary_refseq.txt | awk -F "\t" '$5 ~ /reference|representative/ && $8 ~ /'"$organism_name2"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f8,9,12 | sort -k1,1 -k2,2 >> DL_Name_list3
cat DL_list3 | while read FILE; do LINE=$(echo $FILE | sed -n 1p); NAME=$(echo $LINE | cut -d "/" -f 10 ); echo $LINE/$NAME$TYPE >> DL_path3.txt; done
wget -i DL_path3.txt
gunzip *.gz

mv *.gbff dataset3
