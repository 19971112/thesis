from Bio import SeqIO, SeqFeature
from Bio.Alphabet import IUPAC
import sys

FNAME = sys.argv[1]

gbank=SeqIO.parse(open(FNAME,"rU"),"genbank")

for genome in gbank:
    i = 0
    parental_seq = genome.seq
    for gene in genome.features:
        if gene.type=="rRNA":
            if 'product' in gene.qualifiers:
                if '16S' in gene.qualifiers['product'][0]:
                    seq_slice = gene.location.extract(parental_seq)
                    i = i+1
                    if 'db_xref' in gene.qualifiers:
                        gi=[]
                        gi=str(gene.qualifiers['db_xref'])
                        gi=gi.split(":")[1]
                        gi=gi.split("'")[0]
                        print(">GeneId|%s|16SrRNA_%s|%s\n%s" % (gi,i,genome.description,seq_slice))
                    else:
                        print(">GeneId|NoGenID|16SrRNA_%s|%s\n%s" % (i,genome.description,seq_slice))
