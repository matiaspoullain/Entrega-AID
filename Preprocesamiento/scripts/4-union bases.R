#Este script realiza la union de todas las bases contruidas anteriormente en una sola.
#Se consideró que los datos faltantes de las columnas relacionadas a los delitos denotan 0 delitos cometidos en esa manzana

bomberos <- fread("Preprocesamiento/data/bomberos_manzanas.csv", encoding = "UTF-8")

bomberos <- bomberos %>%
  rename(id_bomberos = ID)

comisarias <- fread("Preprocesamiento/data/comisarias_manzanas.csv", encoding = "UTF-8")

comisarias <- comisarias %>%
  rename(id_comisarias = id)

delitos <- fread("Preprocesamiento/data/delitos_manzanas.csv", encoding = "UTF-8")

delitos <- delitos[, .(n = .N), by = .(id_manzana, tipo)]

delitos <- dcast(delitos, id_manzana ~ tipo, value.var = "n")

delitos <- delitos[!is.na(id_manzana), ]
delitos[is.na(delitos)] <- 0


educacion <- fread("Preprocesamiento/data/educacion_manzanas.csv")

educacion <- educacion %>%
  rename(id_educacion = dom_edific)


hospitales <- fread("Preprocesamiento/data/hospitales_manzanas.csv", encoding = "UTF-8")

hospitales <- hospitales %>%
  rename(id_hospitales = ID)


privados <- fread("Preprocesamiento/data/privados_manzanas.csv", encoding = "UTF-8")

privados <- privados %>%
  rename(id_privados = NOMBRE)


#Junto todos:
juntos <- bomberos %>%
  merge(comisarias, by = "id_manzana", all = TRUE) %>%
  merge(delitos, by = "id_manzana", all = TRUE) %>%
  merge(educacion, by = "id_manzana", all = TRUE) %>%
  merge(hospitales, by = "id_manzana", all = TRUE) %>%
  merge(privados, by = "id_manzana", all = TRUE)

juntos[is.na(id_bomberos),]

juntos[is.na(juntos)] <- 0

fwrite(juntos, "Preprocesamiento/data/union_bases.csv")




