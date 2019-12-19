from Bio import SeqIO, SeqFeature
import sys

FNAME = sys.argv[1]

gbank=SeqIO.parse(open(FNAME,"rU"),"genbank")

for genome in gbank:
    NB = 0
    for gene in genome.features:
        if gene.type=="rRNA":
            if 'product' in gene.qualifiers:
                if '16S' in gene.qualifiers['product'][0]:
                    start = gene.location.nofuzzy_start
                    end = gene.location.nofuzzy_end
                    NB = NB + 1
                    if 'db_xref' in gene.qualifiers:
                        gi=[]
                        gi=str(gene.qualifiers['db_xref'])
                        gi=gi.split(":")[1]
                        gi=gi.split("'")[0]
                        print(">16SrRNA_%s|%s\n%s" % (gi,NB,genome.description,genome.seq[start:end]))
                    else:
                        print(">16SrRNA_%s|%s\n%s" % (NB,genome.description,genome.seq[start:end]))
