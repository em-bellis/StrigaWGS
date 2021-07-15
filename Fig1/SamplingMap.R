## create a map showing locations of collections
# https://ecodiv.earth/post/creating-a-map-with-inset-using-tmap/
rm(list=ls())
#library(rgdal)
library(tidyverse)
# library(maps)
# library(RColorBrewer)
library(sf)
#library(spData)
library(tmap)
library(tmaptools)
#library(dplyr)
#library(grid)
#library(rmapshaper)
library(jcolors)
#library(raster)

#setwd('/Users/emilybellis/Documents/GitHub/StrigaWGS/Fig1')

## load in data points from sampling
modern <- read.csv("Striga_GPS_sequenced.csv", header=T)
modern <- modern %>% dplyr::select(Lat, Lon, Site, Host) %>% unique()
modern$Site <- as.factor(str_replace(modern$Site, "2","") %>% str_trim())
modern$Type <- "modern"

# gps coordinates for ancient samples
#herb <- read.csv('Striga_GPS_sequenced_Berlin.csv', header=T, nrow=5)
#herb <- herb %>% select(Lat, Lon)
#herb$Site <- c("Kisii","Homa Bay","Muhoroni","Maranda","Fort Ternan")
#herb$Host <- c("maize","maize","sugarcane","sorghum","NA")
#herb$Type <- "NHC"

# subset to 68 sequenced
modern_df <- SpatialPointsDataFrame(cbind.data.frame(modern$Lon, modern$Lat),modern,proj4string = CRS("+proj=longlat"))
#herb_df <- SpatialPointsDataFrame(cbind.data.frame(herb$Lon,herb$Lat),herb,proj4string = CRS("+proj=longlat"))
mod_bb <- st_bbox(modern_df)
mod_bb <- mod_bb + c(-0.15,-0.15,0.15,0.15)
sg <- bb_poly(mod_bb)
asp <- (mod_bb$ymax - mod_bb$ymin)/(mod_bb$xmax - mod_bb$xmin)

## main map: Kenya
kenya<-getData("GADM", country="KE", level=1)
kenya_sf <- as(kenya, Class="sf")
kenya_smooth <- simplify_shape(kenya_sf, 0.01)

## main map: outlines of other countries
sub_world <- subset(world, iso_a2=="KE"|iso_a2=="TZ"|iso_a2=="ET"|iso_a2=="UG"|iso_a2=="RW"|iso_a2=="BI")
sub_world_sp <- as(sub_world, 'Spatial')

## lake victoria from https://figshare.com/articles/dataset/Simulation_of_Lake_Victoria_Circulation_Patterns_Using_the_Regional_Ocean_Modeling_System_ROMS_/4017198
vic <- st_read('victoria/contours.shp')
vic_poly <- st_polygonize(vic$geometry[1])

## want this to just be points for the sampled locations; distinguish only herbarium & modern, color points same as PCoA
mainmap <- tm_shape(kenya_smooth, bbox=mod_bb + c(-0.15,-0.15,0.15,0.15)) +
  tm_polygons() +
tm_shape(modern_df) + 
  tm_symbols(size=0.7, col="Site", alpha=0.7, jitter=0.1, palette=jcolors(palette="pal5"), shape="Host", legend.col.show = F) +
  tm_text("Site", remove.overlap = T, xmod = 1.5, ymod = 1, size = 0.75) + 
tm_scale_bar(position = c("left","bottom")) +
  tm_layout(legend.outside = T)

xy <- st_bbox(world %>%
                filter(continent == "Africa"))
asp2 <- (xy$xmax - xy$xmin)/(xy$ymax - xy$ymin)

## create inset highlighting Kenya in Africa
africa_inset <- world %>%
  filter(continent == "Africa") %>%
  tm_shape() +
    tm_borders() + 
    tm_fill() +
  tm_shape(sg) +
    tm_borders(lw=1, col="red") #+
 #tm_layout(inner.margins = c(0.04,0.04,0.04,0.04), outer.margins=c(0,0,0,0))

w <- 0.45
h <- asp2 * w
vp <- viewport(x=0.97, y=0.45, width = w, height=h, just=c("right", "top"))

tmap_save(mainmap,filename="sampling.png",
          dpi=300, insets_tm=africa_inset, insets_vp=vp,
          height=asp*91, width=91, units="mm")
