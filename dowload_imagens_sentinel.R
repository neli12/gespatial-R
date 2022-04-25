## Install packages
install.packages("remotes")
remotes::install_github("16EAGLE/getSpatialData")

## Load packages
library(getSpatialData)
require(fansi)
library(raster)
library(sf)
library(sp)
library(rgdal)
require(installr)
require(curl)
require(Rcpp)
require(leaflet.providers)


## Set working directory
diretorio.shp <- "C:/Users/FREY/Google Drive/TESE/drainage_project/vetores"

## Load shapefile
nome.shp <- "area_nova"
shapefile <- readOGR(dsn = diretorio.shp, layer = nome.shp)
plot(shapefile)



data("aoi_data")

aoi <- aoi_data[[1]] # AOI as sf object

set_aoi(shapefile)
view_aoi() 


## Login site copernicus
login_CopHub(username = "") #complete your username
services_avail()

#Login USGS
login_USGS(username = "") #complete your password

## Use getSentinel_query to search for data (using the session AOI)
records <- getSentinel_query(time_range = c("2019-01-01", "2019-01-31"), 
                             platform = "Sentinel-2")

## Filter the records
colnames(records) #see all available filter attributes
unique(records$level) #use one of the, e.g. to see available processing levels

records_filtered <- records[which(records$level == "Level-2A"),] #filter by processing
records_filtered <- records_filtered[as.numeric(records_filtered$cloudcov) <= 10, ] #filter by clouds

## View records table
View(records)
View(records_filtered)

#browser records or your filtered records

records2 <- records_filtered[c(1,5),]

## Download to your archive directory
dir_archive <- "C:/Users/FREY/Google Drive/S2A"

set_archive(dir_archive)

datasets <- getSentinel_data(records = records2, dir_out = NULL)

