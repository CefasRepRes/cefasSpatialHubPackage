

library(cefasSpatialHub)
library(tidyverse)
library(httr)

getAGEToken = function ( ) {


request_body = list(  username =  "spatial.hub_data_analyst",                                    ## specify conditions of teh data to be extracted
                      password = "D@t@Ana!yst!1234",                                ## specify a list of columns to be return or all "*"
                      client= 'requestip' ,
                      expiration=60 ,
                      f = 'pjson'
)


result = POST(url  = "https://giserver.cefas.co.uk/portal/sharing/rest/generateToken/",
               body = request_body ) %>% content( as="text") %>% fromJSON ()


return ( result$token )

}





