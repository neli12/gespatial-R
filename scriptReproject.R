###  R Script for re-projecting DEM rasters ###

## 1. Load libraries
library(raster)

## 2. Set working directory and load rasters
getwd("D:/BR_Datasets/Raster/DEMs/21S")
list.files()

DEMs <- list.files(pattern = '.tif', full.names = FALSE)


## 3. Convert characters to raster and set CRS
DEMs_raster <- list()

for (i in 1:length(DEMs)){
  DEMs_raster[i] <- raster(DEMs[[i]])
}


for (i in 1:length(DEMs_raster)){
  raster::crs(DEMs_raster[[i]]) <-  "EPSG:4326"
}


# 4. Project Raster
DEMs_projected <- list()
for (i in 1:length(DEMs_raster)){
  sr <- '+proj=utm +zone=21 +south +datum=WGS84 +units=m +no_defs'
  DEMs_projected[i] <- projectRaster(DEMs_raster[[i]], crs = sr)
}
plot(DEMs_projected)

## 5. Export rasters
namesRaster <- apply(data.frame(DEMs), 1, FUN = function(x) substr(x, 0, nchar(x)-4)) # Extracao dos codigos
namesRaster
direc <- setwd("D:/BR_Datasets/Raster/DEMs/UTM21")
for(i in 1:length(DEMs_projected)){
  writeRaster(DEMs_projected[[i]], file=paste(direc, '/', namesRaster[i],"_UTM-21S.tif", sep=""), overwrite=TRUE)
}




