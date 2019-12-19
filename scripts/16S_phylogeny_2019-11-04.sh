#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}
source activate bio

# extracting 16S rRNA sequence from GenBank files and concatenate
mkdir -p data/16S
for i in data/dataset/*.gbff; do python scripts/ex_16SrRNA_2019-11-04.py $i > $i.16S.fasta; mv $i.16S.fasta data/16S; done
cat data/16S/*.16S.fasta | sed -e 's/ /_/g' | sed -e 's/,/_/g' | sed -e 's/___/_/g' > data/16S/all.fasta

# Multiple alignment
mkdir -p analysis/16S_phylogeny
mafft --auto data/16S/all.fasta > analysis/16S_phylogeny/16S.maf

# phylogeny
FastTree -gtr -nt analysis/16S_phylogeny/16S.maf > analysis/16S_phylogeny/16S.maf.newick

######################################################################################################

# extracting 16S rRNA sequence from GenBank files and concatenate
mkdir -p data/16S_2
for i in data/dataset2/*.gbff; do python scripts/ex_16SrRNA_2019-11-04.py $i > $i.16S.fasta; mv $i.16S.fasta data/16S_2; done
cat data/16S_2/*.16S.fasta | sed -e 's/ /_/g' | sed -e 's/,/_/g' | sed -e 's/___/_/g' > data/16S_2/all.fasta

# Multiple alignment
mkdir -p analysis/16S_phylogeny2
mafft --auto data/16S_2/all.fasta > analysis/16S_phylogeny2/16S.maf

# phylogeny
FastTree -gtr -nt analysis/16S_phylogeny2/16S.maf > analysis/16S_phylogeny2/16S.maf.newick
