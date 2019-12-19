#!/bin/sh
#PBS -q small
#PBS -l ncpus=40
#PBS -V
cd ${PBS_O_WORKDIR}
source activate bio

## DATASET 1
mkdir -p analysis/phylogeny
mkdir $(date +%F) && cd $_

# Downloading assembly_summary_refseq.txt files
mkdir -p ./data
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt

TYPE="_genomic.gbff.gz"
organism_name='Desulfuromonas|Desulfuromusa|Malonomonas|Geopsychrobacter|Geoalkalibacter|Pelobacter|Geobacter' # Desulfuromonadales
organism_name2='Stigmatella|Corallococcus|Myxococcus|Anaeromyxobacter|Haliangium|Sorangium' # Myxococcales

cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 > filepath_$organism_name
cat assembly_summary_refseq.txt | awk -F "\t" '$8 ~ /'"$organism_name2"'/ && $11=="latest" && $12 ~ /Chromosome|Complete Genome/ {print $0}' | cut -f20 >> filepath_$organism_name
cat filepath_$organism_name | while read FILE; do LINE=$(echo $FILE | sed -n 1p); NAME=$(echo $LINE | cut -d "/" -f 10 ); echo $LINE/$NAME$TYPE >> lists$organism_name.txt; done
wget -i lists$organism_name.txt
gunzip *.gz

# Converting GenBank files to GFF3
perl ../../../scripts/bp_genbank2gff3.pl ./*.gbff; mv *.{gbff,gff} data/

# Running Roary
roary -f ./analysis/ -e -n -p 40 -i 90 -g 1000000 -v ./data/*.gff

# Running FastTree for core genome phylogeny
FastTree -fastest -nt -gtr analysis/core_gene_alignment.aln > analysis/core_gene_alignment.newick

# Roary plots
wget https://raw.githubusercontent.com/sanger-pathogens/Roary/master/contrib/roary_plots/roary_plots.py
python roary_plots.py analysis/core_gene_alignment.newick analysis/gene_presence_absence.csv

# Print operating system characteristics
uname -a
echo "[$(date)] $0 has been successfully completed."

# rename
cat assembly_summary_refseq.txt | awk -F "\t" -v 'OFS=' '{print $1,"_",$16,"_genomic.gbff","\t",$8}' | cut -d " " -f 1,2 | sed -e 's/ /_/g'> X
cat assembly_summary_refseq.txt | awk -F "\t" -v 'OFS=' '{print $9}' | sed -e 's/strain=//g' | sed -e 's/ /_/g' > Y
paste -d "_" X Y > replacelist.txt
python /home/t16965tw/scripts/rename.py replacelist.txt analysis/core_gene_alignment.newick > rename_core_gene_alignment.newick
cp rename_core_gene_alignment.newick rename_core_gene_alignment.newick

cd ..
