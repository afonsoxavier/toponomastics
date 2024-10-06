# READ RAW DATA AND DATA PREPARATION

# Lemos o ficheiro co pacote sf
# Info: https://r-spatial.org/book/07-Introsf.html

read_data_visor_gz <-function(selected_db=NULL){

  #lugares
  lugares <- st_read("galiza_shape_file/_01MAS_202212_AsentamentosPBA.shp")

  #Creamos uma columna co topónimo e o tipo de entidade, reordenamos por orde alfabética do topónimo e combinamos as dataframes com as columnas relevantes

  lugares <- mutate(lugares, tipo = "lugar", PART_OF= gsub(" \\(.*?\\)", "", ENTIDAD_CO))
  lugares <- rename(lugares, CODCONC=COD_CONCEL, CODPARRO=COD_ENT_CO, PARROQUIA=ENTIDAD_CO, toponimo= Etiqueta)
  lugares <-arrange(lugares,toponimo)



  #No caso das parroquias, para o topónimo suprimimos o patrão ou patroa entre paréntese

  parroquias <- read_sf("Parroquias/Parroquias.shp")
  #parroquias_lindes <- read_sf("Parroquias/Parroquias_linea.shp")  # linhas lindes

  #Colhe o topónimo só
  #Deixa o topónimo só
  parroquias <- parroquias %>% mutate(parroquias, toponimo =  gsub(" \\(.*?\\)", "", PARROQUIA), tipo = "parroquia")
  parroquias <-arrange(parroquias, toponimo)
  parroquias <- rename(parroquias, CONCELLO_MAI = NOMEMAY, PART_OF = NOMEMAY)


  #Para os concelhos adiciona o tipo e renomea a columna de província

  concelhos <- read_sf("Concellos_IGN/Concellos_IGN.shp") # uma fila por concelho geo e áreas
  #concelhos_lindes <- read_sf("Concellos_IGN/Concellos_IGN_linea.shp")  # dados geo e linhas lindes
  concelhos <- mutate(concelhos, tipo = "concelho")
  concelhos <- rename(concelhos, toponimo= NAMEUNIT, Provincia=PROVINCIA)
  concelhos <-arrange(concelhos, toponimo)


  #comarcas
  comarcas <- read_sf("Comarcas/Comarcas.shp")   # uma linha por comarca e áreas
  #comarcas_lindes <- read_sf("Comarcas/Comarcas_linea.shp")  # linhas lindes

  comarcas <- mutate(comarcas, tipo = "comarca")
  comarcas <- rename(comarcas, toponimo= Comarca)

  #Crea uma dataframe com todos os topónimos, reorganiza as colunas e seleciona as relevantes
  toponimos <- bind_rows(comarcas,concelhos,parroquias,lugares)

  toponimos <- toponimos[,c(9,3,8,6,7,23,25,27,21,20,4,30)]


  return(list(lugares, parroquias, concelhos, comarcas, toponimos))

}






