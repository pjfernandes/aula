###carregando pacotes
library(tidyverse)
library(raster)
library(tmap)

###diretório de trabalho
setwd("/home/uff/Área de Trabalho/arquivos/code/curso_geografia_educacao/dados")

###lendo dados
df_2009 <- read_csv2("microdados_ed_basica_2009.csv")
df_2022 <- read_csv2("microdados_ed_basica_2022.csv")

head(df_2009)
head(df_2022)

###filtrando dados
df_escolas_estaduais_RJ_2009 <- df_2009 %>% filter(SG_UF == "RJ", TP_DEPENDENCIA == 2)
df_escolas_municipais_RJ_2009 <- df_2009 %>% filter(SG_UF == "RJ", TP_DEPENDENCIA == 3)

df_escolas_estaduais_RJ_2022 <- df_2022 %>% filter(SG_UF == "RJ", TP_DEPENDENCIA == 2)
df_escolas_municipais_RJ_2022 <- df_2022 %>% filter(SG_UF == "RJ", TP_DEPENDENCIA == 3)

###numero de labs de informática por município do RJ
df_rj_lab_info_2009 <- df_escolas_estaduais_RJ_2009 %>% 
  dplyr::select(NO_MUNICIPIO, IN_LABORATORIO_INFORMATICA, CO_MUNICIPIO) %>% 
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(IN_LABORATORIO_INFORMATICA, na.rm=T))

df_rj_lab_info_2022 <- df_escolas_estaduais_RJ_2022 %>% 
  dplyr::select(NO_MUNICIPIO, IN_LABORATORIO_INFORMATICA, CO_MUNICIPIO) %>% 
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(IN_LABORATORIO_INFORMATICA, na.rm=T))

###numero de labs de ciencias por município do RJ
df_rj_lab_ciencias_2009 <- df_escolas_estaduais_RJ_2009 %>% 
  dplyr::select(NO_MUNICIPIO, IN_LABORATORIO_CIENCIAS, CO_MUNICIPIO) %>% 
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(IN_LABORATORIO_CIENCIAS, na.rm=T))

df_rj_lab_ciencias_2022 <- df_escolas_estaduais_RJ_2022 %>% 
  dplyr::select(NO_MUNICIPIO, IN_LABORATORIO_CIENCIAS, CO_MUNICIPIO) %>% 
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(IN_LABORATORIO_CIENCIAS, na.rm=T))

###numero de escolas estaduais ativas por município do RJ
df_rj_ativas_2009 <- df_escolas_estaduais_RJ_2009 %>% 
  dplyr::select(NO_MUNICIPIO, TP_SITUACAO_FUNCIONAMENTO, CO_MUNICIPIO) %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1) %>%
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(TP_SITUACAO_FUNCIONAMENTO, na.rm=T))

df_rj_ativas_2022 <- df_escolas_estaduais_RJ_2022 %>% 
  dplyr::select(NO_MUNICIPIO, TP_SITUACAO_FUNCIONAMENTO, CO_MUNICIPIO) %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1) %>%
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(TP_SITUACAO_FUNCIONAMENTO, na.rm=T))

dif_escolas_ativas <- df_rj_ativas_2022$sum - df_rj_ativas_2009$sum

###numero de escolas estaduais ativas por município do RJ
df_rj_ativas_2009_municipais <- df_escolas_municipais_RJ_2009 %>% 
  dplyr::select(NO_MUNICIPIO, TP_SITUACAO_FUNCIONAMENTO, CO_MUNICIPIO) %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1) %>%
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(TP_SITUACAO_FUNCIONAMENTO, na.rm=T))

df_rj_ativas_2022_municipais <- df_escolas_municipais_RJ_2022 %>% 
  dplyr::select(NO_MUNICIPIO, TP_SITUACAO_FUNCIONAMENTO, CO_MUNICIPIO) %>% 
  filter(TP_SITUACAO_FUNCIONAMENTO==1) %>%
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(TP_SITUACAO_FUNCIONAMENTO, na.rm=T))

dif_escolas_ativas_municipais <- df_rj_ativas_2022_municipais$sum - df_rj_ativas_2009_municipais$sum

###numero de matrículas nas escolas estaduais por município do RJ
df_rj_matriculas_2009 <- df_escolas_estaduais_RJ_2009 %>% 
  dplyr::select(NO_MUNICIPIO, QT_MAT_BAS, CO_MUNICIPIO) %>% 
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(QT_MAT_BAS, na.rm=T))

df_rj_matriculas_2022 <- df_escolas_estaduais_RJ_2022 %>% 
  dplyr::select(NO_MUNICIPIO, QT_MAT_BAS, CO_MUNICIPIO) %>% 
  group_by(NO_MUNICIPIO, CO_MUNICIPIO) %>% 
  summarise(sum=sum(QT_MAT_BAS, na.rm=T))

dif_matriculas <- df_rj_matriculas_2022$sum - df_rj_matriculas_2009$sum

###carregando shapefile
shape_rj <- shapefile("RJ_Municipios_2022.shp")
shape_rj@data

names(df_rj_lab_info)[2] <- "CD_MUN"

###merge
tabela_atributos <- merge(x=shape_rj@data, y=df_rj_lab_info, by="CD_MUN")
shape_rj@data <- tabela_atributos

#calculando porcentagem
porc <- (shape_rj@data$sum/sum(shape_rj@data$sum)) * 100
shape_rj@data <- cbind(shape_rj@data, porc)

###mapa interativo
tmap_mode("view")
tm_shape(shape_rj) + 
  tm_polygons("porc", 
              palette="Reds",
              breaks=c(0,2,5,7,9,12,15,20,25),
              title="Labs. de informática (rede estadual)",
              id="porc"
              )
