import sys
import glob
from Bio import SeqIO
from Bio.SeqUtils import GC

import subprocess

filename = sys.argv[1]

files = glob.glob(filename)
for gbff in files: 
    for record in SeqIO.parse(gbff, 'genbank'): 
        print(rec.annotations['organism'])
#         record.description
#         print(record.description)
#         = difinition.strip("\n")
#         print(record.id,gbff,record.description,sep="\t")  

        
# cmd = "bash ./change.sh"
# subprocess.call(cmd.split())
