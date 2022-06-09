library(tidyverse)
library(jcolors)

# read in files
km <- read.table('ang.kisii_mz.out.mafs', header = T)
kf <- read.table('ang.kisii_fm.out.mafs', header = T) 

# haustorium loci of interest
km$host <- "maize"
kf$host <- "finger millet"

df <- rbind.data.frame(km, kf)
haus_1 <- subset(df, chromo == "StHeBC4_h_c11261_g0_i1")

p <- ggplot(haus_1, aes(x = position, y = knownEM, col = nInd)) +
  geom_point(alpha = 0.6) +
  facet_grid(host~.) + #, labeller = labeller(chromo = haus_names)) +
  #scale_color_manual(name = "Host", values = paste0(jcolors(palette="pal5")[c(1,3,2)])) +
  #scale_size_binned(range = c(0,3)) +
  theme_bw() +
  theme(panel.grid.minor = element_blank(), 
        panel.grid.major.x = element_blank(),
        strip.text.y = element_text(size = 7),
        legend.position = 'right',
        axis.text.x = element_text(angle = 90, hjust = 1.25)) +
  ylab("Minor Allele Frequency")

pdf("Fig3_chemo.pdf", width = 3, height = 2.5)
p
dev.off()

