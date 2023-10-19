## Title: R Package with functionalities to access and analyse spatial data in Cefas Spatial Hub 
### Author: Roi Martinez
#### Version: 0.1.0
 
Description: 

R Package with functionalities to access and analyse spatial data in Cefas Spatial Hub. The package include funcitons for: 
    - Access to Spatial Hub web services from R 
    - The Spatial Hub web service are accesible as spatial objects or R Data Frame
    - Use the Spatial Hub web service API to run some analysis on the Sptial Hub servers side ( enhance speed perfomance)
 
Imports: httr, jsonlite, sf


## HOW TO USE IT:

Install the package form Github and load the library 

```r

library (devtools)
install_github("CefasRepRes/cefasSpatialHubPackage")

library (cefasSpatialHub)

```

### Examples: 

Get data form Spatial Hub Web Service and plot a map


```r

landings_map =     getWebServiceData ( web_service=  "https://giserver.cefas.co.uk/devserver/rest/services/fishing_activity/Landing_composition_statistics_by_species_ICES_rectangles_and_ports_2009_to_2021/MapServer",
                   layer_index = 8,
                   where_clause = "ft_lyear = 2021 AND le_spe = 'COD'",
                   output_fields = "*",
                   spatial_layer = TRUE )


landings_map %>% slice ( 1:100 ) %>% ggplot ( aes( fill = total_tons, color = total_tons) ) + geom_sf ( )

```

### Explore functions documentation : 

```r
?getWebServicesData
?getWebServicesFields


```
