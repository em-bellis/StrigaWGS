####Script for Tian's data analysis

#install and load libraries
library(tidyverse)
library(reshape2)
library(jcolors)

####load and reformat data
ken <- read.csv('Tian_project6.25.19.csv', header=T)
ken$percent <- ken$Germinated/(ken$Germinated+ken$Ungerminated)*100 #make a column for percent germination
ken <- subset(ken, Germinated+Ungerminated > 10)
ken2 <- ken %>% group_by(Sample, Site, Host, Treatment) %>% summarize(germ=mean(percent, na.rm=TRUE), num=n()) #get averages for 3 replicates of each treatment/parasite genotype combination
ken2 <- as.data.frame(ken2) #change to dataframe from tibble format
ken.pos <- subset(ken2, Site == "Kisii" | Site=="HomaBay") #subset to remove positive and negative controls before plotting
df <- dcast(ken.pos, Sample + Site + Host ~ Treatment, value.var="germ") #reformat data frame for easier plotting
colnames(df)[4] <- "DS" #ggplot didn't like column names that start with numbers
df$Site <- droplevels(df)$Site #get rid of unused levels for nicer legend
df <- subset(df, Sample != "Sther143") #only one replicate for one of the treatments
df <- subset(df, Sample != "Sther139") #less than 10 seeds in all wells for one of the treatments

####make plot
p1 <- ggplot(df, aes(x=DS, y=ORO, col=Site, pch = Host)) + 
    geom_point(size = 2.5, alpha = 0.8) + 
    geom_abline(intercept = 0, slope=1, lty=2) + 
    theme_classic() + 
    xlab("Germination % \n5DS") + 
    ylab("Germination % \nORO") +
    scale_color_manual(values = paste0(jcolors(palette="pal5"))[c(2,4)], labels = c("Homa Bay", "Kisii")) +
    scale_shape_discrete(labels = c("finger millet", "maize", "sorghum"))

p1 #plot figure

####perform stats to see if Germination rates to different hormones are statistically different between parasites from different sites or collected from different hosts
hist(df$DS-df$ORO) #not normally distributed. If you have time can look into other methods for analysis 
summary(lm(df$DS/df$ORO ~ df$Site + df$Host)) #this is a simple ANOVA based on the difference in germination rate in response to the two different hormones. Not the best choice of approach given above but would be fine for a poster
