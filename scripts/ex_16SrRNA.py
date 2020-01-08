from Bio import SeqIO, SeqFeature
import sys

FNAME = sys.argv[1]

gbank=SeqIO.parse(open(FNAME,"rU"),"genbank")

i=0
for genome in gbank:
    for gene in genome.features:
        if gene.type=="rRNA":
            if 'product' in gene.qualifiers:
                if '16S' in gene.qualifiers['product'][0]:
                    seq_slice = gene.location.extract(parental_seq)
                    i = i+1
                    if 'db_xref' in gene.qualifiers:
                        print(">%s_%s\n%s" % (FNAME,i,seq_slice))
                    else:
                        print(">%s_%s\n%s" % (FNAME,i,seq_slice))
