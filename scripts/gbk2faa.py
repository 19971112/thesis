import sys
from Bio import SeqIO
filename = sys.argv[1] # Takes first command line argument input filename
for record in SeqIO.parse(filename, "genbank"):
    for feature in record.features:
        if feature.type == "CDS":
            locus_tag = feature.qualifiers.get("locus_tag", [""])[0]
            protein_id = feature.qualifiers.get("protein_id", [""])[0]
            gene = feature.qualifiers.get("gene", [""])[0]
            product = feature.qualifiers.get("product", [""])[0]
            translation = feature.qualifiers.get("translation", [""])[0]
            print(">%s %s %s %s\n%s" % (locus_tag, protein_id, gene, product, translation))
