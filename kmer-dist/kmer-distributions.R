library(tidyverse)
pop = c("kisii","homabay")

### load and tidy input data
for (i in 1:2) {
  gst <- read.table(paste0('~/Desktop/Projects/StigaxSorghum/KenyaWGS/alan/',pop[i],'/GST_Output.txt'))
  colnames(gst) <- c('kmer','HS','HT','DST','GST')
  gst$pop <- paste0(pop[i])
  if (i == 1) {
    gst_all <- gst
  } else {
    gst_all <- rbind.data.frame(gst_all, gst)
  }
}

### graph Gst
p <- ggplot(gst_all, aes(x = GST, col = pop)) +
  geom_density() +
  theme_classic() +
  xlab(expression(italic(G[ST]))) +
  scale_colour_discrete(name = "Population", labels = c("Homa Bay", "Kisii"))

nrow(subset(gst_all, GST >= 0.5 & pop == "kisii"))/nrow(subset(gst_all, pop == "kisii")) # 4% of kisii kmers
nrow(subset(gst_all, GST >= 0.5 & pop == "homabay"))/nrow(subset(gst_all, pop == "homabay")) # 0.6% of homa bay kmers

### extract kmers with GST >0.5 for assembly
kisii_kmer_list <- subset(gst_all, pop == "kisii" & GST >= 0.5)$kmer
homabay_kmer_list <- subset(gst_all, pop == "homabay" & GST >= 0.5)$kmer
write.table(kisii_kmer_list, "kisii_kmers_GST5.txt", row.names = F, col.names = F, sep = "\t", quote = F)
write.table(homabay_kmer_list, "homabay_kmers_GST5.txt", row.names = F, col.names = F, sep = "\t", quote = F)

pdf("kmerdist.pdf", width = 3, height = 3)
p
dev.off()
