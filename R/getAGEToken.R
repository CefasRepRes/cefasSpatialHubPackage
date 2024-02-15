#' Get a security token to use to VIEW data in Spatial Hub - ArcGIS Enterprise - Portal
#'
#' Get a security token to access to restricted content in Cefas ArcGIS Enterprise .The token has to be used within the getWebServiceData function
#' The token can be used to access to secure resources that are needed for R and Python analyst to access to data
#'
#'
#'
#' @return The token string to be used in getWebServiceData
#'
#' @examples
#'
#' token_string = getAGEToken ()
#'
#' getWebServiceData ( web_service=  "https://giserver.cefas.co.uk/devserver/rest/services/fishing_activity/Landing_composition_statistics_by_species_ICES_rectangles_and_ports_2009_to_2021/MapServer",
#'                    layer_index = 8,
#'                    where_clause = "ft_lyear = 2021 AND le_spe = 'COD'",
#'                    output_fields = "*",
#'                    spatial_layer = TRUE ,
#'                    token_str = token_string )
#'
#'
#' @export getAGEToken




getAGEToken = function ( ) {

  portalUrl = "https://giserver.cefas.co.uk/portal"

  request_body = list(  username =  "spatial.hub_data_analyst",                                    ## specify conditions of teh data to be extracted
                        password = "D@t@Ana!yst!1234",                                ## specify a list of columns to be return or all "*"
                        client=  'referer', #'requestip',#'referer' ,
                        referer = portalUrl,
                        expiration=60 ,
                        f = 'pjson'
  )



  request_body = list(  username =  "spatial.hub_data_analyst",                                    ## specify conditions of teh data to be extracted
                        password = "D@t@Ana!yst!1234",                                ## specify a list of columns to be return or all "*"
                        client=  'referer', #'requestip',#'referer' ,
                        referer = portalUrl,
                        expiration=60 ,
                        f = 'pjson'
  )




  result_post = httr::POST(url  = "https://giserver.cefas.co.uk/portal/sharing/rest/generateToken/",
                           body = request_body,
                           headers = c('content-type' = 'application/x-www-form-urlencoded')
                           )

  print(httr::content(result_post)[[1]])
  result_text = httr::content(result_post,  as="text")
  result =  jsonlite::fromJSON (result_text)


  return ( list (result_post,  result_text, result$token ) )

}




