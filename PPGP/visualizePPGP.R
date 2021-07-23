### read in transcriptome summary files from PPGP 
### downloaded from http://bigdata.bx.psu.edu/PPGP_II_data/StHeBC4/PPGPII/
library(tidyverse)
library(viridis)

### function to average replicates for a particular stage
averageTPM <- function(stage_idx) {
  # load data for each of the three replicates
  R1 <- read.table(paste0('StHe_',stages[stage_idx],'_R1.genes.results'), header = T)
  R2 <- read.table(paste0('StHe_',stages[stage_idx],'_R2.genes.results'), header = T)
  R3 <- read.table(paste0('StHe_',stages[stage_idx],'_R3.genes.results'), header = T)

  # calculate avg TPM for stage
  df <- cbind.data.frame(R1$gene_id, R1$transcript_id.s., R1$TPM, R2$TPM, R3$TPM)
  df$avg <- 'NA'
  for (i in 1:nrow(df)) {
    df$avg[i] <- round(mean(c(df$`R1$TPM`[i],df$`R2$TPM`[i],df$`R3$TPM`[i])),2)
  }
  
  return(df$avg)
}

### create new df with average TPM for each stage
stages <- c('0','1','2','3','4','5','6_1','6_2')
R1 <- read.table(paste0('StHe_',stages[1],'_R1.genes.results'), header = T)
df <- dplyr::select(R1, c(gene_id, transcript_id.s.))
for (i in 1:length(stages)) {
  df$new <- as.numeric(averageTPM(i))
  colnames(df)[i + 2] <- paste0('Stage_',stages[i])
}

### plot the chemocyanin
df_sub <- subset(df, (gene_id == "StHeBC4_c11261_g0")) %>%
  pivot_longer(cols = 3:10)

p <- ggplot(df_sub, aes(x = name, y = value, group = gene_id)) +
  geom_line() +
  geom_point() +
  ylab("TPM") +
  xlab("Stage") +
  theme_light_bg() +
  scale_x_discrete(labels=c("Stage_0" = 0, "Stage_1" = "1",
                              "Stage_2" = "2", "Stage_3" = "3", "Stage_4" = "4", "Stage_5" = "5",
                            "Stage_6_1" = "6.1", "Stage_6_2" = "6.2"))
pdf("cc_exp.pdf", width = 2.7, height = 1.3)
p
dev.off()

df_sub <- subset(df, (gene_id =="StHeBC4_c12587_g2")) %>%
  pivot_longer(cols = 3:10)

p <- ggplot(df_sub, aes(x = name, y = value, group = gene_id)) +
  geom_line() +
  geom_point() +
  ylab("TPM") +
  xlab("Stage") +
  theme_light_bg() +
  scale_x_discrete(labels=c("Stage_0" = 0, "Stage_1" = "1",
                            "Stage_2" = "2", "Stage_3" = "3", "Stage_4" = "4", "Stage_5" = "5",
                            "Stage_6_1" = "6.1", "Stage_6_2" = "6.2"))
pdf("pm_exp.pdf", width = 2.7, height = 1.3)
p
dev.off()

### add column to color by whether is host-associated or not
ha <- read.table('PPGP_hits.list')
df$type <- 'NA'
for (i in 1:nrow(df)) {
  transcripts <- strsplit(df$transcript_id.s.[i], ",")[[1]] # some have multiple listed
  for (j in 1:length(transcripts)) {
    if (transcripts[j] %in% ha$V1) {
      df$type[i] <- 'Host-associated'
    }
  }
}

write.table(df, file = "PPGPII_avgTPM.txt", sep = "\t", row.names = F, quote = F)

### figure out expression trajectory clusters using
# https://github.com/PrincetonUniversity/DP_GP_cluster

# just host-associated
df_ha <- subset(df, type != "NA") %>% 
  pivot_longer(cols = 3:10)
df_ha$name <- as.factor(df_ha$name)
df_ha$gene_id <- as.factor(df_ha$gene_id)
df_ha$transcript_id.s. <- as.factor(df_ha$transcript_id.s.)
df_ha$type <- as.factor(df_ha$type)

ggplot(df_ha, aes(x = name, y = (value), group = name)) + 
  geom_boxplot() +
  theme(legend.position = "none")
# df_host <- subset(df, type == "Host-associated")
