#install the packages
#install.packages("sf)
# install.packages("dplyr")
#install.packages("ggrepel")

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

#source("toponomastics_functions.R")  # All functions in a file (will be deprecated)

source("search_functions.R")   # funções de pesquisa
source("map_functions.R")  # funções de cartografia
source("report_functions.R") # funções de listagens e informes



# -ufe

unicos_ufe<-unique_toponym(search_data("ufe$"))
entropy(unicos_ufe)
barplot_freq_entropy(unicos_ufe)

# -urfe
todos_urfe<-search_data("(o|u)rfe")
print(todos_urfe)
entropy(todos_urfe)
barplot_freq_entropy(todos_urfe)




