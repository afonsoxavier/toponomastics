# toponomastics
Functions and scripts to research geographic data for the study of names

**visor_toponomastics_main.R** replaces visor_toponomastics_functions.R. 
Functions are now in independent files: load_data_gz.R to load data for a specific area, map_functions.R for maps, report_functions.R for reports and search_functions.R for searches.

Requires:
*dplyr* for easier dataframe manipulation and *sf* for shape files

**Description of visor_toponomastics_main.R**

DATA LOAD

Databases are now loaded automatically from the script (zip files unzipped and stored on user's folder). Uncomment the load line to activate this function.


DATA SELECTION

Selects dataframes that are relevant for toponymic research from the data loaded


DATA CLEANING

Groups the data from shapefiles in a dataframe and processes the most relevant variables to create columns that contain the most relevant values

FUNCTIONS 

*load_data_gz*
Downloads data for the examples. Uncomment the line in load_data_gz.R to download the files and create the folders. Comment again to avoid downloading again.

*read_data_functions*
organizes the databases of the examples for better performance and creates a geographical object for each place name

*data_search*
searches a given theme or toponym. It allows searches for a specific entity type (point or polygon).

*unique_toponym*
processes a given search to avoid reduplication of toponymic expressions when they originally belong to the same place (E.g. a place name of a particular village which is also used to name a whole parish or a municipality).

*barplot_freq* 
plots a bar chart to compare the frequencies of toponyms for a given theme

*map_galiza*
creates a map plotting a given theme with all occurrences found for the area of the data used in the study (Galiza)

*map_galiza2*
creates a map comparing two themes 

*list_toponimos*
creates a list of toponyms for a given theme

*full_report*
searches a theme in the database, creates a list of place-names that contain the them and plots a map with the results. It allows entity_type specification (optional)

EXPLORATORY ANALYSIS

How to use (examples)


**Previous scripts**
*visor_toponomastics.R* (deprecated) visor_toponomastics.R is an initial script for exploratory analysis. It allows searches of place-names for a given dataset (specifications in the script comments) and gives examples of searches, lists and maps. However all the processes and more are contained in the most recent visor_toponmastics_functions.R which improves the code (with specific functions) and all the aspects data processing. Although deprecated, it is left here because it has examples of how to perform searchs and create maps for more specific local areas.

visor_toponomastics_functions.R (deprecated) Updated visor_toponomastics.R. Databases automatically loaded (requires web access) for the given examples. Code is now easier to follow as repetitive processes are now functions. New script that includes all the processes already used in visor_toponomastics.R plus new functions and examples of exploratory analysis of the data. There is now a new script,

