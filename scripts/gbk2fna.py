import sys
from Bio import SeqIO
filename = sys.argv[1] # Takes first command line argument input filename

from Bio import SeqIO
SeqIO.convert(filename, "genbank", filename+".fasta", "fasta")
