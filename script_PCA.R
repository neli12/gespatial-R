## Load libraries
library(raster)
library(prcomp)

## Load raster
AISA <- stack("AISA_banda_reprojetado.tif")
AISA[AISA < 0] <- NA  ## Set zero values to NA

## Take a sample
sr <- sampleRandom(AISA, 10000)

## Perform PCA
pca <- prcomp(sr, scale = TRUE)
pca.df <- pca$x
print(pca)

## Plot the screeplot
screeplot(pca)

## Predict to the entire raster   -- With three PCs
pci <- predict(AISA, pca, index = 1:3)
plot(pci[[3]])


## Save
writeRaster(pci, "PCA_AISA.tif")
