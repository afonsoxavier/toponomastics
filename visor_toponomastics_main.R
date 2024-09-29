#install the packages
#install.packages("sf)
# install.packages("dplyr")

library(sf)
library(dplyr)

#LOAD DATA

#source("load_data_gz.R")  #uncomment this line to download data from the web

# READ RAW DATA

source("read_data_functions.R")   # function to create sf objects from loaded data

#Seleciona e carrega os dados do visor PBA como objetos geográficos sf, renomea as colunas de variáveis coincidentes para melhorar a operatividade e evitar multiplicação de NAs numa dataframe única de topónimos

db_visorpba<-read_data_visor_gz()

lugares <-db_visorpba[[1]]
parroquias <-db_visorpba[[2]]
parroquias_lindes <-db_visorpba[[3]]
concelhos <- db_visorpba[[4]]
concelhos_lindes <- db_visorpba[[5]]
comarcas <- db_visorpba[[6]]
comarcas_lindes <- db_visorpba[[7]]

#Crea uma dataframe com todos os topónimos, reorganiza as colunas e seleciona as relevantes

toponimos <- db_visorpba[[8]]


#SEARCH AND REPORT FUNCTIONS

#source("toponomastics_functions.R")  # All functions in a file (will be deprecated)

source("search_functions.R")   # funções de pesquisa
source("map_functions.R")  # funções de cartografia
source("report_functions.R") # funções de listagens e informes


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
lugares_is <- search_data("ís$", "lugar") #pesquisa lugares acabados em -is tónico
lugares_iz <- search_data("iz$", "lugar") #pesquisa lugares acabados em -iz

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
map_galiza(lugares_is) # representamos só os acabados em is sem eliminar entidades superiores que coocorren
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

unicos_ufe<-unique_toponym(search_data("ufe$"))  # Evita as entidades superiores em que o mesmo topónimo a diferentes tipos de entidade (ex. lugar e ao mesmo tempo parróquia e/ou concelho)
unicos_ulfe<-unique_toponym(search_data("ulfe$"))
map_galiza(unicos_ufe) # representamos só os acabados em ufe
map_galiza2(unicos_ufe, unicos_ulfe, "-ufe", "-ulfe")  # comparamos ufe e ulfe no mapa

barplot_freq(unicos_ufe)
barplot_freq(unicos_ulfe)


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
