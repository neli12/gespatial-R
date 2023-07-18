## Load libraries
library(soiltexture)
library(raster)
library(soilassessment)
library(rasterVis)


## Load raster file with Clay, Silt and Sand layers downloaded from SoilGrids
setwd("D:/Control-sites")
list.files()
Texture <- stack("CSSil_MSMTGO.tif")


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
df.text$X3[df.text$X3 == "Lo, SiLo"] <- 'Lo'
df.text$Class <- as.numeric(as.factor(df.text$X3))
df.text$X3 <- as.factor(df.text$X3)
df.text.def <- df.text[,-3]  # remove string column

# Cl=1, ClLo=2, Lo=3, LoSa=4, Sa=5, SaCl=6, SaClLo=7, SaLo=8, SiCl=9, SiClLo=10, SiLo=11


## Rename columns and convert to raster
colnames(df.text.def) <- c('x', 'y', 'class')
r.df <- rasterFromXYZ(df.text.def)

## Plot raster
r.df <- as.factor(r.df)
tar <- levels(r.df)[[1]]
tar[["Class"]]<-c('Cl', 'ClLo', 'Lo', 'LoSa', 'Sa', 'SaCl', 'SaClLo', 'SaLo', 'SiCl', 'SiClLo', 'SiLo')
levels(r.df)<-tar
levelplot(r.df)
plot(r.df)

## Export raster
writeRaster(r.df, 'Texture-reclass.tif', overwrite = TRUE)

