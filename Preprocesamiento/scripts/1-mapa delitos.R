# Este script lee los datos de delitos, separados por años (2016-2020), selecciona la información necesaria de cada uno y construye los objetos espaciales que se usarán mas adelante

#Lectura de los datos:
library(tidyverse)
library(data.table)
library(sf)

unzip("Preprocesamiento/data.zip", exdir = "Preprocesamiento")

datos2020 <- fread("Preprocesamiento/data/delitos_2020.csv", encoding = "UTF-8", stringsAsFactors = TRUE)
datos2020 <- unique(datos2020)

str(datos2020)

summary(datos2020)
dim(datos2020)

conteo <- datos2020[, .(cantidad = .N), by = .(fecha, franja, tipo, subtipo, uso_armas, victimas)]

datos2020 <- datos2020[, -c("anio", "mes", "dia", "fecha", "franja", "victimas", "subtipo", "uso_armas")]

datos2020 <- unique(datos2020)

datos2020 <- datos2020[!is.na(latitud),]

datos2020[, c("latitud", "longitud") := .(fifelse(latitud < -35, latitud/1000, latitud),
          fifelse(longitud < -59, longitud / 1000, longitud))]


summary(datos2020)


projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
datos2020 <- st_as_sf(x = datos2020,                         
                   coords = c("longitud", "latitud"),
                   crs = projcrs)

st_write(datos2020, "Preprocesamiento/data/delitos_mapa/delitos2020.shp")


#Lo mismo para 2019:
datos2019 <- fread("Preprocesamiento/data/delitos_2019.csv", encoding = "UTF-8", stringsAsFactors = TRUE)
datos2019 <- unique(datos2019)

str(datos2019)

summary(datos2019)
dim(datos2019)

conteo <- datos2019[, .(cantidad = .N), by = .(fecha, franja, tipo, subtipo, uso_armas, victimas)]

datos2019 <- datos2019[, c("id", "tipo_delito", "barrio", "comuna", "lat", "long")]

datos2019 <- unique(datos2019)

names(datos2019)[names(datos2019) %in% c("id", "tipo_delito", "lat", "long")] <- c("id_mapa", "tipo", "latitud", "longitud")

datos2019 <- datos2019[!is.na(latitud),]

datos2019[, c("latitud", "longitud") := .(fifelse(latitud < -35, latitud/1000, latitud),
                                      fifelse(longitud < -59, longitud / 1000, longitud))]


summary(datos2019)


projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
datos2019 <- st_as_sf(x = datos2019,                         
                  coords = c("longitud", "latitud"),
                  crs = projcrs)

st_write(datos2019, "Preprocesamiento/data/delitos_mapa/delitos2019.shp", delete_dsn = TRUE)


#Lo mismo para 2018:
datos2018 <- fread("Preprocesamiento/data/delitos_2018.csv", encoding = "UTF-8", stringsAsFactors = TRUE)
datos2018 <- unique(datos2018)

str(datos2018)

summary(datos2018)
dim(datos2018)

datos2018 <- datos2018[, c("id", "tipo_delito", "barrio", "comuna", "lat", "long")]

datos2018 <- unique(datos2018)

names(datos2018)[names(datos2018) %in% c("id", "tipo_delito", "lat", "long")] <- c("id_mapa", "tipo", "latitud", "longitud")

datos2018 <- datos2018[!is.na(latitud),]

datos2018[, c("latitud", "longitud") := .(fifelse(latitud < -35, latitud/1000, latitud),
                                          fifelse(longitud < -59, longitud / 1000, longitud))]


summary(datos2018)


projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
datos2018 <- st_as_sf(x = datos2018,                         
                      coords = c("longitud", "latitud"),
                      crs = projcrs)

st_write(datos2018, "Preprocesamiento/data/delitos_mapa/delitos2018.shp", delete_dsn = TRUE)


#Lo mismo para 2017:
datos2017 <- fread("Preprocesamiento/data/delitos_2017.csv", encoding = "UTF-8", stringsAsFactors = TRUE)
datos2017 <- unique(datos2017)

str(datos2017)

summary(datos2017)
dim(datos2017)

datos2017 <- datos2017[, c("id", "tipo_delito", "barrio", "comuna", "lat", "long")]

datos2017 <- unique(datos2017)

names(datos2017)[names(datos2017) %in% c("id", "tipo_delito", "lat", "long")] <- c("id_mapa", "tipo", "latitud", "longitud")

datos2017 <- datos2017[!is.na(latitud),]

datos2017[, c("latitud", "longitud") := .(fifelse(latitud < -35, latitud/1000, latitud),
                                          fifelse(longitud < -59, longitud / 1000, longitud))]


summary(datos2017)


projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
datos2017 <- st_as_sf(x = datos2017,                         
                      coords = c("longitud", "latitud"),
                      crs = projcrs)

st_write(datos2017, "Preprocesamiento/data/delitos_mapa/delitos2017.shp", delete_dsn = TRUE)


#Lo mismo para 2016:
datos2016 <- fread("Preprocesamiento/data/delitos_2016.csv", encoding = "UTF-8", stringsAsFactors = TRUE)
datos2016 <- unique(datos2016)

str(datos2016)

summary(datos2016)
dim(datos2016)

datos2016 <- datos2016[, c("id", "tipo_delito", "barrio", "comuna", "lat", "long")]

datos2016 <- unique(datos2016)

names(datos2016)[names(datos2016) %in% c("id", "tipo_delito", "lat", "long")] <- c("id_mapa", "tipo", "latitud", "longitud")

datos2016 <- datos2016[!is.na(latitud),]

datos2016[, c("latitud", "longitud") := .(fifelse(latitud < -35, latitud/1000, latitud),
                                          fifelse(longitud < -59, longitud / 1000, longitud))]


summary(datos2016)


projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
datos2016 <- st_as_sf(x = datos2016,                         
                      coords = c("longitud", "latitud"),
                      crs = projcrs)

st_write(datos2016, "Preprocesamiento/data/delitos_mapa/delitos2016.shp", delete_dsn = TRUE)

#Juntos: 
juntos <- rbind(datos2016, datos2017, datos2018, datos2019, datos2020)

st_write(juntos, "Preprocesamiento/data/delitos_mapa/delitos.shp", delete_dsn = TRUE)
