##################
### load libraries
##################
library(ggplot2)
library(lme4)

###############
### format data
###############
kisii <- read.table('Documents/GitHub/StrigaWGS/Fig3_ANGSD/with_genome/kisii.theta5x5kb.gz.pestPG', comment.char = "", header = T)
kisii$index <- 1:nrow(kisii)

###############
### plot figure
###############
ggplot(kisii, aes(x = index, y = Tajima)) + 
  geom_point(alpha = 0.5)

mod <- lmer(Tajima ~ 1 + 1|Chr, data = kisii)
summary(mod)
