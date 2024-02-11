library(shiny)
library(leaflet)

library(raster)

library(rgdal)

ui <- fluidPage(
  absolutePanel(
    top = 100, left = 100, right = 50,
    fixed = TRUE,
    img(src="giphy.gif", height = 100, width = 100)
  ),
  
  leafletOutput("mymap", height = "1000px", width = "100%")
)

server <- function(input, output, session) {
 
#  states <- readOGR("shapefile/mangrove.shp",
#                    layer = "mangrove")
  r <- raster("imap2011r180.tif")
  rmangrove <- raster("mangrove_raster.tif")
  

  pal <- colorBin("yellow", domain = NULL, bins = 9, na.color = "transparent")
  cols = colorBin("Greens", domain = NULL, bins = 9, na.color = "transparent")
  
 
  output$mymap <- renderLeaflet({
    leaflet() %>% addTiles(
      urlTemplate = "//server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
      attribution = 'ESRI',
      group = "Satellite",
      options= providerTileOptions( opacity = 1)
      
    ) %>%
      addProviderTiles(providers$OpenStreetMap.DE,options= providerTileOptions( opacity = 1),group = "Street") %>%
      
      addRasterImage(r, colors = cols, opacity = 0.7,layerId = "c2010", group="Tree cover 2011") %>%
      
      addRasterImage(rmangrove, colors = pal, opacity = 0.8,layerId = "c2011", group="Mangrove") %>%
      
      #addPolygons(color = "grey", weight = 2, smoothFactor = 0.5,
      #            opacity = 1.0, fillOpacity = 0.3,
      #            fillColor = "transparent", 
      #            highlightOptions = highlightOptions(color = "yellow", weight = 2,
      #                                            bringToFront = TRUE))%>%
      #addLegend(pal=pal, values=c(1,2), 
      #          labFormat = labelFormat( c("Irrigated crop ","Non irrigate ")) ) %>%
      
      addLayersControl(  baseGroups = c("Satellite","Street"), overlayGroups = c("Tree cover 2011","Mangrove"),
                      options = layersControlOptions( collapsed=FALSE)) #%>%
      
      #hideGroup("Crop2010") %>%

    
    
  })
  
  print("finish loading")
  
  observeEvent(input$mymap_mouseover,{
    print(input$mymap_click)
    
    # print(input$leafmap_draw_deleted_features)
    
  })
  
  
 # print(output$mymap)
}

shinyApp(ui, server)
