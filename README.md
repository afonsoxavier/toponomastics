# toponomastics
Functions and scripts to research geographic data for the study of names

**FUNCTIONS** 

*load_data_gz*
Downloads data for the examples. Uncomment the line in load_data_gz.R to download the files and create the folders. Comment again to avoid downloading again.

*read_data_visor_gz*
organizes the databases of the examples used in the script for better performance and creates a geographical object for each place name

*data_search*
searches a given theme or toponym. It allows searches for a specific entity type (point or polygon).

*search_comarca*
allows to restrict searches to a given county or counties

*unique_toponym*
processes a given search to avoid reduplication of toponymic expressions when they originally belong to the same place (E.g. a place name of a particular village which is also used to name a whole parish or a municipality).

*map_galiza*
creates a map plotting a given theme with all occurrences found for the area of the data used in the study (Galiza)

*map_galiza2*
creates a map comparing two themes 

*map_gg* & *mapp_gg2*
The same as the previous functions but using ggplot. Still under development. Some examples of its current use can be found in the scprit experiment_maps.R

*barplot_freq* 
plots a bar chart to compare the frequencies of toponyms for a given theme

*list_toponimos*
creates a list of toponyms for a given theme

*full_report*
searches a theme in the database, creates a list of place-names that contain the them and plots a map with the results. It allows entity_type specification (optional)


**SCRIPTS**
Requires:
*dplyr* for easier dataframe manipulation, *sf* for shape files, *ggplot2* for graphs and ggrepel to better display placenames in a map



**visor_toponomastics_main.R** 

Structure and how to use (examples)

DATA LOAD

Databases used in the examples can be downloaded automatically from the script (zip files unzipped and stored on user's folder). Uncomment the load line to activate this function.


DATA SELECTION & DATA CLEANING

Next, the script selects dataframes that are relevant for toponymic research from the data loaded and groups the data from shapefiles in a dataframe and processes the most relevant variables to create columns that contain the most relevant values

EXPLORATORY ANALYISIS
The rest of the script shows examples on how to explore themes in the databases


**experiment_maps.R**
Examples for maps

**visor_toponmastics_particular_area**
Examples with area restriction


**Previous scripts**
*visor_toponomastics.R* (deprecated) visor_toponomastics.R was an initial script for exploratory analysis. It allowed searches of place-names for a given dataset (specifications in the script comments) and gave examples of searches, lists and maps. However all the processes and more are contained in the most recent visor_toponmastics_main.R which improves the code (with specific functions) and all the aspects data processing. 

visor_toponomastics_functions.R (deprecated) Updated visor_toponomastics.R. Databases automatically loaded (required web access) for the given examples.

