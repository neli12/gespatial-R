# Set your working environment
setwd("~/tutoriais/scripts/R-language")
list.files()

# Load library
library(raster)
require(raster)

## 1. Load rasters and get their information
slp <- raster("Slope.tif")
L8 <- stack("L8Median2021_27700.tif")
slp
L8

## 2. Set the CRS

crs(slp) <- '+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +units=m +no_defs'
crs(slp) <- CRS('+init=EPSG:27700')

## 3. Plot rasters
# 3.1. Using plot
par(mfrow=c(1,2))
plot(slp)
plot(L8[[1]])

# 3.2. Using image()
image(L8[[2]])
image(slp)


## 4. Cropping raster
# 4.1. Using a shapefile
# 4.1.1. Load and plot shapefile
area <- shapefile('area_drawn_27700.shp')
plot(area)

# 4.1.2. Plot raster and shapefile
par(mfrow = c(2,1))
plot(L8[[1]])
plot(area, add = TRUE)

plot(slp)
plot(area, add = TRUE)

# 4.1.3. Crop rasters with the shapefile
L8_crop <- crop(L8, area)
plot(L8_crop[[1]])
plot(area, add = TRUE)
slp_crop <- crop(slp, area)
plot(slp_crop)
plot(area, add = TRUE)

# 4.1.4. Mask rasters with the shapefile
L8_mask <- mask(L8, area)
plot(L8_mask[[1]])
plot(area, add = TRUE)
slp_mask <- mask(slp, area)
plot(slp_mask)
plot(area, add = TRUE)

# 4.1.5. Crop and mask together
L8_crop_mask <- mask(L8_crop, area)
plot(L8_crop_mask[[1]])
plot(area, add = TRUE)
slp_crop_mask <- mask(slp_crop, area)
plot(slp_crop_mask)
plot(area, add = TRUE)


# 4.2. Using drawExtent
plot(slp)
a1 <- drawExtent()
slp_crop2 <- crop(slp, a1)
plot(slp_crop2)

plot(L8[[1]])
L8_crop2 <- crop(L8, a1)
plot(L8_crop2[[1]])

## 5. Resample rasters
# 5.1. From 30 to 5 m
L8_resample <- resample(L8_crop2, slp_crop2, method = 'ngb')
par(mfrow=c(1,2))
plot(L8_crop2[[1]])
plot(L8_resample[[1]])

# 5.2. From 5 to 30 m
slp_resample <- resample(slp_crop2, L8_crop2, method = 'ngb')
par(mfrow=c(1,2))
plot(slp_crop2[[1]])
plot(slp_resample[[1]])