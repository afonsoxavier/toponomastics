library(sf)
library(dplyr)
library(ggplot2)
library(ggrepel)


theme_set(theme_bw()) #set theme for ggplot2

#LOAD DATA

#source("load_data_gz.R")  #uncomment this line to download data from the web

# READ RAW DATA

source("read_data_functions.R")   # function to create sf objects from loaded data

#Seleciona e carrega os dados do visor PBA como objetos geográficos sf, renomea as colunas de variáveis coincidentes para melhorar a operatividade e evitar multiplicação de NAs numa dataframe única de topónimos

db_visorpba<-read_data_visor_gz()

lugares <-db_visorpba[[1]]
parroquias <-db_visorpba[[2]]
#parroquias_lindes <-db_visorpba[[3]]
concelhos <- db_visorpba[[3]]
#concelhos_lindes <- db_visorpba[[5]]
comarcas <- db_visorpba[[4]]
#comarcas_lindes <- db_visorpba[[7]]

#Crea uma dataframe com todos os topónimos, reorganiza as colunas e seleciona as relevantes

toponimos <- db_visorpba[[5]]


#SEARCH AND REPORT FUNCTIONS

#source("toponomastics_functions.R")  # All functions in a file (will be deprecated)

source("search_functions.R")   # funções de pesquisa
source("map_functions.R")  # funções de cartografia
source("report_functions.R") # funções de listagens e informes

unicos_ufe<-unique_toponym(search_data("ufe$"))  # Evita as entidades superiores em que o mesmo topónimo a diferentes tipos de entidade (ex. lugar e ao mesmo tempo parróquia e/ou concelho)
unicos_ulfe<-unique_toponym(search_data("ulfe$"))
map_galiza(unicos_ufe, "ufe") # representamos só os acabados em ufe
map_galiza2(unicos_ufe, unicos_ulfe, "-ufe", "-ulfe")  # comparamos ufe e ulfe no mapa

map_gg(unicos_ufe) # Usa ggplot2
map_gg2(unicos_ufe, unicos_ulfe, "-ufe", "-ulfe")

#Map1 Comarcas de Galiza
ggplot(data = comarcas) +
  geom_sf() +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Galiza", subtitle = paste0("(", length(unique(comarcas$toponimo)), " comarcas)"))


#Map2 Comarcas de Galiza
ggplot(data = comarcas) +
  geom_sf(color = "black", fill = "green")


#Map3 Comarcas de Galiza
ggplot(data = comarcas) +
  geom_sf(color = "black", fill = "grey") +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Galiza", subtitle = paste0("(", length(unique(comarcas$toponimo)), " comarcas)"))


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

comarcas_selecionadas <- c("A Barcala","Bergantiños", "A Coruña", "Fisterra", "Muros", "Noia", "Ordes", "Santiago", "Terra De Soneira", "Xallas")


#Capturamos os dados para as comarcas selecionadas

NOR_Sant_area <-comarcas %>% filter (toponimo %in% comarcas_selecionadas)

list_concelhos_comarcas_selecionadas <- c(barcala, bergantinhos, corunha, fisterra, muros,noia, ordes, santiago, soneira, xallas)

#Capturamos os lugares, paróquias e concelhos das comarcas selecionadas

#lugares
#NOR_Sant_lugares <- lugares %>% filter(grepl(paste(list_concelhos_comarcas_selecionadas, collapse="|"), CONCELLO))

NOR_Sant_lugares <-lugares[lugares$CONCELLO %in% list_concelhos_comarcas_selecionadas, ]

#Freguesias (parróquias)
# A df de parróquias tem o nome do concelho com maiúscula

list_concelhos_comarcas_selecionadas_MAI <- toupper(list_concelhos_comarcas_selecionadas)

NOR_Sant_parroquias <-parroquias[parroquias$PART_OF %in% list_concelhos_comarcas_selecionadas_MAI, ]

# Concelhos

#NOR_Sant_concelhos <- concelhos %>% filter(grepl(paste(list_concelhos_comarcas_selecionadas, collapse="|"), toponimo))
NOR_Sant_concelhos <-concelhos[concelhos$toponimo %in% list_concelhos_comarcas_selecionadas, ]

#Df com todos os dados para a área

NOR_Sant_toponimos <- bind_rows(NOR_Sant_lugares,NOR_Sant_parroquias,NOR_Sant_concelhos, NOR_Sant_area)


#Map1 ggplot2 Comarcas

map_gg(comarcas)

#Map2 ggplot3 concelhos

ggplot(data=NOR_Sant_concelhos) + geom_sf()

#Map3 parróquias área NO Santiago

ggplot(data=NOR_Sant_parroquias) + geom_sf() #só a área

map_gg(NOR_Sant_parroquias)  #na Galiza

#Map4 Comarcas de Galiza
ggplot(data = comarcas) +
  geom_sf(color = "black", fill = "grey") +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("Galiza", subtitle = paste0("(", length(unique(comarcas$toponimo)), " comarcas)"))
# + theme(panel.background = element_rect(fill = “aliceblue”))

#Map5 parroquias Galiza
ggplot(data = parroquias) +
  geom_sf(color = "black", fill = "grey")



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

length_mir_mil <- length(lugares_mir_berg_area$toponimo) + length(lugares_mil_berg_area$toponimo)


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
ggtitle("Topónimos em -mir e -mil na área de Bergantinhos e A Corunha", subtitle = paste0("(", length_mir_mil, " topónimos)"))
