#' Get the Spatial Hub web services data into R objetcs
#'
#' Get Spatial Hub web services API's into R objects. The function allows to access the data as a R Data Frame or spatial SF object
#' The Spatial Hub - ArcGIS Portal API's allows  the use of SQL query to extract only the required data
#'
#'
#' @param web_service The URL of the Spatial Hub - ArcGIS Server web service .
#' @param layer_index ArcGIS Server API's could include several layers. The index number of the required layer is here provided
#' @param where_clause A SQL format WHERE clause. The SQL condition filters the data to be extracted. To extract all the data use "1=1" string
#' \itemize{
#'   \item Extract all data  - where_clause = "1=1"
#'   \item Filter data using SQL query - where_clause = "le_spe = 'COD' AND ft_lyear = 2021"
#' }
#' @param output_fields An array with the list of the fields that are required with the output
#' @param n_records A number with the number of records to be returned
#' @param dist_values TRUE/FALSE to fetch unique values for the fields reuested
#' @param spatial_layer A TRUE / FALSE parameter to return the output data in  R SF spatial format  or as a R Data Frame format
#' @param token if the api is protected a token must be provided
#' @param return_api = FALSE. TRUE if instead of the data you want to get the API URL
#'
#' @return The data extracted as a Data Frame or Spatial SF format
#'
#' @examples
#'
#'
#' getWebServiceData ( web_service=  "https://giserver.cefas.co.uk/devserver/rest/services/fishing_activity/Landing_composition_statistics_by_species_ICES_rectangles_and_ports_2009_to_2021/MapServer",
#'                    layer_index = 8,
#'                    where_clause = "ft_lyear = 2021 AND le_spe = 'COD'",
#'                    output_fields = "*",
#'                    spatial_layer = TRUE )
#'
#'
#' @export getWebServiceData


getWebServiceData = function ( web_service, layer_index , where_clause = "1=1", output_fields = "*", n_records = NULL, dist_values = FALSE,  spatial_layer = TRUE  , token_str = NULL, return_api = FALSE) {



  ## 1. GET THE URL OF THE WEB SPATIAL LAYER API . Must include API and the layer index within the web service  ( url API + index number example below)

  ## 1.1 Information available in the Spatial Portal item

  webservice_api = web_service
  webservice_layer_index = layer_index

  ## 1.2 Build API the URL

  webservice_api        =  paste(webservice_api, webservice_layer_index , sep = '/')
  webservice_base       =  httr::parse_url(webservice_api )
  webservice_base$path  =  paste(webservice_base$path ,  'query', sep = '/' )



  ## 2. Define the QUERY conditions and OUTPUT format in JSON. No GEOMETRY required , otherwise look to alternative method.



  if (spatial_layer == TRUE)  { return_geom = 'true'; format_out = 'geojson'   }  else  {  return_geom = 'false'; format_out = 'json' }

  ## 2.2 Pass the criteria for the query:

  webservice_base$query = list(  where =  where_clause,                                    ## specify conditions of teh data to be extracted
                                 outFields = output_fields,                                ## specify a list of columns to be return or all "*"
                                 resultRecordCount= n_records ,
                                 returnDistinctValues= dist_values ,
                                 returnGeometry = return_geom,                             ## specify if the geometry column is required
                                 f = format_out ,                                          ## specify the OUTPUT FORMAT
                                 token = token_str
                                 )

  ## 2.3 Finally, build the query with all parameters



  web_service_request = httr::build_url(webservice_base)


  if ( return_api == TRUE ) {


    output_data  = web_service_request

  } else {

      if (spatial_layer == T ) {



        ### Read the API URL using SF function 'st_read'

        wsr = readLines ( web_service_request  , warn=FALSE)

        output_data = sf::st_read(wsr, quiet = T)




      } else if ( spatial_layer == F) {


        ### Read the API URL using JSONLITE function and convert into a dataframe

        data_json =  jsonlite::fromJSON(web_service_request , simplifyDataFrame = T, flatten = T)

        output_data  = data_json$features
        colnames ( output_data)  = data_json$fields["name"]$name


        ## Check the data frame has been correctly created
      }
  }

  return(output_data)

}

