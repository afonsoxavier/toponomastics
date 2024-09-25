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

