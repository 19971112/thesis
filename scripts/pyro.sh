#PBS -q small
#PBS -l ncpus=1
#PBS -V
cd ${PBS_O_WORKDIR}

cd ./analysis/Roary/i90
python ../../../scripts/replace.py ../../../data/replacelist/replacelist2.txt core_gene_alignment.aln | sed -e 's/.gbff//g' > rename_core_gene_alignment.aln
FastTree -gtr -nt rename_core_gene_alignment.aln > rename_core_gene_alignment.aln.newick
