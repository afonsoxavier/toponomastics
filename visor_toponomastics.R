#install the packages

#install.packages("ggplot2")
#install.packages("ggmap")
#install.packages("maps")
# install.packages("dplyr")

library(sf)
library(dplyr)


# DATA LOAD

# RAW DATA AND FIRST EXPLORATORY ANALYSIS
# Lemos os dados e fazemos a primeira análise exploratória em forma de mapas 
#Os dados estão trazidos de https://mapas.xunta.gal/visores/pba/ 
# Para baixá-los ir a ´Selección de Capas' e escolher no menu


#Selecionar MODELO DE ASENTAMENTO > Asentamentos PBA-PBU para os dados

# Lemos o ficheiro co pacote sf
# Info: https://r-spatial.org/book/07-Introsf.html

lugares1 <- st_read("regNor/_01MAS_202212_AsentamentosPBA.shp")

lugares <- lugares1
# Selecionamos os lugares dum concelho

laracha <- lugares[lugares$CONCELLO == "A Laracha", ]  # co nome
laracha2 <- lugares[lugares$COD_CONCEL == "15041", ]  # co código



# Concellos  Selecionar Limites administrativos > Concellos
concelhos <- read_sf("Concellos_IGN/Concellos_IGN.shp") # uma fila por concelho geo e áreas
concelhos_lindes <- read_sf("Concellos_IGN/Concellos_IGN_linea.shp")  # dados geo e linhas lindes

#Mapas de prova
par(mar = c(0, 0, 0, 0))
plot(st_geometry(concelhos), col = "brown", bg = "white", lwd = 0.25, border = 0)
par(mar = c(0, 0, 0, 0))
plot(st_geometry(concelhos_lindes), col = "black", bg = "white", lwd = 0.25, border = 0)


# Comarcas  Selecionar Limites administrativos > Comarcas  (como escolher no PBA)

comarcas <- read_sf("Comarcas/Comarcas.shp")   # uma linha por comarca e áreas
comarcas_lindes <- read_sf("Comarcas/Comarcas_linea.shp")  # linhas lindes

#Mapas de prova
par(mar = c(0, 0, 0, 0))
plot(st_geometry(comarcas), col = "green", bg = "white", lwd = 0.25, border = 0)

par(mar = c(0, 0, 0, 0))
plot(st_geometry(comarcas_lindes), col = "blue", bg = "white", lwd = 0.25, border = 0)


# DATA SELECTION

# Selecionamos os dados relevantes para a área de estudo

# Transform long/lat to mercator EPSG:3857)
# For the method
# https://r-spatial.github.io/sf/articles/sf1.html
# For the coordinates system
# https://stackoverflow.com/questions/72642237/shape-file-and-sf-data-frame-geometry-into-latitude-longitude-columns

# lugares <- st_transform(lugares, "EPSG:4326")


#Escolhemos e definimos as comarcas

barcala <- c("A Baña", "Negreira")
bergantinhos <- c("Cabana de Bergantiños", "Carballo", "Coristanco", "A Laracha", "Laxe", "Malpica de Bergantiños", "Ponteceso")
corunha <- c("Abegondo", "Arteixo", "Bergondo", "Cambre", "Carral", "A Coruña", "Culleredo", "Oleiros", "Sada")
fisterra <- c("Cee", "Corcubión", "Dumbría", "Fisterra", "Muxía")
muros <- c ("Carnota", "Muros")
noia <- c("Lousame", "Noia", "Outes", "Porto do Son")
ordes <- c("Cerceda", "Frades", "Mesía", "Ordes", "Oroso", "Tordoia", "Trazo")
santiago <- c("Ames", "Boqueixón", "Brión", "Santiago de Compostela", "Teo", "Val do Dubra", "Vedra")
soneira <- c("Camariñas", "Vimianzo", "Zas")
xallas <- c("Mazaricos", "Santa Comba") 



barcala_area <- comarcas[comarcas$Comarca == "A Barcala", ]  # co nome e dados para o mapa
bergantinhos_area <- comarcas[comarcas$Comarca == "Bergantiños", ]  # co nome e dados para o mapa
corunha_area <- comarcas[comarcas$Comarca == "A Coruña", ]  # co nome e dados para o mapa
fisterra_area <- comarcas[comarcas$Comarca == "Fisterra", ]  # co nome e dados para o mapa
muros_area <- comarcas[comarcas$Comarca == "Muros", ]  # co nome e dados para o mapa
noia_area <- comarcas[comarcas$Comarca == "Noia", ]  # co nome e dados para o mapa
ordes_area <- comarcas[comarcas$Comarca == "Ordes", ]  # co nome e dados para o mapa
santiago_area <- comarcas[comarcas$Comarca == "Santiago", ]  # co nome e dados para o mapa
soneira_area <- comarcas[comarcas$Comarca == "Terra De Soneira", ]  # co nome e dados para o mapa
xallas_area <- comarcas[comarcas$Comarca == "Xallas", ]  # co nome e dados para o mapa


