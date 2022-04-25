#########################
##### INITIAL SETUP #####
#########################

## Avoinding factorization of character values
options(stringsAsFactors = FALSE)

## Working directory
getwd()

diretorio <- "C:/imagens"

setwd(diretorio)

####################################
##### RUNNING SEN2COR INSIDE R #####
####################################

# Listing images in the folder
list.files(getwd(), include.dirs = TRUE)

# Defining the folder for atmospheric correction
L1C.image.dir <- "S2B_MSIL1C_20181022T132229_N0206_R038_T22KHV_20181022T164946.SAFE"

# Saving the project working directory
old.work.dir <- getwd()

# Indicating the folder of sen2cor
sen2cor.dir <- "C:/Sen2Cor"

# Changing the working directory to sen2cor folder
setwd(sen2cor.dir)

## RUN ONLY ONCE. TAKE CARE BECAUSE IT TAKES 30 MIN FOR PROCESSING
system(paste0("L2A_Process.bat ", paste0(old.work.dir, "/", L1C.image.dir)))

# Setting the working directory to the project folder
setwd(old.work.dir)

