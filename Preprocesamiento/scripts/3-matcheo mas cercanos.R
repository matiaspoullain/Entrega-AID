#Este script asocia a cada manzana su cantidad de delitos, según la superposición de los delitos (objetos puntuales) sobre las manzanas (polígonos)
#Luego asocia a cada manzana a los centros de servicios básicos más cercanos con la superposición de los centroides de las manzanas (objetos puntuales) con los polígonos de Voronoi de cada centro de servicio básico


library(tidyverse)
library(sf)

delitos <- read_sf("Preprocesamiento/data/delitos_mapa/delitos.shp")

centroides.manzanas <- read_sf("Preprocesamiento/data/mapa_manzanas/manzanas_centroides.shp")

manzanas.voronoi <- read_sf("Preprocesamiento/data/mapa_manzanas/manzanas_voronoi.shp")

manzanas.voronoi <- merge(manzanas.voronoi, st_drop_geometry(centroides.manzanas), by = "sm", all.x = TRUE)

manzanas.voronoi %>% head()

manzanas.voronoi$fid <- NULL
manzanas.voronoi$cat <- NULL
manzanas.voronoi$sm <- NULL

centroides.manzanas$sm <- NULL

unido <- delitos %>%
  st_join(manzanas.voronoi, left = TRUE)

dim(unido)

dim(delitos)

names(unido)

write.csv(st_drop_geometry(unido), "Preprocesamiento/data/delitos_manzanas.csv", row.names = FALSE)

#### Lo mismo con hospitales

hospi <- read_sf("Preprocesamiento/data/hospitales_gcba/hospitales_voronoi.shp")

manzanas.hospi <- centroides.manzanas %>%
  st_join(hospi, left = TRUE)

st_drop_geometry(manzanas.hospi[,c("id_manzana", "ID")])[!complete.cases(st_drop_geometry(manzanas.hospi[,c("id_manzana", "ID")])),]

write.csv(st_drop_geometry(manzanas.hospi[,c("id_manzana", "ID")]), "Preprocesamiento/data/hospitales_manzanas.csv", row.names = FALSE)


#Lo mismo para centros de salud privados:

privados <- read_sf("Preprocesamiento/data/centros-de-salud-privados-zip/centros-de-salud-privados_voronoi.shp")

manzanas.privados <- centroides.manzanas %>%
  st_join(privados)

names(manzanas.privados)

write.csv(st_drop_geometry(manzanas.privados[,c("id_manzana", "NOMBRE")]), "Preprocesamiento/data/privados_manzanas.csv", row.names = FALSE)

#Lo mismo con los centros de educacion:
educacion <- read_sf("Preprocesamiento/data/establecimientos_educativos/establecimientos_educativos_WGS84_voronoi.shp")

educacion <- educacion %>%
  unique(by = "dom_edific")

manzanas.educacion <- centroides.manzanas %>%
  st_join(educacion, left = TRUE) %>%
  select(id_manzana, dom_edific)# %>%
  filter(!is.na(dom_edific))

names(manzanas.educacion)

manzanas.educacion

write.csv(st_drop_geometry(manzanas.educacion), "Preprocesamiento/data/educacion_manzanas.csv", row.names = FALSE)

#Lo mismo con las comisarias:
comisarias <- read_sf("Preprocesamiento/data/comisarias-policia-de-la-ciudad-zip/comisarias_policia_de_la_ciudad.shp")

st_crs(comisarias)
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
comisarias <- st_transform(comisarias, projcrs)

st_write(comisarias, "Preprocesamiento/data/comisarias-policia-de-la-ciudad-zip/comisarias_policia_de_la_ciudad_WGS84.shp")

comisarias <- read_sf("Preprocesamiento/data/comisarias-policia-de-la-ciudad-zip/comisarias_policia_de_la_ciudad_WGS84_voronoi.shp")

dim(comisarias)

manzanas.comisarias <- centroides.manzanas %>%
  st_join(comisarias)

names(manzanas.comisarias)

manzanas.comisarias

write.csv(st_drop_geometry(manzanas.comisarias[, c("id_manzana", "id")]), "Preprocesamiento/data/comisarias_manzanas.csv", row.names = FALSE)


#Lo mismo para bomberos:
bomberos <- read_sf("Preprocesamiento/data/cuarteles-y-destacamentos-de-bomberos-de-policia-federal-argentina-zip/cuarteles_y_destacamentos_de_bomberos.shp")

st_crs(bomberos)
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
bomberos <- st_transform(bomberos, projcrs)

st_write(bomberos, "Preprocesamiento/data/cuarteles-y-destacamentos-de-bomberos-de-policia-federal-argentina-zip/cuarteles_y_destacamentos_de_bomberos_WGS84.shp")


bombeross <- read_sf("Preprocesamiento/data/cuarteles-y-destacamentos-de-bomberos-de-policia-federal-argentina-zip/cuarteles_y_destacamentos_de_bomberos_WGS84_voronoi.shp")

dim(bombeross)

manzanas.bombeross <- centroides.manzanas %>%
  st_join(bombeross)

names(manzanas.bombeross)

manzanas.bombeross

write.csv(st_drop_geometry(manzanas.bombeross[, c("id_manzana", "ID")]), "Preprocesamiento/data/bomberos_manzanas.csv", row.names = FALSE)

