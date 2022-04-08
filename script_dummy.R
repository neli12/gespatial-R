### Load libraries
library(raster)

## Create a function to convert a single categorical raster into dummy variables
dummyRaster <- function(rast){
  rast <- as.factor(rast)
  result <- list()
  for(i in 1:length(levels(rast)[[1]][[1]])){
    result[[i]] <- rast == levels(rast)[[1]][[1]][i]
    names(result[[i]]) <- paste0(names(rast),
                                 levels(rast)[[1]][[1]][i])
  }
  return(stack(result))
}


## Load categorical raster
geo <-stack("PR_preliminary.tif")
plot(geo)

## Convert geo  from factor to dummy
geo_dummy <- dummyRaster(geo)
plot(geo_dummy)

##  Save dummy raster
writeRaster(geo_dummy, 'new_dummy_raster.tif')
