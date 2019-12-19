library("seqinr") # Loading seqinr package

FILE <- commandArgs(trailingOnly=TRUE)[1]

ACCESSION <- FILE
seqs <- read.fasta(file = paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=",ACCESSION,"&rettype=fasta_cds_na&retmode=text"), seqtype="DNA", strip.desc=TRUE)

# Writing sequence data out as a FASTA file
write.fasta(sequences=seqs, names=getAnnot(seqs), file.out=paste0(ACCESSION,".ffn"))

# Reading sequence data into R
filename <- paste0(ACCESSION,".ffn")
seqs <- read.fasta(file=filename, seqtype="DNA", strip.desc=TRUE)

# Compute codon usage for a set of highly expressed genes (high) and the genome as a whole (all),
# and export data as a CSV file to be read by spreadsheets:

# 全遺伝子群(all)のコドン使用頻度
# Codon usage for the collection of all genes
df.uco.all <- uco(unlist(seqs), as.data.frame=TRUE)
OUTPUT1 <- paste("table.", ACCESSION, ".uco.all.csv", sep = "")
write.csv(df.uco.all[order(df.uco.all$AA),], file=OUTPUT1, quote=TRUE, row.names=FALSE)

# 高発現遺伝子群(high)のコドン使用頻度
# Codon usage for the collection of highly expressed genes encoding ribosomal proteins
pattern <- "ribosomal protein"
TF <- grepl(pattern = pattern, x = getAnnot(seqs), ignore.case = TRUE)
sum(TF) # unlist(getAnnot(seqs[TF]))
df.uco.high <- uco(unlist(seqs[TF]), as.data.frame=TRUE)
OUTPUT2 <- paste("table.", ACCESSION, ".uco.high.csv", sep = "")
write.csv(df.uco.high[order(df.uco.high$AA),], file=OUTPUT2, quote=TRUE, row.names=FALSE)

df1=read.table(OUTPUT1, header=TRUE, sep=",")
colnames(df1) <- c("AA","codon","eff_all","freq_all","RSCU_all")
df2=read.table(OUTPUT2, header=TRUE, sep=",")
colnames(df2) <- c("AA","codon","eff_high","freq_high","RSCU_high")

df3 <- merge ( df1, df2, all=TRUE )
OUTPUT3 <- paste("table.", ACCESSION, ".uco.csv", sep = "")
write.csv(df3, file=OUTPUT3, quote=TRUE, row.names=FALSE)
