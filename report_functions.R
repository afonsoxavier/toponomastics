# REPORT FUNCTIONS

# Prints a list of toponyms

list_toponimos <-function(search_toponimos){
  for (i in 1:nrow(search_toponimos)) {
    if (search_toponimos$tipo[i] == "lugar") {
      cat(i, search_toponimos$toponimo[i], search_toponimos$PART_OF[i], "(",search_toponimos$CONCELLO[i],")\n")
    } else if (search_toponimos$tipo[i] == "parroquia") {
      cat(i, search_toponimos$toponimo[i], "(",search_toponimos$CONCELLO[i],")\n")
    } else {
      cat(i, search_toponimos$toponimo[i],"(", search_toponimos$tipo[i],")\n")
    }
  }
}


# Prints a graph with the frequencies

barplot_freq <-function(list_toponimos_tema){

freqs_df <- data.frame(sort(table(list_toponimos_tema$toponimo), TRUE))

ggplot(freqs_df, aes(y = reorder(Var1, -Freq), x = Freq)) +
  geom_bar(stat = "identity") +
  labs(title = "Frequência dos diferentes topónimos",
       x = "Frequência",
       y = "Topónimos") +
  theme_bw()

}




# UTILS

# Função para o estudo dum topónimo completo

full_report <-function(tema, tipo_entidade=NULL){

  if(!is.null(tipo_entidade)){
    toponimos_tema <- search_data(tema, tipo_entidade)
  } else {
    toponimos_tema <- search_data(tema)

  }

  if (!is.null(toponimos_tema)){
    map_galiza(toponimos_tema, tema)

    list_toponimos(toponimos_tema)

    #return(toponimos_tema)
  } else {
    if(is.null(tipo_entidade)){
      cat ("Não se encontraram entidades com a pesquisa ", tema )
    }
    else {
      cat ("Não se encontraram entidades com o tema ", tema, " e tipo ", tipo_entidade )
    }
  }


}
