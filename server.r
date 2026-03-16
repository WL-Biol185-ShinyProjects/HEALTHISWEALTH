server <- function(input, output) {
  
  library(tidyverse)
  library(leaflet)
  library(sf)
  library(rnaturalearth)
  library(countrycode)
  
  pcos <- read.csv("pcos.csv", stringsAsFactors = FALSE, check.names = FALSE)
  
  colnames(pcos) <- c(
    "country", "cases_1990", "incidence_1990",
    "cases_2021", "incidence_2021", "aapc", "p_value"
  )
  
  pcos$country        <- trimws(gsub("\\s+", " ", gsub("[\n\r]", " ", pcos$country)))
  pcos$cases_1990     <- as.numeric(gsub(",", "", pcos$cases_1990))
  pcos$incidence_1990 <- as.numeric(pcos$incidence_1990)
  pcos$cases_2021     <- as.numeric(gsub(",", "", pcos$cases_2021))
  pcos$incidence_2021 <- as.numeric(pcos$incidence_2021)
  pcos$iso3           <- countrycode(pcos$country, origin = "country.name", destination = "iso3c")
  
  world <- ne_countries(scale = "medium", returnclass = "sf")
  map_data_joined <- world %>%
    left_join(pcos, by = c("iso_a3" = "iso3"))
  
  output$pcosMap <- renderLeaflet({
    
    pal <- colorNumeric(
      palette  = c("#FFB6C1","#DC5987","#C13450","#870009"),
      domain   = map_data_joined$incidence_2021,
      na.color = "white"
    )
    
    labels <- sprintf(
      "<strong>%s</strong><br/>Incidence (2021): %s per 100,000<br/>Cases (2021): %s",
      map_data_joined$name,
      ifelse(is.na(map_data_joined$incidence_2021), "No data",
             round(map_data_joined$incidence_2021, 2)),
      ifelse(is.na(map_data_joined$cases_2021), "No data",
             formatC(map_data_joined$cases_2021, format = "d", big.mark = ","))
    ) %>% lapply(htmltools::HTML)
    
    leaflet(map_data_joined,
            options = leafletOptions(minZoom = 2)) %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels,
                       options = providerTileOptions(opacity = 0)) %>%
      addPolygons(
        fillColor    = ~pal(incidence_2021),
        fillOpacity  = 0.8,
        color        = "white",
        weight       = 0.5,
        smoothFactor = 0.5,
        highlight    = highlightOptions(
          weight      = 2,
          color       = "#e63985",       # matches app accent colour
          fillOpacity = 0.95,
          bringToFront = TRUE
        ),
        label        = labels,
        labelOptions = labelOptions(
          style     = list("font-weight" = "normal", padding = "4px 8px"),
          textsize  = "13px",
          direction = "auto"
        )
      ) %>%
      addLegend(
        pal      = pal,
        values   = ~incidence_2021, 
        opacity  = 0.85,
        title    = "Incidence<br/>per 100,000",
        position = "bottomright",
        na.label = "No data"
      ) %>%
      setView(lng = 10, lat = 20, zoom = 2)
  })

output$pcosMap1990 <- renderLeaflet({
  
  pal <- colorNumeric(
    palette  = c("#FFB6C1","#DC5987","#C13450","#870009"),
    domain   = map_data_joined$incidence_1990,
    na.color = "white"
  )
  
  labels <- sprintf(
    "<strong>%s</strong><br/>Incidence (1990): %s per 100,000<br/>Cases (1990): %s",
    map_data_joined$name,
    ifelse(is.na(map_data_joined$incidence_1990), "No data",
           round(map_data_joined$incidence_1990, 2)),
    ifelse(is.na(map_data_joined$cases_1990), "No data",
           formatC(map_data_joined$cases_1990, format = "d", big.mark = ","))
  ) %>% lapply(htmltools::HTML)
  
  leaflet(map_data_joined,
          options = leafletOptions(minZoom = 2)) %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels,
                     options = providerTileOptions(opacity = 0)) %>%
    addPolygons(
      fillColor    = ~pal(incidence_1990),
      fillOpacity  = 0.8,
      color        = "white",
      weight       = 0.5,
      smoothFactor = 0.5,
      highlight    = highlightOptions(
        weight      = 2,
        color       = "#e63985",       # matches app accent colour
        fillOpacity = 0.95,
        bringToFront = TRUE
      ),
      label        = labels,
      labelOptions = labelOptions(
        style     = list("font-weight" = "normal", padding = "4px 8px"),
        textsize  = "13px",
        direction = "auto"
      )
    ) %>%
    addLegend(
      pal      = pal,
      values   = ~incidence_1990, 
      opacity  = 0.85,
      title    = "Incidence<br/>per 100,000",
      position = "bottomright",
      na.label = "No data"
    ) %>%
    setView(lng = 10, lat = 20, zoom = 2)
})
}
