
args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
output <- args[2]

pcs <- read.table(input)
png(output, height = 4, width = 5, units = "in", res = 300)
plot(pcs$V2, pcs$V3, xlab = "PC1", ylab = "PC2", pch = 16)
dev.off()
