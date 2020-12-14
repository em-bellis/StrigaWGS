## create a map showing locations of collections
# https://ecodiv.earth/post/creating-a-map-with-inset-using-tmap/
library(raster)
library(tidyverse)
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
modern <- modern %>% dplyr::select(Lat, Lon, Site, Host) %>% unique()
# subset to 68 sequenced
modern_df <- SpatialPointsDataFrame(cbind.data.frame(modern$Lon, modern$Lat),modern,proj4string = CRS("+proj=longlat"))
mod_bb <- st_bbox(modern_df)
mod_bb <- mod_bb + c(-0.25,-0.25,0.25,0.25)

## main map: Kenya


## main map: outlines of other countries
sub_world <- subset(world, iso_a2=="KE"|iso_a2=="TZ"|iso_a2=="ET"|iso_a2=="UG"|iso_a2=="RW"|iso_a2=="BI")
sub_world_sp <- as(sub_world, 'Spatial')

## want this to just be points for the sampled locations; distinguish only herbarium & modern, color points same as PCoA
tm_shape(kenya_smooth, bbox=mod_bb) +
  tm_polygons() +
tm_shape(modern_df) + 
  tm_bubbles(size=0.25, col="Host", alpha=0.7, jitter=0.08)

xy <- st_bbox(world %>%
                filter(continent == "Africa"))
asp2 <- (xy$xmax - xy$xmin)/(xy$ymax - xy$ymin)

## create inset highlighting Kenya in Africa
africa_inset <- world %>%
  filter(continent == "Africa") %>%
  tm_shape() +
    tm_borders() + 
    tm_fill() +
  #tm_shape(modern_df) + 
    #tm_dots(size=0.005)
  #tm_shape(sub_world_sp) +
   # tm_fill(col="black") + 
    #tm_borders() + 
  tm_layout(inner.margins = c(0.04,0.04,0.04,0.04), outer.margins=c(0,0,0,0))
