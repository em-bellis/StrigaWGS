library(tidyverse)
library(pheatmap)

kin <- read.table('ALL.dist', skip = 2)
kin <- as.matrix(kin[,-1])
labs <- read.csv('Striga_GPS_sequenced.csv', header = T)
labs$Site <- as.factor(str_replace(labs$Site, "2","") %>% str_trim())

rownames(kin) <- as.factor(labs$SampleID)
colnames(kin) <- as.factor(labs$SampleID)

### for annotations
host_df = data.frame(as.factor("Host" = labs$Host))
rownames(host_df) = rownames(kin)

site_df = data.frame(as.factor("Site" = labs$Site))
rownames(site_df) = rownames(kin)

ann_colors <- list(Host = c('finger millet' = "#1B9E77", maize = "aquamarine", sorghum = "plum", sugarcane = "darkorchid"),
                   Site = c(Chemelil= "#628395", 'Homa Bay' = "#C5D86D", Kibos ="#DB2763", Kisii = "#17377A", Muhoroni ="#FC471E", Mumias ="#55DDE0"))

p <- pheatmap(kin, color = magma(100), annotation_col = host_df, annotation_row = site_df, show_rownames = F, border_color = NA,  
         annotation_colors = ann_colors, legend = F, fontsize_col = 4)
           
pdf("FigX_heatmap.pdf", height = 4, width = 6.5)      
p         
dev.off()
