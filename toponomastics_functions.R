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
