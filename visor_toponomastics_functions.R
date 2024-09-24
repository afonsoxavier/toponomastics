#install the packages
#install.packages("sf)
# install.packages("dplyr")

library(sf)
library(dplyr)


# DATA LOAD


# Lemos os dados e fazemos a primeira análise exploratória em forma de mapas 
#Os dados estão trazidos de https://mapas.xunta.gal/visores/pba/ 
# Para baixá-los ir a ´Selección de Capas' e escolher no menu
#Selecionar MODELO DE ASENTAMENTO > Asentamentos PBA-PBU para os dados
# ou ir diretamente a
# https://visorgis.cmati.xunta.es/cdix/descargas/PlanBasicoAutonomico/2024_06/capas/AsentamentosPBA_PU.zip'
# Último acesso a 23/09/2024


url <- "https://visorgis.cmati.xunta.es/cdix/descargas/PlanBasicoAutonomico/2024_06/capas/AsentamentosPBA_PU.zip"
destfile <- "galiza_shape_file.zip"
download.file(url, destfile)
unzip(destfile, exdir = "galiza_shape_file")


# Entidades menores
lugares <- st_read("galiza_shape_file/_01MAS_202212_AsentamentosPBA.shp")

# Concellos  Selecionar Limites administrativos > Concellos

url <- "https://visorgis.cmati.xunta.es/cdix/descargas/visor_basico/Concellos_IGN.zip"
destfile <-"Concellos_IGN.zip"
download.file(url, destfile)
unzip(destfile, exdir = "Concellos_IGN")

concelhos <- read_sf("Concellos_IGN/Concellos_IGN.shp") # uma fila por concelho geo e áreas
concelhos_lindes <- read_sf("Concellos_IGN/Concellos_IGN_linea.shp")  # dados geo e linhas lindes


# Comarcas  Selecionar Limites administrativos > Comarcas  (como escolher no PBA)
url <- "https://visorgis.cmati.xunta.es/cdix/descargas/visor_basico/Comarcas.zip"
destfile <-"Comarcas.zip"
download.file(url, destfile)
unzip(destfile, exdir = "Comarcas")

comarcas <- read_sf("Comarcas/Comarcas.shp")   # uma linha por comarca e áreas
comarcas_lindes <- read_sf("Comarcas/Comarcas_linea.shp")  # linhas lindes

# Freguesias

url <- "https://visorgis.cmati.xunta.es/cdix/descargas/visor_basico/Parroquias.zip"
destfile <-"Parroquias.zip"
download.file(url, destfile)
unzip(destfile, exdir = "Parroquias")

parroquias <- read_sf("Parroquias/Parroquias.shp")   # uma linha por comarca e áreas
parroquias_lindes <- read_sf("Parroquias/Parroquias_linea.shp")  # linhas lindes


# RAW DATA 

# Lemos o ficheiro co pacote sf
# Info: https://r-spatial.org/book/07-Introsf.html



# DATA CLEANING

#Creamos uma columna co topónimo e o tipo de entidade e combinamos as dataframes


lugares <- mutate(lugares, toponimo= NOME_LUGAR, tipo = "lugar")

#No caso das parroquias, para o topónimo suprimimos o patrão ou patroa entre paréntese
parroquias <- parroquias %>% mutate(parroquias, toponimo =  gsub(" \\(.*?\\)", "", PARROQUIA), tipo = "parroquia")

concelhos <- mutate(concelhos, toponimo= CONCELLO, tipo = "concelho")

comarcas <- mutate(comarcas, toponimo= Comarca, tipo = "comarca")

toponimos <- bind_rows(comarcas,concelhos,parroquias,lugares)



# FUNCTIONS

# Função de pesquisa
# tema = REGEX ou topónimo a pesquisar; tipo_entidade = lugar, parroquia ou concelho (opcional)

search_data <- function(tema,tipo_entidade=NULL) {
  if(is.null(tipo_entidade)){
    search_toponimos <- toponimos[grep(tema, toponimos$toponimo), ]
  } else {
    search_toponimos <- toponimos[grep(tema, toponimos$toponimo), ]
      if(tipo_entidade== "lugar" | tipo_entidade == "parroquia" | tipo_entidade == "concelho") {
      search_toponimos <-search_toponimos[search_toponimos$tipo == tipo_entidade, ] 
    } else {}
  }
 search_toponimos <- arrange(search_toponimos, toponimo)
 return(search_toponimos)
}




# Função para evitar que o topónimo se repita em vários níveis de tipo de entidade num mesmo espaço

