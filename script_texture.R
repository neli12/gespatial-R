## Load libraries
library(soiltexture)
library(raster)
library(soilassessment)


## Load raster file with Clay, Silt and Sand layers downloaded from SoilGrids
list.files()
Texture <- stack("CSSil_MSMTGO.tif")
plot(Texture)


## Convert raster to data frame, round values and rename columns
text.df <- na.omit(as.data.frame(Texture, xy = TRUE))
text.dfg <- data.frame(text.df$x, text.df$y, round(text.df$clay,0), round(text.df$silt,0), round(text.df$sand,0))
colnames(text.dfg) <- c('x','y','CLAY', 'SILT', 'SAND')

## Plot textural triangle
TT.plot(
  class.sys = "USDA.TT",
  tri.data = text.dfge ,
  main = "Soil texture data",
  tri.sum.tst = FALSE, pch = 21, cex = 1
) 


## Create a dataframe with the textural classes names
texturedata=createTexturedata(text.dfg$CLAY, text.dfg$SILT, text.dfg$SAND)
newtxt1=appendTextureclass(as.data.frame(texturedata), method = "USDA")

## Create a new dataframe only with th xy coordinates and the texture classes
df.text <- data.frame(cbind(text.dfg$x, text.dfg$y, newtxt1$TEXCLASS))

## Convert string to numeric
unique(df.text$X3)
df.text$X3[df.text$X3 == "SaCl, SaClLo"] <- "SaCl"
df.text$X3[df.text$X3 == "SaCl, ClLo, SaClLo"] <- "SaCl"
df.text$X3[df.text$X3 == "SaCl, ClLo"] <- "SaCl"
df.text$X3[df.text$X3 == "SaClLo, SaLo"] <- "SaClLo"
df.text$X3[df.text$X3 == "Cl, SaCl, ClLo"] <- "Cl"
df.text$X3[df.text$X3 == "Cl, SaCl"] <- "Cl"
df.text$X3[df.text$X3 ==  "Cl, SiCl"] <- "Cl"
df.text$X3[df.text$X3 == "Cl, SiCl, ClLo, SiClLo"] <- "Cl"
df.text$X3[df.text$X3 == "SiCl, SiClLo"] <- 'SiCl'
df.text$X3[df.text$X3 == "SaLo, LoSa"] <- 'SaLo'
df.text$X3[df.text$X3 == "Cl, ClLo"] <- 'Cl'
df.text$Class <- as.numeric(as.factor(df.text$X3))
df.text <- df.text[,-3]  # remove string column


## Rename columns and convert to raster
colnames(df.text) <- c('x', 'y', 'class')
summary(as.factor(df.text))
r.df <- rasterFromXYZ(df.text)
plot(r.df)

## Export raster
writeRaster(r.df, 'Texture-reclass.tif')
