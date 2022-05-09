

## Load dataset from github
githubURL <- "https://github.com/neli12/gespatial-R/raw/main/SYSI.RData"
load(url(githubURL))

## Unstack
SYSI_unstack <- unstack(SYSI)
namesRaster <- names(SYSI)

## Save each band separately
for(i in seq_along(SYSI_unstack)){
  writeRaster(SYSI_unstack[[i]], file=paste(namesRaster[i], "_30m.tif", sep=""), overwrite=TRUE)
}
