#' Create a grid with CSquare notation to aggregate spatial data in Spatial Hub metadata
#'
#' Create a spatial grid with a given cell resolution and with a related Csquare geocode for each of the grid cells
#' The Csquare geocoding allows to have a unique identifier for each of the locations. The grid is created in a unprojected coordinate system ( WGS1984 - EPSG: 4326 )
#'
#'
#' @param spatial_layer Spatial dataset in SF format that is intended to be gridded using C-Squares
#' @param cell_size longitude of the location
#' @param degrees  size of the C-Square cell in decimal degrees . Default value is 0.05
#' @return A spatial grid for a required extension and with a Csquare label for each grid cell
#'
#' @examples
#'
#' token_string = getCsquareGrid (spatial_layer  , cell_size =0.05)
#'
#'
#'
#' @export getCsquareGrid




getCsquareGrid = function ( spatial_layer,  cell_size = 0.05, projection = 4326 ) {

    ## Get the layer bounding box

    bbox = spatial_layer |> sf::st_bbox()  |>  sf::st_as_sfc()  |>
          sf::st_sf( id  = 1, label = 'bbox' )  |>
          sf::st_transform(4326)



    ## Create the grid and assign the CSquare labels to each cell

    offset = sf::st_coordinates(bbox)  |>  as.data.frame()  |>  dplyr::summarise ( x = round(min(X),0), y = round(min( Y),0) )

    gridp = sf::st_make_grid(bbox, cellsize = 0.05, crs = 4326  ,
                         offset =  c(offset$x  , offset$y   ) )
    gridp = sf::st_sf(  gridp  ) |> dplyr::rename(geom = gridp)

    centroid_coordinates = gridp |> sf::st_centroid() |> sf::st_coordinates()  |>  as.data.frame()
    csquare_label = getCsquareCode(  lon = centroid_coordinates$X, lat = centroid_coordinates$Y, degrees = 0.05)

    csquare_grid  =   dplyr::bind_cols(gridp, centroid_coordinates, csquare_label)|> dplyr::rename(lon = X, lat = Y, csquare = 3)

    csquare_grid =  csquare_grid |>
                    st_transform(projection) |>
                    mutate ( area_kmsq = units::set_units( st_area(geom) , "km^2")  ) |>
                    st_transform(4326)

    return (csquare_grid)

}



## Definition of the CSquare function taken from VMSTools
