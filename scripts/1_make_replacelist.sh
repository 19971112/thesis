#!/bin/sh

mkdir -p data/replacelist && cd $_

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt

cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $1,"_",$16,"\t"}' | sed -e 's/ /_/g' > 1
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $8}' | cut -d " " -f 1,2 | sed -e 's/ /_/g' > 2
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print "_", $9}' | sed -e 's/strain=//g' | sed -e 's/ /_/g' > 3
paste -d "" 1 2 3 > replacelist0.txt

cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $1,"_",$16,"_genomic","\t"}' | sed -e 's/ /_/g' > 1
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $8}' | cut -d " " -f 1,2 | sed -e 's/ /_/g' > 2
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print "_", $9}' | sed -e 's/strain=//g' | sed -e 's/ /_/g' > 3
paste -d "" 1 2 3 > replacelist1.txt

cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $1,"_",$16,"_genomic.gbff","\t"}' | sed -e 's/ /_/g' > 1
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $8}' | cut -d " " -f 1,2 | sed -e 's/ /_/g' > 2
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print "_", $9}' | sed -e 's/strain=//g' | sed -e 's/ /_/g' > 3
paste -d "" 1 2 3 > replacelist2.txt

cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $1,"_",$16,"_genomic.fna","\t"}' | sed -e 's/ /_/g' > 1
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $8}' | cut -d " " -f 1,2 | sed -e 's/ /_/g' > 2
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print "_", $9}' | sed -e 's/strain=//g' | sed -e 's/ /_/g' > 3
paste -d "" 1 2 3 > replacelist3.txt

cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $1,"_",$16,"_genomic.faa","\t"}' | sed -e 's/ /_/g' > 1
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print $8}' | cut -d " " -f 1,2 | sed -e 's/ /_/g' > 2
cat assembly_summary.txt | awk -F "\t" -v 'OFS=' '{print "_", $9}' | sed -e 's/strain=//g' | sed -e 's/ /_/g' > 3
paste -d "" 1 2 3 > replacelist4.txt
