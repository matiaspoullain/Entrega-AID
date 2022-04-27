#A partir de las coordenadas de los centroides de cada manzana y de las coordenadas de los centros de servicios básico más cercanos a cada una de ellas se calcula la distancia del semiverseno en Km de manzana-centro de servicio básico
#La base de datos obtenida es la utilizada en el análisis


library(tidyverse)
library(data.table)
library(sf)
juntos <- fread("Preprocesamiento/data/union_bases.csv")

manzanas <- read_sf("Preprocesamiento/data/mapa_manzanas/manzanas_centroides.shp")

codigo.manzanas <- fread("Preprocesamiento/data/codigo_manzanas.csv", encoding = "UTF-8")

manzanas <- merge(manzanas, codigo.manzanas)

manzanas$sm <- NULL

manzanas <- data.table(st_drop_geometry(manzanas),
                       latitud_manzana = st_coordinates(manzanas)[, 2],
                       longitud_manzana = st_coordinates(manzanas)[, 1])



juntos <- merge(juntos, manzanas, by = "id_manzana", all.x = TRUE, all.y = FALSE)

####Bomberos

bomberos <- read_sf("Preprocesamiento/data/cuarteles-y-destacamentos-de-bomberos-de-policia-federal-argentina-zip/cuarteles_y_destacamentos_de_bomberos_WGS84.shp")

bomberos <- data.table(st_drop_geometry(bomberos)[, 1] %>%
                         rename(id_bomberos = ID),
                       latitud_bomberos = st_coordinates(bomberos)[, 2],
                       longitud_bomberos = st_coordinates(bomberos)[, 1])

names(bomberos)

juntos <- merge(juntos, bomberos, by = "id_bomberos", all.x = TRUE, all.y = FALSE)




### Comisarias:
comisarias <- read_sf("Preprocesamiento/data/comisarias-policia-de-la-ciudad-zip/comisarias_policia_de_la_ciudad_WGS84.shp")

names(comisarias)

comisarias <- data.table(st_drop_geometry(comisarias)[, 1] %>%
                         rename(id_comisarias = id),
                       latitud_comisarias = st_coordinates(comisarias)[, 2],
                       longitud_comisarias = st_coordinates(comisarias)[, 1])



juntos <- merge(juntos, comisarias, by = "id_comisarias", all.x = TRUE, all.y = FALSE)


####educacion:
educacion <- read_sf("Preprocesamiento/data/establecimientos_educativos/establecimientos_educativos_WGS84.shp")

educacion <- data.table(st_drop_geometry(educacion)[, "dom_edific"] %>%
                           rename(id_educacion = dom_edific),
                         latitud_educacion = st_coordinates(educacion)[, 2],
                         longitud_educacion = st_coordinates(educacion)[, 1])



juntos <- merge(juntos, educacion, by = "id_educacion", all.x = TRUE, all.y = FALSE)

####hospitales:
hospitales <- read_sf("Preprocesamiento/data/hospitales_gcba/hospitales_gcba_WGS84.shp")

names(hospitales)

hospitales <- data.table(st_drop_geometry(hospitales)[, "ID"] %>%
                          rename(id_hospitales = ID),
                        latitud_hospitales = st_coordinates(hospitales)[, 2],
                        longitud_hospitales = st_coordinates(hospitales)[, 1])



juntos <- merge(juntos, hospitales, by = "id_hospitales", all.x = TRUE, all.y = FALSE)

sum(is.na(juntos))


####privados:
privados <- read_sf("Preprocesamiento/data/centros-de-salud-privados-zip/centros-de-salud-privadosWSG84.shp")

names(privados)

privados <- data.table(st_drop_geometry(privados)[, "NOMBRE"] %>%
                           rename(id_privados = NOMBRE),
                         latitud_privados = st_coordinates(privados)[, 2],
                         longitud_privados = st_coordinates(privados)[, 1])



juntos <- merge(juntos, privados, by = "id_privados", all.x = TRUE, all.y = FALSE)

sum(is.na(juntos))

library(sp)
spDistsN1(as.matrix(juntos[1,.(longitud_manzana, latitud_manzana)]),as.matrix(juntos[1,.(longitud_bomberos, latitud_bomberos)]),longlat=TRUE)

servicios <- c("privados", "hospitales", "educacion", "comisarias", "bomberos")

for(s in servicios){
  cat("Servicio:", s, "de", servicios)
  distancias <- c()
  for(i in 1:nrow(juntos)){
    cat("Linea:", i, "de", nrow(juntos), "\n")
    distancia <- spDistsN1(as.matrix(juntos[i, .(longitud_manzana, latitud_manzana)]), as.matrix(juntos[i, .(get(paste0("longitud_", s)), get(paste0("latitud_", s)))]),longlat=TRUE)
    distancias <- c(distancias, distancia)
  }
  juntos[, paste0("distancia_", s) := distancias]
}

juntos

#fwrite(juntos, "Preprocesamiento/data/unidos_coordenadas.csv", row.names = FALSE)

juntos <- fread("Preprocesamiento/data/unidos_coordenadas.csv")

manzanas.voronoi <- read_sf("Preprocesamiento/data/mapa_manzanas/manzanas_voronoi.shp")

codigos <- fread("Preprocesamiento/data/codigo_manzanas.csv", encoding = "UTF-8")

manzanas.voronoi <- manzanas.voronoi %>%
  merge(codigos, by = "sm")

manzanas.voronoi <- manzanas.voronoi %>%
  merge(juntos, by = "id_manzana", all.x = TRUE)


names(manzanas.voronoi) <- names(manzanas.voronoi) %>%
  gsub(pattern = "_manzana", replacement = "_mnz", x = ., fixed = TRUE) %>%
  gsub(pattern = "_privados", replacement = "_prv", x = ., fixed = TRUE) %>%
  gsub(pattern = "_hospitales", replacement = "_hsp", x = ., fixed = TRUE) %>%
  gsub(pattern = "_bomberos", replacement = "_bmb", x = ., fixed = TRUE) %>%
  gsub(pattern = "_comisarias", replacement = "_com", x = ., fixed = TRUE) %>%
  gsub(pattern = "_educacion", replacement = "_edc", x = ., fixed = TRUE) %>%
  gsub(pattern = "Homicidio", replacement = "homic", x = ., fixed = TRUE) %>%
  gsub(pattern = "Hurto (sin violencia)", replacement = "hurto", x = ., fixed = TRUE) %>%
  gsub(pattern = "Lesiones", replacement = "lesion", x = ., fixed = TRUE) %>%
  gsub(pattern = "Robo (con violencia)", replacement = "robo", x = ., fixed = TRUE) %>%
  gsub(pattern = "latitud", replacement = "lat", x = ., fixed = TRUE) %>%
  gsub(pattern = "longitud", replacement = "lon", x = ., fixed = TRUE) %>%
  gsub(pattern = "distancia", replacement = "dist", x = ., fixed = TRUE)
  
#Le agrego a que comuna peternecen:

caba <- read_sf("Preprocesamiento/data/mapa_manzanas/caba.shp")

names(caba)

caba <- caba[, c("departamen")]


manzanas.voronoi <- manzanas.voronoi %>%
  st_join(caba, left = TRUE, largest = TRUE)

st_write(manzanas.voronoi, "Preprocesamiento/data/Manzana_final/manzana_voronoi_distancias.shp", delete_dsn = TRUE)
