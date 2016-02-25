# ******************************************************************************
# READING AND PREPROCESSING DATA
# ******************************************************************************

# coutry codes
#https://commondatastorage.googleapis.com/ckannet-storage/2011-11-25T132653/iso_3166_2_countries.csv
# https://datahub.io/de/dataset/iso-3166-1-alpha-2-country-codes

# unemployment data
# http://ec.europa.eu/eurostat/web/products-datasets/-/tipsun20

# READ
isocodes <- fread("./data/iso_3166_2_countries.csv", sep = ",", select = c("ISO 3166-1 2 Letter Code", "Common Name"), data.table = F)
rawdata <- fread("./data/tipsun20.tsv", header = T, sep="\t", colClasses = "character", na.strings = ":", data.table = F)
colnames(isocodes)[2] <- "isocode"
colnames(rawdata)[1] <- "s_adj.sex.age.unit.geo.time"

# MUTATE
rawdata[, -1] <- lapply(rawdata[,-1], function(x){gsub(pattern = "[a-z]", replacement = "", x = x)})
rawdata[, -1] <- lapply(rawdata[,-1], function(x){as.numeric(x)})
# clean-up country codes
rawdata$isocode <- sapply(rawdata[,"s_adj.sex.age.unit.geo.time"], function(x){substr(x, nchar(x)-1, nchar(x))})
rawdata$isocode[which(rawdata$isocode=="UK")] <- "GB"
rawdata$isocode[which(rawdata$isocode=="EL")] <- "GR"

# MERGE
# attach ISO contry code to rawdata
rawdata$country <- sapply(rawdata$isocode, function(x){isocodes[grep(x, isocodes$isocode), "Common Name"]})
rawdata$country <- sapply(rawdata$country, function(x){ if(length(x)==2){unlist(x)[1]} else{x}})
rawdata <- rawdata[order(rawdata$country), ]
# global value for current country selection
choices <- unique(rawdata$isocode)
names(choices) <- unique(rawdata$country)
curcountry <- choices[1]