NOR_Sant_area1 <- bind_rows(barcala_area, bergantinhos_area, corunha_area, fisterra_area, muros_area, noia_area, ordes_area, santiago_area, soneira_area, xallas_area)

#Method 2
NOR_Sant_area_dyp <- comarcas %>% filter (Comarca %in% c("A Barcala","Bergantiños", "A Coruña", "Fisterra", "Muros", "Noia", "Ordes", "Santiago", "Terra De Soneira", "Xallas"))

#Method 3

# https://stackoverflow.com/questions/25647470/filter-multiple-values-on-a-string-column-in-dplyr

comarcas_selecionadas <- c("A Barcala","Bergantiños", "A Coruña", "Fisterra", "Muros", "Noia", "Ordes", "Santiago", "Terra De Soneira", "Xallas")
NOR_Sant_area <-comarcas %>% filter (Comarca %in% comarcas_selecionadas)




#Associamos os lugares à comarca

lug_barcala <- lugares %>% filter(grepl(paste(barcala, collapse="|"), CONCELLO))
lug_bergantinhos <- lugares %>% filter(grepl(paste(bergantinhos, collapse="|"), CONCELLO))
lug_corunha <- lugares %>% filter(grepl(paste(corunha, collapse="|"), CONCELLO))
lug_fisterra <- lugares %>% filter(grepl(paste(fisterra, collapse="|"), CONCELLO))
lug_muros <- lugares %>% filter(grepl(paste(muros, collapse="|"), CONCELLO))
lug_noia <- lugares %>% filter(grepl(paste(noia, collapse="|"), CONCELLO))
lug_ordes <- lugares %>% filter(grepl(paste(ordes, collapse="|"), CONCELLO))
lug_santiago <- lugares %>% filter(grepl(paste(santiago, collapse="|"), CONCELLO))
lug_soneira <- lugares %>% filter(grepl(paste(soneira, collapse="|"), CONCELLO))
lug_xallas <- lugares %>% filter(grepl(paste(xallas, collapse="|"), CONCELLO))

NOR_Sant_lugares <- bind_rows(lug_barcala, lug_bergantinhos, lug_corunha, lug_fisterra, lug_muros, lug_noia, lug_ordes, lug_santiago, lug_soneira, lug_xallas)


# Mapas de prova
#par(mar = c(0, 0, 0, 0))
#plot(st_geometry(bergantinhos_area), col = "green", bg = "white", lwd = 0.25, border = 0)

#plot(st_geometry(bergantinhos_area), col="red") # comarcas  # outro modo

#plot(st_geometry(lug_bergantinhos), col="blue", add = TRUE) #lugares de Bergantinhos sobre o mapa

#plot(st_geometry(xallas_area), col="yellow", add = TRUE) # adicionamos Xallas ao mapa

#plot(st_geometry(lug_xallas), col="blue", add = TRUE) # adicionamos lugares de Xallas ao mapa

#plot(st_geometry(soneira_area), col="brown", add = TRUE) # adicionamos Soneira ao mapa

#plot(st_geometry(lug_soneira), col="blue", add = TRUE) # adicionamos lugares de Soneira ao mapa

#plot(st_geometry(barcala_area), col="magenta", add = TRUE) # adicionamos A Barcala ao mapa

#plot(st_geometry(lug_barcala), col="blue", add = TRUE) # adicionamos lugares da Barcala ao mapa

# Mapa do conjunto de comarcas a estudar



plot(st_geometry(NOR_Sant_area), col="white") # Desenhamos a área

plot(st_geometry(NOR_Sant_lugares), col="red") # Desenhamos lugares 


# DATA PROCESSING


lugares <- NOR_Sant_lugares    #Renomeamos por comodidade a data.frame cos lugares das comarcas objeto de estudo

lugares <- arrange(lugares, Etiqueta)   #Reordenamos pelo nome sem o artigo


# DATA SEARCH

# -iz e -is
lugares_iz <- lugares[grep("iz$", lugares$Etiqueta), ]
lugares_is_atono <- lugares[grep("is$", lugares$Etiqueta), ]
lugares_is <- lugares[grep("ís$", lugares$Etiqueta), ]

par(mar = c(0, 0, 0, 0))
plot(st_geometry(NOR_Sant_area), col="white") # Mapa do conxunto
plot(st_geometry(lugares_is), col="blue", add = TRUE) # 
plot(st_geometry(lugares_iz), col="brown", add = TRUE) # 


#Na Galiza

lugares_mir1 <- lugares1[grep("mir$", lugares1$Etiqueta), ]
lugares_mil1 <- lugares1[grep("mil$", lugares1$Etiqueta), ]

