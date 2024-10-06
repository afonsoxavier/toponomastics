
library(sf)
library(dplyr)
library(ggplot2)
library(ggrepel)


#LOAD DATA

#source("load_data_gz.R")  #uncomment this line to download data from the web

# READ RAW DATA

source("read_data_functions.R")   # function to create sf objects from loaded data

#Seleciona e carrega os dados do visor PBA como objetos geográficos sf, renomea as colunas de variáveis coincidentes para melhorar a operatividade e evitar multiplicação de NAs numa dataframe única de topónimos

db_visorpba<-read_data_visor_gz()

lugares <-db_visorpba[[1]]
parroquias <-db_visorpba[[2]]
concelhos <- db_visorpba[[3]]
comarcas <- db_visorpba[[4]]

#Crea uma dataframe com todos os topónimos, reorganiza as colunas e seleciona as relevantes

toponimos <- db_visorpba[[5]]


#SEARCH AND REPORT FUNCTIONS

source("search_functions.R")   # funções de pesquisa
source("map_functions.R")  # funções de cartografia
source("report_functions.R") # funções de listagens e informes


#DATA SELECTION

# Selecionamos os dados relevantes para a área de estudo

#Escolhemos e definimos as comarcas

barcala <- c("A Baña", "Negreira")
bergantinhos <- c("Cabana de Bergantiños", "Carballo", "Coristanco", "A Laracha", "Laxe", "Malpica de Bergantiños", "Ponteceso")
corunha <- c("Abegondo", "Arteixo", "Bergondo", "Cambre", "Carral", "A Coruña", "Culleredo", "Oleiros", "Sada")
fisterra <- c("Cee", "Corcubión", "Dumbría", "Fisterra", "Muxía")
muros <- c ("Carnota", "Muros")
noia <- c("Lousame", "Noia", "Outes", "Porto do Son")
ordes <- c("Cerceda", "Frades", "Mesía", "Ordes", "Oroso", "Tordoia", "Trazo")
santiago <- c("Ames", "Boqueixón", "Brión", "Santiago de Compostela", "Teo", "Val do Dubra", "Vedra")
soneira <- c("Camariñas", "Vimianzo", "Zas")
xallas <- c("Mazaricos", "Santa Comba")

#Capturamos os dados para as comarcas selecionadas

comarcas_selecionadas <- c("A Barcala","Bergantiños", "A Coruña", "Fisterra", "Muros", "Noia", "Ordes", "Santiago", "Terra De Soneira", "Xallas")
list_concelhos_comarcas_selecionadas <- c(barcala, bergantinhos, corunha, fisterra, muros,noia, ordes, santiago, soneira, xallas)
NOR_Sant_comarcas <-comarcas %>% filter (toponimo %in% comarcas_selecionadas)


#Capturamos os lugares, paróquias e concelhos das comarcas selecionadas

NOR_Sant_area <-search_comarca(list_concelhos_comarcas_selecionadas)

#Topónimos

NOR_Sant_lugares <-NOR_Sant_area[[1]]
NOR_Sant_parroquias <-NOR_Sant_area[[2]]
NOR_Sant_concelhos <- NOR_Sant_area[[3]]
NOR_Sant_toponimos <- NOR_Sant_area[[4]] # todos os topónimos

#Pesquisa
toponimos_mir_NOR_Sant_area <- unique_toponym(NOR_Sant_toponimos[grep("mir$", NOR_Sant_toponimos$toponimo), ])
toponimos_mil_NOR_Sant_area <- unique_toponym(NOR_Sant_toponimos[grep("mil$", NOR_Sant_toponimos$toponimo), ])
length_mir_mil_NOR <- length(toponimos_mir_NOR_Sant_area$toponimo) + length(toponimos_mil_NOR_Sant_area$toponimo) #número de topónimos encontrados


#Map Final
ggplot(data=NOR_Sant_comarcas) + geom_sf()+  xlab("") + ylab("")+
  geom_sf(data=toponimos_mir_NOR_Sant_area) +
  geom_text_repel(data=toponimos_mir_NOR_Sant_area, aes(label = toponimo, geometry = geometry),
                  stat = "sf_coordinates",
                  size = 3,fontface = "bold",
                  color = "red" ,  vjust="top", hjust="right") +
  geom_sf(data=toponimos_mil_NOR_Sant_area) +
  geom_text_repel(data=toponimos_mil_NOR_Sant_area, aes(label = toponimo, geometry = geometry),
            stat = "sf_coordinates", vjust="top", hjust="right",
            size = 3, fontface = "bold",
            color = "blue") +

  ggtitle("Topónimos em -mir e -mil na área NO de Santiago de Compostela", subtitle = paste0("(", length_mir_mil_NOR, " topónimos)"))



#More specific area

# Seleciono só Bergantinhos e A Corunha

#Capturamos os lugares, paróquias e concelhos das comarcas selecionadas

comarcas_selecionadas <- c("Bergantiños", "A Coruña")
list_concelhos_comarcas_selecionadas <- c(bergantinhos, corunha)
berg_comarcas <-comarcas %>% filter (toponimo %in% comarcas_selecionadas)

berg_area <-search_comarca(list_concelhos_comarcas_selecionadas)

#Topónimos

berg_lugares <-berg_area[[1]]
berg_parroquias <-berg_area[[2]]
berg_concelhos <- berg_area[[3]]
berg_toponimos <- berg_area[[4]] # todos os topónimos

#Pesquisa
lugares_mir_berg_area <- berg_toponimos[grep("mir$", berg_toponimos$toponimo), ]
lugares_mil_berg_area <- berg_toponimos[grep("mil$", berg_toponimos$toponimo), ]
length_mir_mil <- length(lugares_mir_berg_area$toponimo) + length(lugares_mil_berg_area$toponimo) #número de topónimos encontrados

#Map Final

ggplot(data=berg_comarcas) + geom_sf()+  xlab("") + ylab("")+
  #geom_sf(data=berg_parroquias) +
  geom_sf(data=lugares_mir_berg_area) +
  geom_text_repel(data=lugares_mir_berg_area, aes(label = toponimo, geometry = geometry),
                  stat = "sf_coordinates",
                  size = 4, fontface = "bold", hjust="left",
                  color = "red") +
  geom_sf(data=lugares_mil_berg_area) +
  geom_text(data=lugares_mil_berg_area, aes(label = toponimo, geometry = geometry),
            stat = "sf_coordinates", vjust="bottom", hjust="right",
            size = 4, fontface = "bold",
            color = "blue") +
  #ggtitle("Topónimos em -mir e -mil na área de Bergantinhos e A Corunha", subtitle = paste0("(", length_mir_mil, " topónimos)")

  ggtitle("Topónimos em -mir e -mil na área de Bergantinhos e A Crunha", subtitle = paste0("(", length_mir_mil, " topónimos)"))
