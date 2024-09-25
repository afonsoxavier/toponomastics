# REPORT FUNCTIONS

# Prints a list of toponyms

list_toponimos <-function(search_toponimos){
  for (i in 1:nrow(search_toponimos)) {
    if (search_toponimos$tipo[i] == "lugar") {
      cat(i, search_toponimos$Etiqueta[i], search_toponimos$PART_OF[i], "(",search_toponimos$CONCELLO[i],")\n")
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