#Mapa na Galiza
par(mar = c(0, 0, 0, 0))
plot(st_geometry(comarcas_lindes), col = "blue", bg = "white", lwd = 0.25, border = 0, axes=TRUE)
plot(st_geometry(lugares_mir1), col="red", pch=17, add = TRUE) # 
plot(st_geometry(lugares_mil1), col="black", pch=16, add = TRUE) #
legend("topleft", legend = c("-mir", "-mil"), col = c("red", "black"), pch = c(17,16), title = "Topónimos em -mir e -mil", bty="n")

#text(st_coordinates(lugares_mir1), labels = lugares_mir1$Etiqueta, pos = 4, cex = 0.8)


# -mir e -mil na área NO

lugares_mir <- lugares[grep("mir$", lugares$Etiqueta), ]
lugares_mil <- lugares[grep("mil$", lugares$Etiqueta), ]

plot(st_geometry(NOR_Sant_area), col="white") # Mapa do conxunto
plot(st_geometry(lugares_mir), col="red", pch=17, add = TRUE) # 
plot(st_geometry(lugares_mil), col="black", pch=16, add = TRUE) #
#text(st_coordinates(lugares_mir), labels = lugares_mir$Etiqueta, col="red", pos = 4, cex = 0.8)
text(st_coordinates(lugares_mil), labels = lugares_mil$Etiqueta, pos = 4, cex = 0.8, bty="n")
legend("topleft", legend = c("-mir", "-mil"), col = c("red", "black"), pch = c(17,16), title = "Topónimos em -mir e -mil", bty="n")


for (i in 1:nrow(lugares_mir)) {
  cat(i, lugares_mir$Etiqueta[i], "(", lugares_mir$ENTIDAD_CO[i], ")\n") 
}

for (i in 1:nrow(lugares_mil)) {
  cat(i, lugares_mil$Etiqueta[i], "(", lugares_mil$ENTIDAD_CO[i], ")\n") 
}



# Seleciono só Bergantinhos e A Corunha
berg_crunha_area <- bind_rows(bergantinhos_area, corunha_area)
berg_crunha_lugares <- bind_rows(lug_bergantinhos, lug_corunha)
lugares_mir <- berg_crunha_lugares[grep("mir$", berg_crunha_lugares$Etiqueta), ]
lugares_mil <- berg_crunha_lugares[grep("mil$", berg_crunha_lugares$Etiqueta), ]

plot(st_geometry(berg_crunha_area), col="white") # Mapa do conxunto
plot(st_geometry(lugares_mir), col="red", pch=17, add = TRUE) # 
plot(st_geometry(lugares_mil), col="black", pch=16, add = TRUE) #
text(st_coordinates(lugares_mir), labels = lugares_mir$Etiqueta, col="red", pos = 4, cex = 0.8)
text(st_coordinates(lugares_mil), labels = lugares_mil$Etiqueta, pos = 4, cex = 0.8)

legend("bottomright", legend = c("-mir", "-mil"), col = c("red", "black"), pch = c(17,16), title = "Topónimos em -mir e -mil")



# -ufe
lugares_ufe <- lugares[grep("ufe$", lugares$Etiqueta), ]
lugares_ulfe <- lugares[grep("ulfe$", lugares$Etiqueta), ]
lugares_ofe <- lugares[grep("ofe$", lugares$Etiqueta), ]
lugares_ofre <- lugares[grep("ofre$", lugares$Etiqueta), ]
lugares_olfe <- lugares[grep("olfe$", lugares$Etiqueta), ]
lugares_olfre <- lugares[grep("olfre$", lugares$Etiqueta), ]
lugares_ufre <- lugares[grep("ufre$", lugares$Etiqueta), ]


plot(st_geometry(NOR_Sant_area), col="white") # Mapa do conxunto
plot(st_geometry(lugares_ufe), col="red", add = TRUE) # 
plot(st_geometry(lugares_ulfe), col="black", add = TRUE) #
text(st_coordinates(lugares_ufe), labels = lugares_ufe$Etiqueta, pos = 4, cex = 0.8)
text(st_coordinates(lugares_ulfe), labels = lugares_ulfe$Etiqueta, pos = 4, cex = 0.8)



# -mar -tar - zar -sar

lugares_ar <- lugares[grep("(mar|tar|sar|zar)$", lugares$Etiqueta), ]

# gun- gon-

lugares_gun <- lugares[grep("(gun|gon)", lugares$Etiqueta), ]
lugares_ufe_any <- lugares[grep("(ufe|ulfe|ofe|ufre|ofre|orfe|urfe)", lugares$Etiqueta), ]

#Galiza

# -avia -ave

lugares_avia <- lugares1[grep("(avia|abea|abia|avea)$", lugares$Etiqueta), ]
lugares_ave <- lugares1[grep("(ave|abe)$", lugares$Etiqueta), ]

par(mar = c(0, 0, 0, 0))
plot(st_geometry(NOR_Sant_area), col="white") # Mapa do conxunto
plot(st_geometry(lugares_ave), col="red", add = TRUE) # 
plot(st_geometry(lugares_avia), col="black", add = TRUE) #


