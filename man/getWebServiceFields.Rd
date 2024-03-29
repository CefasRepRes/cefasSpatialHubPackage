% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getWebServiceFields.R
\name{getWebServiceFields}
\alias{getWebServiceFields}
\title{Get the Spatial Hub web services field names}
\usage{
getWebServiceFields(web_service, layer_index, token_str = NULL)
}
\arguments{
\item{web_service}{The URL of the Spatial Hub - ArcGIS Server web service .}

\item{layer_index}{ArcGIS Server API's could include several layers. The index number of the required layer is here provided}

\item{token}{if the api is protected a token must be provided}
}
\value{
The field names list and specification in a dataframe format
}
\description{
Get Spatial Hub web services API's field names list . this function is auxiliary to the getWebServiceData function to support the construction of the WHERE SQL clause or
what list of field request to be extracted
}
\examples{



getWebServiceFields ( web_service =  "https://giserver.cefas.co.uk/devserver/rest/services/fishing_activity/Landing_composition_statistics_by_species_ICES_rectangles_and_ports_2009_to_2021/MapServer",
                     layer_index = 8 )


}
