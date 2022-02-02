# libraries
library(tidyverse)

# read in files
tajd <- read.table('kisii.theta1x1kb.gz.pestPG', header = T, comment.char="")
chemo <- read.table('out.kisii.chemo.thetas.idx.pestPG', header = T, comment.char="")
tajd <- rbind.data.frame(tajd, chemo)
fst <- read.table('kf.km.fst_1x1', row.names = NULL, header = T)
colnames(fst) <- c('region','Chr','WinCenter','Nsites','Fst')

# combine fst and tajd
taj2 <- select(tajd, c(Chr, WinCenter, Tajima)) 
taj2$id <- paste0(tajd$Chr,"_",tajd$WinCenter)
fst$id <- paste0(fst$Chr,"_",fst$WinCenter)

df <- left_join(taj2, fst, by = "id") %>%
  select(c(id, Tajima, Fst, WinCenter.x, Nsites)) %>%
  arrange(Fst) %>%
  filter(Nsites >=500) %>%
  filter(Tajima != 0) # appear to be an artifact
df$idx <- 1:nrow(df)

# plot
# p <- ggplot(df, aes(x = idx, y = Tajima, col = Fst)) +
#   geom_point(alpha = 0.1, size = 0.2) +
#   theme_bw() +
#   scale_color_viridis_c() +
#   ylab("Tajima's D") +
#   xlab("Index") +
#   geom_rug(sides = 'l')

p <- ggplot(df, aes(x = Tajima, y = Fst)) +
  geom_hex(bins = 30) +
  theme_classic() +
  scale_fill_viridis_c() +
  xlab("Tajima's D") +
  ylab(expression(italic('F'[ST])))

pdf("Fig3c_TD.pdf", width = 3, height = 2)
p
dev.off()
