library(tidyverse)
library(jcolors)

# function to get diff in allele frequency
getAF <- function(pop1, pop2) {
  df_k <- inner_join(pop1, pop2, by = c("chromo", "position"))
  df_k$AF <- NULL
  for (i in 1:nrow(df_k)) {
    if (df_k$major.x[i] == df_k$major.y[i]){
      df_k$AF[i] <- max(df_k$knownEM.x[i],df_k$knownEM.y[i]) - min(df_k$knownEM.x[i],df_k$knownEM.y[i])
    } else {
      df_k$AF[i] <- 1 - max(df_k$knownEM.x[i],df_k$knownEM.y[i]) - min(df_k$knownEM.x[i],df_k$knownEM.y[i])
    }
  }
  return(df_k %>% select(c(chromo, position, AF)))
}

# read in files
km <- read.table('ang.kisii_mz.out.mafs', header = T) %>%
  filter(nInd >= 9)
kf <- read.table('ang.kisii_fm.out.mafs', header = T) %>%
  filter(nInd >= 9)
hm <- read.table('ang.homa_mz.out.mafs', header = T) %>%
  filter(nInd >= 9)
hs <- read.table('ang.homa_sg.out.mafs', header = T) %>%
  filter(nInd >= 9)

df_h <- getAF(hs, hm)
df_h$pop <- 'Homa Bay'

df_k <- getAF(kf, km)
df_k$pop <- 'Kisii'

df <- rbind.data.frame(df_k, df_h)

sl <- subset(df, chromo != "StHeBC4_h_c11261_g0_i1" & 
                 chromo != "StHeBC4_p_c12587_g2_i1" &  
                 chromo != "StHeBC4_u_c12903_g27039_i4")

pm <- subset(df, chromo == "StHeBC4_u_c12903_g27039_i4")

# change labels for chromo for ShHTLs to annotations
shtl_names <- c(
  "KR013131.1" = "ShHTL11",
  "KR013130.1" = "ShHTL10",
  "KR013129.1" = "ShHTL9",
  "KR013128.1" = "ShHTL8",
  "KR013127.1" = "ShHTL7",
  "KR013126.1" = "ShHTL6",
  "KR013125.1" = "ShHTL5",
  "KR013124.1" = "ShHTL4",
  "KR013123.1" = "ShHTL3",
  "KR013122.1" = "ShHTL2", 
  "KR013121.1" = "ShHTL1"
)

p <- ggplot(sl, aes(x = position, y = AF, col = pop)) +
  geom_point(size = 0.1, alpha = 0.5) +
  facet_grid(chromo~., labeller = labeller(chromo = shtl_names)) +
  ylim(c(0,1)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(), 
        panel.grid.major.x = element_blank()) +
  scale_colour_discrete(name = "Population") +
  ylab("Allele Frequency Difference")

p2 <-  ggplot(pm, aes(x = position, y = AF, col = pop)) +
  geom_point(size = 0.1, alpha = 0.5) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(), 
        panel.grid.major.x = element_blank()) +
  scale_colour_discrete(name = "Population") +
  ylab("Allele Frequency\nDifference")

pdf('FigS2_ShHTL.pdf', width = 4, height = 8)
p
dev.off()

pdf('FigS3_pm.pdf', width = 4, height = 2)
p2
dev.off()

# haustorium loci of interest
# for this one, not taking the difference (many sites not present in one pop)
hm$host <- "maize"
hs$host <- "sorghum"
km$host <- "maize"
kf$host <- "finger millet"

hm$pop <- "Homa Bay"
hs$pop <- "Homa Bay"
km$pop <- "Kisii"
kf$pop <- "Kisii"

df <- rbind.data.frame(hm, hs, km, kf)
haus_1 <- subset(df, chromo == "StHeBC4_h_c11261_g0_i1")
haus_2 <- subset(df, chromo == "StHeBC4_p_c12587_g2_i1")

#haus_names <- c(
#  "StHeBC4_h_c11261_g0_i1" = "chemocyanin\nprecursor", 
#  "StHeBC4_p_c12587_g2_i1" = "SGT1")

p <- ggplot(haus_1, aes(x = position, y = knownEM, col = host)) +
  geom_point(alpha = 0.4, size = 0.25) +
  facet_grid(.~pop) + #, labeller = labeller(chromo = haus_names)) +
  scale_color_manual(name = "Host", values = paste0(jcolors(palette="pal5")[c(1,3,2)])) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(), 
        panel.grid.major.x = element_blank(),
        strip.text.y = element_text(size = 7),
        legend.position = 'bottom',
        axis.text.x = element_text(angle = 90, hjust = 1.25)) +
  ylab("Minor Allele Frequency")

pdf("Fig5_chemo.pdf", width = 3, height = 2)
p
dev.off()

p <- ggplot(haus_2, aes(x = position, y = knownEM, col = host)) +
  geom_point(alpha = 0.4, size = 0.25) +
  facet_grid(.~pop) + #, labeller = labeller(chromo = haus_names)) +
  scale_color_manual(name = "Host", values = paste0(jcolors(palette="pal5")[c(1,3,2)])) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(), 
        panel.grid.major.x = element_blank(),
        strip.text.y = element_text(size = 7),
        legend.position = 'bottom',
        axis.text.x = element_text(angle = 90, hjust = 1.25)) +
  ylab("Minor Allele Frequency")

pdf("Fig5_sgt.pdf", width = 3, height = 2)
p
dev.off()


