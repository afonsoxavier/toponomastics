#DATA VISUALIZATION

#FUNCTIONS

#Mapa na Galiza um só topónimo

map_galiza <- function (lugares, tema=NULL) {
  par(mar = c(0, 0, 0, 0))
  plot(st_geometry(comarcas), col = "grey", bg = "white", lwd = 0.25, border = 0, axes=TRUE)
  plot(st_geometry(lugares), col="red", pch=17, add = TRUE) #
  if(!is.null(tema)){
    clean_theme <- gsub("[^a-zA-ZáéíóúÁÉÍÓÚãõÃÕçÇâêôÂÊÔ]", "", tema)
    title_text <- paste ("Topónimos em ", clean_theme)
    legend("topleft", legend = clean_theme, col = "red", pch = 17, title = title_text, bty="n")
  }
}

#Mapa na Galiza comparando topónimos

map_galiza2 <- function (lugares1, lugares2, label1, label2) {
  par(mar = c(0, 0, 0, 0))
  plot(st_geometry(comarcas), col = "grey", bg = "white", lwd = 0.25, border = 0, axes=TRUE)
  plot(st_geometry(lugares1), col="red", pch=17, add = TRUE) #
  plot(st_geometry(lugares2), col="black", pch=16, add = TRUE) #

  title_text <- paste ("Topónimos em", label1, " e ", label2)
  legend("topleft", legend = c(label1, label2), col = c("red", "black"), pch = c(17,16), title = title_text, bty="n")
}

map_galiza_new <-function(lugares, tema=NULL) {

  ggplot(data = comarcas) + geom_sf() +  geom_sf(data = lugares)

}

map_galiza_new2 <-function(lugares1, lugares2) {

  ggplot(data = comarcas) + geom_sf() +  geom_sf(data = lugares1) + geom_sf(lugares2)

}
