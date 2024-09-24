# toponomastics
A script to research geographic data for the study of names

visor_toponomastics.R 
visotr_toponomastics.R is an initial script for exploratory analysis. It allows searches of place-names for a given dataset (specifications in the script comments) and gives examples of searches, lists and maps. However all the processes and more are contained in the most recent visor_toponmastics_functions.R which improves the code (with specific functions) and all the aspects data processing. Although deprecated, it is left here because it has examples of how to perform searchs and create maps for more specific local areas.

visor_toponomastics_functions.R
Updates visotr_toponomastics.R. Data is now automatically downloaded (requires web access) for the given example. Code is now easier to follow as repetitive processes are now functions. 
New script that includes all the processes already used in visor_toponomastics.R plus new functions and examples of exploratory analysis of the data. 

Requires: dplyr for easier dataframe manipulation and sf for shape files

Description of the script:

DATA LOAD
The data is now loaded automatically from the script (zip files unzipped and stored on user's folder)

DATA SELECTION
Selects the dataframes that are relevant for toponymic research from the data loaded

DATA CLEANING
Groups the data from shapefiles in a dataframe and processes the most relevant variables to create columns that contain the most relevant values

FUNCTIONS 
data_search
Searches a given theme or toponym. It allows searches for a specific entity type (point or polygon).

unique_toponym
Processes a given search to avoid reduplication of toponymic expressions when they originally belong to the same place (E.g. a place name of a particular village which is also used to name a whole parish or a municipality).

map_galiza
creates a map plotting a given theme with all occurrences found for the area of the data used in the study (Galiza)

map_galiza2
creates a map comparing two themes 

list_toponimos
creates a list of toponyms for a given theme

full_report
Searches a theme in the database, creates a list of place-names that contain the them and plots a map with the results. It allows entity_type specification (optional)

DATA SELECTION

How to use the functions (examples)

