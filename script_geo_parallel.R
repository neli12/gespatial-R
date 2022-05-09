## Load libraries
library(gstat)
library(sp)
library(raster)
library(hydroGOF)
library(parallel)

## Load dataset from github
githubURL <- "https://github.com/neli12/descriptive-statistics-R/raw/main/dataset.RData"
load(url(githubURL))
coordinates(dataset) <- ~X+Y
plot(dataset)

## Set working directory
setwd("C:/Users/FREY/Downloads")
list.files()

## Load and plot grid 
grid <- read.csv("grid_II.csv")[,1:2]
colnames(grid)<- c("X", "Y")
gridded(grid) = ~X+Y
plot(grid)


## Fit universal kriging 
g <- gstat(id="Clay.gkg", formula = Clay.gkg~X+Y, data = dataset)
var_exp <- gstat::variogram(g)
plot(var_exp, pch=16, cex=1)


fit.exp <- fit.variogram(var_exp, vgm(10000, "Sph", 0.03, 5000))   #vgm(psill, model, range, nugget)
plot(var_exp, fit.exp, pch=16, cex=1)


## Cross-validation
xvalid.exp <- krige.cv(Clay.gkg~X+Y, locations = dataset, model = fit.exp)
plot(xvalid.exp$var1.pred ~ dataset$Clay.gkg, cex = 1.2, lwd = 2, xlim = c(0,600), ylim = c(0,600))
abline(0, 1, col = "red", lwd = 2)
lm_exp <- lm(xvalid.exp$var1.pred ~ dataset$Clay.gkg)
abline(lm_exp, col = "green", lwd = 2)
r2_exp <- summary(lm_exp)$r.squared
rmse_exp <- hydroGOF::rmse(xvalid.exp$var1.pred, dataset$Clay.gkg)
r2_exp
rmse_exp


## Parallel geoprocessing
# Calculate the number of cores
no_cores <- detectCores() - 1
cl <- makeCluster(no_cores)

# Split according to your number of clusters
parts <- split(x = 1:length(grid), f = 1:no_cores)


##clusterExport assigns the values on the master R process of the variables named in varlist to variables of the same names in the global environment 
##(aka 'workspace') of each node. The environment on the master from which variables are exported defaults to the global environment.
clusterExport(cl = cl, varlist = c("dataset", "grid", "fit.exp", "parts"), envir = .GlobalEnv)

##clusterEvalQ evaluates a literal expression on each cluster node. It is a parallel version of evalq, and is a convenience function invoking clusterCall.
clusterEvalQ(cl = cl, expr = c(library('sp'), library('gstat')))


## Paralell kriging using parLapply
system.time(geo_parallel <- parLapply(cl = cl, X = 1:no_cores, fun = function(x) krige(formula = Clay.gkg~X+Y, locations = dataset,
                                                                                       newdata = grid[parts[[x]],], model = fit.exp)))

stopCluster(cl)

# Merge all the predictions    
merge_geo <- maptools::spRbind(geo_parallel[[1]], geo_parallel[[2]])
merge_geo <- maptools::spRbind(geo_parallel, geo_parallel[[3]])
merge_geo <- maptools::spRbind(geo_parallel, geo_parallel[[4]])
merge_geo <- maptools::spRbind(geo_parallel, geo_parallel[[5]])
merge_geo <- maptools::spRbind(geo_parallel, geo_parallel[[6]])
merge_geo <- maptools::spRbind(geo_parallel, geo_parallel[[7]])


# Create SpatialPixelsDataFrame from merge_geo and plot
merge_geo <- SpatialPixelsDataFrame(points = merge_geo, data = merge_geo@data)
spplot(mergeParallelX["var1.pred"], main = "ordinary kriging predictions")

# Create a raster from merge_geo and plot
merge_geo_raster <- raster(merge_geo)
plot(merge_geo_raster)
