#install the packages
#install.packages("sf)
# install.packages("dplyr")

library(sf)
library(dplyr)

#LOAD DATA

#source("load_data_gz.R")  #uncomment this line to download data from the web

# READ RAW DATA

# Lemos o ficheiro co pacote sf
# Info: https://r-spatial.org/book/07-Introsf.html


lugares <- st_read("galiza_shape_file/_01MAS_202212_AsentamentosPBA.shp")

concelhos <- read_sf("Concellos_IGN/Concellos_IGN.shp") # uma fila por concelho geo e áreas
concelhos_lindes <- read_sf("Concellos_IGN/Concellos_IGN_linea.shp")  # dados geo e linhas lindes


comarcas <- read_sf("Comarcas/Comarcas.shp")   # uma linha por comarca e áreas
comarcas_lindes <- read_sf("Comarcas/Comarcas_linea.shp")  # linhas lindes


parroquias <- read_sf("Parroquias/Parroquias.shp")   # uma linha por comarca e áreas
parroquias_lindes <- read_sf("Parroquias/Parroquias_linea.shp")  # linhas lindes


# DATA PREPARATION

#Creamos uma columna co topónimo e o tipo de entidade, reordenamos por orde alfabética do topónimo e combinamos as dataframes com as columnas relevantes

lugares <- mutate(lugares, tipo = "lugar")
lugares <- rename(lugares, CODCONC=COD_CONCEL, CODPARRO=COD_ENT_CO, PART_OF=ENTIDAD_CO, toponimo= NOME_LUGAR)
lugares <-arrange(lugares,toponimo)

#No caso das parroquias, para o topónimo suprimimos o patrão ou patroa entre paréntese
parroquias <- parroquias %>% mutate(parroquias, toponimo =  gsub(" \\(.*?\\)", "", PARROQUIA), tipo = "parroquia")
parroquias <-arrange(parroquias, toponimo)

concelhos <- mutate(concelhos, tipo = "concelho")
concelhos <- rename(concelhos, toponimo= CONCELLO, Provincia=PROVINCIA)
concelhos <-arrange(concelhos, toponimo)

comarcas <- mutate(comarcas, tipo = "comarca")
comarcas <- rename(comarcas, toponimo= Comarca)

toponimos <- bind_rows(comarcas,concelhos,parroquias,lugares)

toponimos <- toponimos[,c(3,9,8,6,7,30,25,26,27,28,29,31,32,22,20,21,23,1,2,4)]

#SEARCH AND REPORT FUNCTIONS

#source("toponomastics_functions.R")  # All functions in a file (will be deprecated)

source("search_functions.R")
source("map_functions.R")
source("report_functions.R")


# EXPLORATORY ANALYSIS

# Exemplo -iz e -is

#Informe rápido
# Cria uma listagem de topónimos e coloca-os no mapa

full_report("iz$", "concelho") # pesquisa, cria listagem e mapa de concelhos acabados em -iz
full_report("iz$", "parroquia") # pesquisa, cria listagem e mapa de freguesias acabamas em -iz
full_report("iz$", "lugar") # pesquisa, cria listagem e mapa de lugares acabados em -iz
full_report ("iz$") # pesquisa, cria listagem e mapa de todos os topónimos sem importar o tipo


#Pesquisas específicas
#Procuramos topónimos especificando o tipo de entidade

lugares_is_atono <- search_data("is$", "lugar") # pesquisa lugares acabados em -is átono
lugares_is <- search_data("ís$", "lugar")
lugares_iz <- search_data("ís$", "lugar")

list_toponimos(lugares_is_atono)
list_toponimos(lugares_is)
list_toponimos(lugares_iz)

#Procuramos todos os topónimos

toponimos_iz <- search_data("iz$") # Sem especificar tipo de entidade
list_toponimos(toponimos_iz)
toponimos_is <- search_data("ís$") # Sem especificar tipo de entidade
list_toponimos(toponimos_is)

#A listagem sem concelhos nem freguesias se já existe uma unidade menor associada

unicos_iz<-unique_toponym(toponimos_iz)
unicos_is<-unique_toponym(toponimos_is)
list_toponimos(unicos_iz)
list_toponimos(unicos_is)

#Representamos no mapa
#A representação é mais clara se se seleciona previamente o tipo de entidade

map_galiza(lugares_iz) # representamos só os acabados em iz  sem eliminar entidades superiores que coocorren
map_galiza(lugares_is) # representamos só os acabados em iz sem eliminar entidades superiores que coocorren
map_galiza2(lugares_iz, lugares_is, "iz", "ís")  # comparamos is e iz no mapa sem eliminar entidades superiores que coocorren

# ou se filtram as entidades maiores quando já existe uma menor co mesmo topónimo

map_galiza(unicos_iz)
map_galiza(unicos_is)
map_galiza2(unicos_iz, unicos_is, "iz", "ís")


#-mir e -mil

toponimos_mir <- search_data("mir$")
toponimos_mil <- search_data("mil$")
list_toponimos(toponimos_mir)
list_toponimos(toponimos_mil)
map_galiza(toponimos_mir) # representamos só os acabados em mir
map_galiza2(toponimos_mir, toponimos_mil, "-mir", "-mil")  # comparamos mir e mil no mapa


#Todos os tipos de entidades filtrando as coocorrentes superiores
unicos_mir<-unique_toponym(toponimos_mir)
unicos_mil<-unique_toponym(toponimos_mil)
map_galiza(unicos_mir) # representamos só os acabados em mir
map_galiza2(unicos_mir, unicos_mil, "-mir", "-mil")  # comparamos mir e mil no mapa


# -ufe

variantes_ufe<- c("ufe$", "ulfe$", "ofe$", "ofre$", "olfe$", "olfre$", "ufre$", "orfe$", "urfe$")
sapply (variantes_ufe, full_report)


# -mar -tar - zar -sar
# modo alternativo de pesquisa

toponimos_ar <- search_data("mar$|tar$|sar$|zar$")
unicos_ar<-unique_toponym(toponimos_ar)
map_galiza(unicos_ar)

# gun gon   em qualquer posição

lugares_gun <- lugares[grep("(gun|gon)", toponimos$toponimo), ] # modo alternativo
lugares_gun_gon <- search_data("gun|gon")

map_galiza(lugares_gun_gon)


# sende posição final
variantes_sende <- c("sende$", "sinde$", "cende$", "cinde$", "zende$", "zinde$")
sapply (variantes_sende, full_report)

# galt posição inicial
full_report("^Galt")
