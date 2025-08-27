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

#ENTROPY
#Função para o cálculo da entropia dum tema
entropy <-function(toponyms){

freq_vars<-table(toponyms$toponimo)

names_lexemes<-row.names(freq_vars) # Toponymic expressions

num_vars<-length(freq_vars)  # number of toponyms for the theme
freq_lex<-sum(freq_vars) # total occurrences of the toponyms with this theme
list_probs<-as.numeric(vector(mode = "logical",num_vars)) # create a vector for probabilities


for (index in 1:num_vars) {
  probs<-freq_vars[index]/sum(freq_vars) # Probability for each variant
  cat (paste( index, " ", names_lexemes[index], ":", probs, "\n"))
  list_probs[index]<-probs
}

entropy<- -sum(list_probs*log2(list_probs)) # entropy for this theme
return(entropy)
}

# Prints a graph with the frequencies and entropy data

barplot_freq_entropy <-function(list_toponimos_tema){

  entropy_value<-entropy(list_toponimos_tema)

  freq_vars<-table(list_toponimos_tema$toponimo)

  names_lexemes<-row.names(freq_vars) # Toponymic expressions
  num_vars<-length(freq_vars)  # number of toponyms for the theme
  freq_lex<-sum(freq_vars) # total occurrences of the toponyms with this theme

  entropy_show <-signif(entropy_value, digits = 4)
  texto_title <- "Frequência dos diferentes topónimos"
  subtitle_graph <- paste("Topónimos: ", num_vars, "  ", "Entidades geográficas: ",  freq_lex, "  ", "Entropia: ", entropy_show,  sep= "")
  freqs_df <- data.frame(sort(table(list_toponimos_tema$toponimo), TRUE))

  ggplot(freqs_df, aes(y = reorder(Var1, -Freq), x = Freq)) +
    geom_bar(stat = "identity") +
    labs(title = texto_title, subtitle = subtitle_graph,
         x = "Frequência",
         y = "Topónimos") +
    theme_bw()

}

