library(ggplot2)
library(readr)


args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
output <- args[2]

pcs <- read_table(input)
my_plot <- ggplot(pcs) + geom_point(aes(x = PC1, y = PC2))
ggsave(my_plot,  file = output, height = 4, width = 5, units = "in", dpi = 300)