unique_toponym <- function(df_toponimos) {
  indexes <-c()   # concelhos que aparecem como freguesia ou lugar dentro do próprio concelho
  indexes2 <-c()  # freguesias que aparecem como lugar dentro da própria freguesia
    for (i in 1:nrow(df_toponimos)) {
    if (df_toponimos$tipo[i] == "concelho") {
      nome_concelho <- df_toponimos$toponimo[i]
      
      # Comprova que não exista já o lugar como topónimo no mesmo concelho
      check_place1 <- filter(df_toponimos, toponimo == nome_concelho & tipo == "lugar" & CONCELLO == nome_concelho) 
     
        if (nrow(check_place1)>0){
          
          for (x in 1:nrow(check_place1)){
          cat(check_place1$toponimo, " ", check_place1$tipo, " existe também como concelho\n" )
          }

                  indexes <-c(indexes,i)  # retira o concelho com entidade menor contida da lista
      }
      
      # Comprova que não exista já a parróquia como topónimo no mesmo concelho
      check_place2 <- filter(df_toponimos, toponimo == nome_concelho & tipo == "parroquia" & CONCELLO == nome_concelho) 
       
        if (nrow(check_place2)>0){
          for (x in 1:nrow(check_place2)){
          cat(check_place2$toponimo[x], " ", check_place2$tipo[x], " também existe como concelho\n")
        }
        
        indexes <-c(indexes,i)  # retira o concelho com freguesia contida da lista
      }
      
      # Comprova que não exista já o lugar como topónimo na mesma freguesia
      
    } else if (df_toponimos$tipo[i] == "parroquia") {
      nome_parroquia <- df_toponimos$toponimo[i]
      nome_parroquia_completo <- df_toponimos$PARROQUIA[i]
      nome_concelho <- df_toponimos$CONCELLO[i]
      

      check_place3 <- filter(df_toponimos, toponimo == nome_parroquia & tipo == "lugar" & ENTIDAD_CO == nome_parroquia_completo & CONCELLO == nome_concelho) 
       if (nrow(check_place3)>0){
          for (x in 1:nrow(check_place3)){
          cat(df_toponimos$toponimo[i], " (", df_toponimos$tipo[i], ") ", "existe também como lugar co topónimo ",  check_place3$toponimo[x], " pertencente a ", check_place3$ENTIDAD_CO," do concello ", check_place3$CONCELLO, "\n")
        }
        
        indexes2 <-c(indexes2,i)  #retira a freguesia com entidade menor contida da lista
      }
      
    }
      else {}
      
  }

  if (length(indexes)){
    df_toponimos <- df_toponimos[-indexes,]
    }
  
  if (length(indexes2)){
    df_toponimos <- df_toponimos[-indexes2,]
  }
  return(df_toponimos)
}  



#DATA VISUALIZATION

#FUNCTIONS

#Mapa na Galiza um só topónimo

map_galiza <- function (lugares, tema=NULL) {
  par(mar = c(0, 0, 0, 0))
  plot(st_geometry(comarcas_lindes), col = "blue", bg = "white", lwd = 0.25, border = 0, axes=TRUE)
  plot(st_geometry(lugares), col="red", pch=17, add = TRUE) # 
   if(!is.null(tema)){
   title_text <- paste ("Topónimos ", tema)
  legend("topleft", title = title_text, bty="n")
   }
}

#Mapa na Galiza comparando topónimos

map_galiza2 <- function (lugares1, lugares2, label1, label2) {
  par(mar = c(0, 0, 0, 0))
  plot(st_geometry(comarcas_lindes), col = "blue", bg = "white", lwd = 0.25, border = 0, axes=TRUE)
  plot(st_geometry(lugares1), col="red", pch=17, add = TRUE) # 
  plot(st_geometry(lugares2), col="black", pch=16, add = TRUE) #
  
  title_text <- paste ("Topónimos em", label1, " e ", label2)
  legend("topleft", legend = c(label1, label2), col = c("red", "black"), pch = c(17,16), title = title_text, bty="n")
}


# Imprime uma lista

list_toponimos <-function(search_toponimos){
  for (i in 1:nrow(search_toponimos)) {
    if (search_toponimos$tipo[i] == "lugar") {
      cat(i, search_toponimos$Etiqueta[i], search_toponimos$ENTIDAD_CO[i], "(",search_toponimos$CONCELLO[i],")\n") 
    } else if (search_toponimos$tipo[i] == "parroquia") {
      cat(i, search_toponimos$toponimo[i], "(",search_toponimos$CONCELLO[i],")\n") 
    } else {
      cat(i, search_toponimos$toponimo[i],"(", search_toponimos$tipo[i],")\n") 
    }
  }
}


# UTILS

# Função para o estudo dum topónimo completo

full_report <-function(tema, tipo_entidade=NULL){
  if(!is.null(tipo_entidade)){
  toponimos_tema <- search_data(tema, tipo_entidade)
  } else {
    toponimos_tema <- search_data(tema)
  }
  
  if (nrow(toponimos_tema)>0){
  map_galiza(toponimos_tema)
  list_toponimos(toponimos_tema)
  return(toponimos_tema)
  } else {
      if(is.null(tipo_entidade)){
       cat ("Não se encontraram entidades com a pesquisa ", tema )
        }
      else {
        cat ("Não se encontraram entidades com o tema ", tema, " e tipo ", tipo_entidade )
      }
    }
  
  
}


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
