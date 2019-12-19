# rcmd_wca.txt
# http://cse.naro.affrc.go.jp/takezawa/r-tips/r/53.html

cat("\n# This R script performs amino acid or codon usage analyses.")
cat("\n#  Usage: Rscript --vanilla g_each.R . \n\n")

args <- commandArgs(TRUE)
mydir <- args[1]

# Set Working Directory
# mydir <- "/Users/haruo/projects/jc923/nckuh21/2017-07-01_each/"; setwd(mydir) 

naxis <- 3; cor.method <- "pearson"; #cor.method <- "spearman";

for(myfile in dir(path = mydir, pattern=".[ACR][014].txt")){ ##### 
# myfile <- "_BDSN01000001-BDSN01000094.R0.txt"
# myfile <- "_BDSN01000001-BDSN01000094.A0.txt"
# myfile <- "SRR3546351_0nltkR4.txt"

if(regexpr(".txt$", myfile) < 0) next;
if(regexpr("^log.", myfile) > 0) next;

# ndc = 61;
if(regexpr(".R0.txt", myfile) > 0){ ndc = 59; method = "wca"; jj = c("Comp1", "Comp2", "Comp3"); jj = c("SCU1", "SCU2", "SCU3"); ii = c("gcc3", "gtc3", "P2"); ii = c("GC3", "GT3", "P2"); }

if(regexpr(".R4.txt", myfile) > 0){ ndc = 59; method = "pca"; jj = c("PC1", "PC2", "PC3"); ii = c("gcc3", "gtc3", "P2"); ii = c("GC3", "GT3", "P2"); }

if(regexpr(".A[01].txt", myfile) > 0){ ndc = 20; method = "coa"; jj = c("Axis1", "Axis2", "Axis3"); jj = c("AAU1", "AAU2", "AAU3"); ii = c("aroma", "gravy", "mmw"); ii = c("AROMA", "GRAVY", "MMW"); } # "CMHFYW"

#pattern="A1"; ndc = 20; method = "pca"; jj = c("PC1", "PC2", "PC3"); ii = c("aroma", "gravy", "mmw"); 

# Loading Data into R
dat <- read.delim(myfile, stringsAsFactors=FALSE, check.names=FALSE); dim(dat)
#TF <- dat[,"Laa"] > 100; sum(TF); dat <- dat[TF,]

if(nrow(dat) < 20) next;

cat(myfile,"\n")

# multivariate analysis
usage = dat[,1:ndc] # usage = as.matrix(dat[,1:ndc])

# omits columns where SD is zero
omit = c()
for(i in 1:ncol(usage)) if(sd(usage[,i]) == 0) omit = c(omit, i)
if(length(omit)) usage = usage[,-omit]

if(method == "coa"){ # correspondence analysis
library(ade4)
coa = dudi.coa(as.data.frame(usage), scannf = FALSE, nf = min(dim(usage)))
score = coa$li[,1:naxis]
contribution = (100*coa$eig/sum(coa$eig))[1:naxis]
 } else if(method == "wca"){ # within-group correspondence analysis
library(ade4)
coa = dudi.coa(as.data.frame(t(usage)), scannf=FALSE, nf=min(dim(usage)))
facaa = as.factor(substring(rownames(coa$tab),1,1))
wca = wca(coa, fac = facaa, scannf = FALSE, nf=min(dim(usage)))
score = wca$co[,1:naxis]
contribution = (100*wca$eig/sum(wca$eig))[1:naxis]
 } else if(method == "pca"){ # principal component analysis
pr = prcomp(usage, center = T, scale = F);
score = pr$x[,1:naxis];
contribution = 100*summary(pr)$importance[2,][1:naxis];
}
#factorloading = cor(usage, score)[,1:naxis]; plot(factorloading[,1:2],type="n"); text(factorloading[,1:2],label=rownames(factorloading))
colnames(score) = gsub(colnames(score), pattern="Comp", replacement="SCU", perl=T)
colnames(score) = gsub(colnames(score), pattern="Axis", replacement="AAU", perl=T)
# z.score
names(contribution) = colnames(score)
z.score = apply(score, 2, scale); dat = cbind(dat, z.score)

out = dat[,c("locus_tag", "Laa", "aroma", "gravy", "mmw", "gcc3", "gtc3", "P2", jj, "gene", "product", "highlyExpressed")] # "leading"
colnames(out) = gsub(colnames(out), pattern="aroma", replacement="AROMA")
colnames(out) = gsub(colnames(out), pattern="gravy", replacement="GRAVY")
colnames(out) = gsub(colnames(out), pattern="mmw", replacement="MMW")
colnames(out) = gsub(colnames(out), pattern="gcc3", replacement="GC3")
colnames(out) = gsub(colnames(out), pattern="gtc3", replacement="GT3")
write.csv(out, paste0("./Rtable.",myfile,".",method,".csv"), row.names=FALSE, quote=TRUE)

pdf(paste0("./Rplot.",myfile,".",method,".pdf"), pointsize=10, width=5, height=5)

### correlation plots
idx <- out[,c("Laa", "AROMA", "GRAVY", "MMW", "GC3", "GT3", "P2", jj)]
round(cor(idx), 3)
# install.packages("psych") # library(psych); pairs.panels(idx)

### gene group
TF <- out[,"highlyExpressed"] == 1; sum(TF); out[TF,"product"] # "leading"
#TF <- regexpr("ribosomal.protein |elongation.factor ", out[,"product"], ignore.case=TRUE) > 0 & regexpr("transferase", out[,"product"], ignore.case=TRUE) < 0; sum(TF); out[TF,"product"]

### plots 3 x 3
par(mfrow=c(3,3), mgp=c(2, 1, 0), mar=c(3, 3, 3, 1), cex=0.5) # mar = c(底左上右)
num <- 0
for(j in jj){ 
for(i in ii){ #
x = out[,i]; y = out[,j]
r <- cor(x, y, method=cor.method); #if(r < 0) y = -y
#plot(x, y, xlab=i, ylab=j, type="n")
plot(x, y, xlab=i, ylab=paste0(j, " (",round(contribution[j],1),"%)"), #  of variance
type="n")
pch=20; cex=0.8
#points(x, y, pch=pch, cex=cex, col=1)
mycolor = c("black","red","blue") # c(1,2,3)
points(x[!TF], y[!TF], pch=".", cex=cex, col=mycolor[1])
points(x[TF], y[TF], pch=pch, cex=cex, col=mycolor[2])
#title(paste0("|r| = ", round(r,3), "; |z| = ", round(abs(mean(y[TF])),3) ))
title(paste0("r = ", round(r,3) ))
num <- num + 1
legend("topleft", legend=paste0("(",letters[num],")"), box.lty=0)
#title(basename(myfile))
} }

### plot
par(mfcol=c(1,1), mgp=c(2, 1, 0), mar=c(3, 3, 0.5, 0.5), cex=1) # mar = c(底左上右)
i = "GC3"; j = "SCU1"; # i = "GT3"; j = "SCU2"
i <- jj[1]
j <- jj[2]
x = out[,i]; y = out[,j]
r = cor(x, y, method=cor.method); #if(r < 0) y = -y
#plot(x, y, xlab=i, ylab=j, type="n")
plot(x, y, 
#xlab=i, 
xlab=paste0(i, " (",round(contribution[i],1),"%)"), #  of variance
ylab=paste0(j, " (",round(contribution[j],1),"%)"), #  of variance
type="n")
pch=20; cex=1
#points(x, y, pch=pch, cex=cex, col=1)
mycolor = c("black","red","blue") # c(1,2,3)
points(x[!TF], y[!TF], pch=".", cex=cex, col=mycolor[1])
points(x[TF], y[TF], pch=pch, cex=cex, col=mycolor[2])

} #####

dev.off()

# Print R version and packages
sessionInfo()
