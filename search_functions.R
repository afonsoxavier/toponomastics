# Search functions

# search_data  searches for a given theme or toponym. The them can be a REGEX expression.
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

  if(is.na(search_toponimos$toponimo[1])){
    print("Não se encontrou nenhum topónimo.")
    search_toponimos <- NULL
    return(search_toponimos)
  }
  else {
  search_toponimos <- arrange(search_toponimos, toponimo)
  return(search_toponimos)
  }
}



# Função para evitar que o topónimo se repita em vários níveis de tipo de entidade num mesmo espaço

unique_toponym <- function(df_toponimos) {

  if (is.null(df_toponimos)){
    print("Não se pode avaliar se há topónimos coincidentes porque não há nenhum topónimo para avaliar.")
  } else {
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
      #nome_parroquia_completo <- df_toponimos$PARROQUIA[i]
      nome_concelho <- df_toponimos$CONCELLO[i]


      check_place3 <- filter(df_toponimos, toponimo == nome_parroquia & tipo == "lugar" & PART_OF == nome_parroquia & CONCELLO == nome_concelho)
      if (nrow(check_place3)>0){
        for (x in 1:nrow(check_place3)){
          cat(df_toponimos$toponimo[i], " (", df_toponimos$tipo[i], ") ", "existe também como lugar co topónimo ",  check_place3$toponimo[x], " pertencente a ", check_place3$PART_OF," do concello ", check_place3$CONCELLO, "\n")
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
}


# Função para pesquisar as entidades duma ou mais comarcas

search_comarca <- function(list_concelhos_comarcas_selecionadas){

  #Capturamos os lugares, paróquias e concelhos das comarcas selecionadas
  #Requer que estejam carregadas no script principal as dataframes de lugares, parroquias, concelhos e comarcas

  #lugares
  #NOR_Sant_lugares <- lugares %>% filter(grepl(paste(list_concelhos_comarcas_selecionadas, collapse="|"), CONCELLO))

  lugares_area <-lugares[lugares$CONCELLO %in% list_concelhos_comarcas_selecionadas, ]

  #Freguesias (parróquias)
  # A df de parróquias tem o nome do concelho com maiúscula

  list_concelhos_comarcas_selecionadas_MAI <- toupper(list_concelhos_comarcas_selecionadas)

  parroquias_area <-parroquias[parroquias$PART_OF %in% list_concelhos_comarcas_selecionadas_MAI, ]

  # Concelhos

  #concelhos_area <- concelhos %>% filter(grepl(paste(list_concelhos_comarcas_selecionadas, collapse="|"), toponimo))
  concelhos_area <-concelhos[concelhos$toponimo %in% list_concelhos_comarcas_selecionadas, ]

  #Df com todos os dados para a área

  toponimos_area <- bind_rows(lugares_area,parroquias_area,concelhos_area)
  return(list(lugares_area, parroquias_area, concelhos_area, toponimos_area))

}
