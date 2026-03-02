library(shiny)
library(bslib)

server <- function(input, output) {
  
  library(tidyverse)
  library(viridis)
  library(sf)
  library(rnaturalearth)
  library(countrycode)
  
  pcos <- read.csv("pcos.csv", stringsAsFactors = FALSE, check.names = FALSE)
  
  colnames(pcos) <- c(
    "country",
    "cases_1990",
    "incidence_1990",
    "cases_2021",
    "incidence_2021",
    "aapc",
    "p_value"
  )
  
  pcos$country <- gsub("[\n\r]", " ", pcos$country)
  pcos$country <- gsub("\\s+", " ", pcos$country)
  pcos$country <- trimws(pcos$country)
  
  pcos$cases_2021 <- as.numeric(gsub(",", "", pcos$cases_2021))
  pcos$incidence_2021 <- as.numeric(pcos$incidence_2021)
  
  pcos$iso3 <- countrycode(
    pcos$country,
    origin = "country.name",
    destination = "iso3c"
  )
  
  world <- ne_countries(scale = "medium", returnclass = "sf")
  
  map_data_joined <- world %>%
    left_join(pcos, by = c("iso_a3" = "iso3"))

  output$pcosMap <- renderPlot({
    
    ggplot(map_data_joined) +
      geom_sf(aes(fill = incidence_2021), color = "white", size = 0.1) +
      scale_fill_gradientn(
        colours = c("#2C7BB6", "#FFFFBF", "#FDAE61", "#D7191C"),
        na.value = "grey85",
        name = "Incidence\nper 100,000"
      ) +
      labs(
        title = "Global PCOS Incidence (2021)",
        subtitle = "Country-wise Heat Map",
        caption = "Source: PCOS Dataset"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 14, hjust = 0.5),
        legend.position = "right",
        axis.text = element_blank(),
        axis.ticks = element_blank()
      )
  })
  
}
