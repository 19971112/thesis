import sys
import glob
from Bio import SeqIO
from Bio.SeqUtils import GC


filename = sys.argv[1]

files = glob.glob(filename)
for gbff in files: 
    for record in SeqIO.parse(gbff, 'genbank'): 
        print(record.id,gbff,record.description,sep="\t")  
