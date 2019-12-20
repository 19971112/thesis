#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}

# extracting 16S rRNA sequence from GenBank files and concatenate
mkdir -p data/16S
for i in data/dataset/*.gbff; do python scripts/ex_16SrRNA3.py $i > $i.16S.fasta; mv $i.16S.fasta data/16S; done
cat data/16S/*.16S.fasta | sed -e 's/data\/dataset3\///g' | sed -e 's/,/_/g' | sed -e 's/___/_/g' > data/16S/all.fasta

# Multiple alignment
mkdir -p analysis/16S_phylogeny
mafft --auto data/16S/all.fasta > analysis/16S_phylogeny/16S.maf

# phylogeny
FastTree -gtr -nt analysis/16S_phylogeny/16S.maf > analysis/16S_phylogeny/16S.maf.newick

# rename
python scripts/replace.py data/replacelist/replacelist2.txt analysis/16S_phylogeny/16S.maf.newick > analysis/16S_phylogeny/rename_16S.maf.newick
