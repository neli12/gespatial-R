library(gstat)
library(sp)
library(raster)

## Set working directory , list files and load dataset
setwd("C:/Users/FREY/Documents")
list.files()

## Load dataset from github
githubURL <- "https://github.com/neli12/descriptive-statistics-R/raw/main/dataset.RData"
load(url(githubURL))

coordinates(dataset) <- ~X+Y
plot(dataset)

## Load grid 
grid <- read.csv("grid_II.csv")[,1:2]
colnames(grid)<- c("X", "Y")
gridded(grid) = ~X+Y
plot(grid)

## Calculate the semivariogram
v <- variogram(Clay.gkg~X+Y, dataset, cutoff = 0.06)
plot(v)


## Fit the semivariogram. After plotting the semivariogram, we set an exponential model
m <- fit.variogram(v, vgm(15000, "Exp", 0.03, 5000))
plot(v, m)

## Gaussian simulations - 10 realisations
sim <- krige(formula = Clay.gkg~X+Y, dataset, grid, model = m,
             nmax = 10, nsim = 10) # for speed -- 10 is too small!!

## Plot the first three map simulations
spplot(sim[1:3])

## Merge all simulations and create a raster stack
## From this stack, mean and standard deviations can be calculated to use as a measure f uncertainty
mergeParallelX <- SpatialPixelsDataFrame(points = grid, data = sim@data)
simulations.clay <- stack(mergeParallelX)
plot(simulations.clay)

writeRaster(simulations.clay, "simul_clay.tif")  ## save
