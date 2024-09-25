
# DATA LOAD


# Lemos os dados e fazemos a primeira análise exploratória em forma de mapas
#Os dados estão trazidos de https://mapas.xunta.gal/visores/pba/
# Para baixá-los ir a ´Selección de Capas' e escolher no menu
#Selecionar MODELO DE ASENTAMENTO > Asentamentos PBA-PBU para os dados
# ou ir diretamente a
# https://visorgis.cmati.xunta.es/cdix/descargas/PlanBasicoAutonomico/2024_06/capas/AsentamentosPBA_PU.zip'
# Último acesso a 23/09/2024


# Localidades

url <- "https://visorgis.cmati.xunta.es/cdix/descargas/PlanBasicoAutonomico/2024_06/capas/AsentamentosPBA_PU.zip"
destfile <- "galiza_shape_file.zip"
download.file(url, destfile)
unzip(destfile, exdir = "galiza_shape_file")


# Concellos  Selecionar Limites administrativos > Concellos

url <- "https://visorgis.cmati.xunta.es/cdix/descargas/visor_basico/Concellos_IGN.zip"
destfile <-"Concellos_IGN.zip"
download.file(url, destfile)
unzip(destfile, exdir = "Concellos_IGN")


# Comarcas  Selecionar Limites administrativos > Comarcas  (como escolher no PBA)
url <- "https://visorgis.cmati.xunta.es/cdix/descargas/visor_basico/Comarcas.zip"
destfile <-"Comarcas.zip"
download.file(url, destfile)
unzip(destfile, exdir = "Comarcas")


# Freguesias

url <- "https://visorgis.cmati.xunta.es/cdix/descargas/visor_basico/Parroquias.zip"
destfile <-"Parroquias.zip"
download.file(url, destfile)
unzip(destfile, exdir = "Parroquias")
