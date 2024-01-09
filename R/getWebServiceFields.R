#' Get the Spatial Hub web services field names
#'
#' Get Spatial Hub web services API's field names list . this function is auxiliary to the getWebServiceData function to support the construction of the WHERE SQL clause or
#' what list of field request to be extracted
#'
#'
#' @param web_service The URL of the Spatial Hub - ArcGIS Server web service .
#' @param layer_index ArcGIS Server API's could include several layers. The index number of the required layer is here provided
#'
#' @return The field names list and specification in a dataframe format
#'
#' @examples
#'
#'
#'
#' getWebServiceFields ( web_service =  "https://giserver.cefas.co.uk/devserver/rest/services/fishing_activity/Landing_composition_statistics_by_species_ICES_rectangles_and_ports_2009_to_2021/MapServer",
#'                      layer_index = 8 )
#'
#'
#' @export getWebServiceFields
#'
getWebServiceFields  = function (web_service, layer_index ) {

  ## 1. GET THE URL OF THE WEB SPATIAL LAYER API . Must include API and the layer index within the web service  ( url API + index number example below)

  ## 1.1 Information available in the Spatial Portal item

  webservice_api = web_service
  webservice_layer_index = layer_index

  ## 1.2 Build API the URL

  webservice_api        =  paste(webservice_api, webservice_layer_index , sep = '/')
  webservice_base       =  parse_url(webservice_api )
  webservice_base$path  =  paste(webservice_base$path ,  'query', sep = '/' )


  ## 2.1 GET the list of web service fields to build your query upon :

  jsonlite::fromJSON(  paste0 (webservice_api,'?f=json'), simplifyDataFrame = T, flatten = T)$fields

}
