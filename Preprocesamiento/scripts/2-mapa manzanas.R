#Este script agrupa los objetos espaciales por manzana y calcula los centroides de cada una.

#Lectura de mapa manzanas:
library(tidyverse)
library(data.table)
library(sf)

manzanas <- read_sf("Preprocesamiento/data/mapa_manzanas/mapa_manzanas.geojson")

manzanas <- manzanas %>%
  group_by(sm) %>%
  summarise(n())

st_write(manzanas, "Preprocesamiento/data/mapa_manzanas/manzanas_agrupadas.shp")

centroides.manzanas <- st_centroid(manzanas)

st_write(centroides.manzanas, "Preprocesamiento/data/mapa_manzanas/manzanas_centroides.shp")
