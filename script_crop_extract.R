## Load libraries'
library(rgdal)
library(raster)

## Set the working directory
setwd("C:/Users/FREY/Documents/GeoSpatial_python/SP_Municipios_2021")
list.files()


## Create a list with the name of the rasters, using the common name 'bio'
img <- list.files(pattern = 'bio')


clim <- list()   ## empty list to save the rasters

## Convert the list into rasters and stack
for (i in 1:length(img)){
  clim[i] <- raster(img[[i]])
}

img.stack <- stack(img)

## Save the raster stack with the 19 climate covariates
writeRaster(img.stack, 'climate_stack.tif')


## Load the shapefile
shape <- readOGR('sp.shp')
plot(shape)

## Crop and mask the raster stack by the shapefile
new_crop <- crop(img.stack, shape)
plot(new_crop)


new_mask <- mask(new_crop, shape)
plot(new_mask)

## Rename and save
names(new_mask) <- c('B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B9')
writeRaster(new_mask, 'climate_stack_mask.tif')



## We will also save them individually 
s <- unstack(new_mask)
name_vector <- c('B1', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B18', 'B19', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7', 'B8', 'B9')
for(i in seq_along(s)){
  writeRaster(s[[i]], file=name_vector[i], format = 'GTiff')}


#############################################################################################################################################
## Extract mean values per county

## Load shapefile
counties <- shapefile("SP_Municipios_2021.shp")

extracted_mean <- extract(new_mask, poly, fun='mean', na.rm=TRUE, df=TRUE, cellnumbers = TRUE, layer = 1)

extracted_mean$CD_MUN <- poly$CD_MUN

write.csv(extracted_mean[,-1], "df_climate.csv")





