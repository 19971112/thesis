# install.packages("gplots")
# source("http://bioconductor.org/biocLite.R")
# biocLite()
# biocLite("genefilter")
# biocLite("gplots")

# library(gplots)

args1 = commandArgs(trailingOnly=TRUE)[1]


args1 = "heatmap.csv"
d <- read.table(args1, sep=",", header=TRUE)
d2 <- d[, 2:29]

d2 <- as.matrix(d[, 2:29])
d2 <- as.matrix(d[, 3:29])

heatmap(d2, col=cm.colors(256))
heatmap(d2)

# install.packages(" ggplot2").
library(ggplot2)

library("heatmap3")
library(GMD)
heatmap.3(d2, trace="none", dendrogram="both", Rowv=T, Colv=T, color.FUN="redgreen", cluster.by.row=T, cluster.by.col=T, mapratio=1, mapsize=4, main="")


temp <- c(-3, 2, 1, 2, 1.2, -1.2)
col <- colByValue(temp, col = colorRampPalette(c('chartreuse4', 'white', 'firebrick'))(1024), range = c(-2,2))
