## create a map showing locations of collections
# library(raster)
# library(maps)
# library(RColorBrewer)
library(spData)
# library(sf)
library(dplyr)
library(grid)
library(tmap)
library(tmaptools)

setwd('/Users/emilybellis/Documents/GitHub/StrigaWGS/')

## load in data points from sampling
modern <- read.csv("Striga_GPS.csv", header=T)

## inset map
sub_world <- subset(world, iso_a2=="KE")
sub_world_sp <- as(sub_world, 'Spatial')

xy <- st_bbox(world %>%
                filter(continent == "Africa"))
asp2 <- (xy$xmax - xy$xmin)/(xy$ymax - xy$ymin)

## create inset highlighting Kenya in Africa
africa_inset <- world %>%
  filter(continent == "Africa") %>%
  tm_shape() +
    tm_borders() + 
    tm_fill() +
  tm_shape(sub_world_sp) +
    tm_fill(col="black") + 
    tm_borders() +
  tm_layout(inner.margins = c(0.04,0.04,0.04,0.04), outer.margins=c(0,0,0,0))
