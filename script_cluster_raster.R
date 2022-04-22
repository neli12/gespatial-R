### Script for mapping clusters using raster maps

dir.imagens.base <- "C:/Users"

# Create a list with your raster names
imagens <- list.files(path = dir.imagens.base, pattern = "map.tif", full.names = TRUE)
imagens

# Create an empty list to save your raster layers and convert character into raster
covs <- list()
for (i in 1:length(images)){
  covs[i] <- raster(images)
}

# Create a raster stack from your list of raster
covs.stack <- stack(covs)

# Get the values of the raster stack
rvals <- getValues(covs.stack)
summary(rvals)

# Elbow method to check the optimal number of cluster
k.max <- 20
data <- (na.omit(scale(rvals))) #scale and exclude NA's
wss <- sapply(1:k.max, 
              function(k){kmeans(data, k, nstart=50,iter.max = 15 )$tot.withinss})
wss
plot(wss)



### Clustering
# Use the clara function from cluster package. In this code, a sample of 1000 and the euclidean distance are used.
clus <- cluster::clara(data, k=4, metric = "euclidean", stand = TRUE, samples = 1000, pamLike = T)  
summary(clus)


# Create am index
idx <- 1:ncell(covar)
idx <- idx[-unique(which(is.na(rvals), arr.ind=TRUE)[,1])] 
str(idx)

# Create an empty raster using the first raster of your stack
r.clust <- covs.stack[[1]]
plot(r.clust)
r.clust[] <- NA

# Transfer the clustering results to your empty raster and save it
r.clust[idx] <- clus$clustering
plot(r.clust) 
crs(r.clust)

writeRaster(r.clust, "Clusters", format = "GTiff", datatype = "FLT4S", overwrite = T)


