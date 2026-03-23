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



# ── BMI display ────────────────────────────────────────────────────────────
output$bmi_display <- renderUI({
  req(input$calculate)
  isolate({
    weight <- as.numeric(input$weight)
    height <- as.numeric(input$height) / 100
    if (is.na(weight) || is.na(height) || weight <= 0 || height <= 0) {
      return(div(class = "dc-placeholder", "Enter weight and height above and click Submit."))
    }
    bmi <- weight / (height ^ 2)
    category <- if (bmi < 18.5) "Underweight" else if (bmi < 25.0) "Normal weight" else if (bmi < 30.0) "Overweight" else "Obese"
    div(class = "dc-bmi-row",
        div(class = "dc-bmi-value", round(bmi, 1)),
        div(class = "dc-bmi-category", category)
    )
  })
})

# ── Health summary table ───────────────────────────────────────────────────
output$health_summary_styled <- renderUI({
  req(input$calculate)
  isolate({
    rows <- list(
      c("Age",                  if (!is.na(input$age))    paste(input$age, "years") else "—"),
      c("Menstrual Regularity", if (input$menstrual != "") input$menstrual  else "—"),
      c("Acne Severity",        if (input$acne      != "") input$acne       else "—"),
      c("Stress Level",         if (input$stress    != "") input$stress     else "—"),
      c("Fertility Concern",    if (input$fertility != "") input$fertility  else "—"),
      c("Insulin Resistance",   if (input$insulin   != "") input$insulin    else "—")
    )
    tags$table(class = "dc-table",
               tags$thead(tags$tr(tags$th("Factor"), tags$th("Your Response"))),
               tags$tbody(lapply(rows, function(r) tags$tr(tags$td(r[1]), tags$td(r[2]))))
    )
  })
})

# ── Data conclusions ───────────────────────────────────────────────────────
output$data_conclusions <- renderUI({
  req(input$calculate)
  isolate({
    req(input$weight, input$height, input$acne, input$age,
        input$menstrual, input$stress, input$fertility, input$insulin)
    
    weight <- as.numeric(input$weight)
    height <- as.numeric(input$height) / 100
    if (is.na(weight) || is.na(height) || weight <= 0 || height <= 0) return(NULL)
    
    bmi     <- weight / (height ^ 2)
    bmi_cat <- if (bmi < 18.5) "Underweight" else if (bmi < 25.0) "Normal" else if (bmi < 30.0) "Overweight" else "Obese"
    age       <- as.numeric(input$age)
    menstrual <- input$menstrual
    acne      <- input$acne
    stress    <- input$stress
    fertility <- input$fertility
    insulin   <- input$insulin
    
    # styled warning banner (replaces plain yellow div)
    warning_banner <- div(class = "dc-warning",
                          tags$strong("Remember: "),
                          "PCOS is undiagnosed in almost 70% of women. These findings are informational only — please consult a healthcare professional for a proper diagnosis."
    )
    
    all_clear <- (bmi_cat %in% c("Normal", "Underweight")) &&
      (menstrual == "Regular") &&
      (acne %in% c("None", "Mild")) &&
      (stress == "Low") &&
      (fertility == "No") &&
      (insulin == "No")
    
    if (all_clear) {
      return(tagList(
        div(class = "dc-note",
            "Your profile does not show strong PCOS risk indicators — that's great news. However, up to 70% of cases go undiagnosed. A clinical evaluation is the only way to know for sure."
        ),
        warning_banner
      ))
    }
    
    items <- list()
    
    if (!is.na(age) && age >= 15 && age <= 16)
      items[[length(items) + 1]] <- tags$li(
        tags$b("Age (15–16): "),
        "Research shows adolescents with higher free androgen index at ages 15–16 are more likely to develop PCOS by age 26. Early awareness and monitoring matters."
      )
    
    if (bmi_cat %in% c("Overweight", "Obese"))
      items[[length(items) + 1]] <- tags$li(
        tags$b(paste0("BMI — ", bmi_cat, ": ")),
        "Roughly 50–70% of women with PCOS are overweight or obese. Excess weight worsens insulin resistance and raises androgen levels, creating a cycle that can hinder ovulation.",
        tags$sup(tags$a(href = "https://www.sciencedirect.com/science/article/abs/pii/S0026049518302336", target = "_blank", "[source]"))
      )
    
    if (menstrual == "Irregular")
      items[[length(items) + 1]] <- tags$li(
        tags$b("Menstrual Regularity — Irregular: "),
        "Approximately 75–85% of women with PCOS experience menstrual dysfunction. Irregular or long cycles are one of the most effective early indicators of a PCOS phenotype.",
        tags$sup(tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC5542050/", target = "_blank", "[source]"))
      )
    
    if (acne %in% c("Moderate", "Severe"))
      items[[length(items) + 1]] <- tags$li(
        tags$b(paste0("Acne Severity — ", acne, ": ")),
        "PCOS raises androgen levels (hyperandrogenism), which worsens acne. Moderate to severe acne in adult women can signal underlying hormonal imbalance linked to PCOS.",
        tags$sup(tags$a(href = "https://health.clevelandclinic.org/pcos-acne", target = "_blank", "[source]"))
      )
    else if (acne == "Mild")
      items[[length(items) + 1]] <- tags$li(
        tags$b("Acne Severity — Mild: "),
        "Even mild hormonally-driven acne can be an early signal of elevated androgens associated with PCOS.",
        tags$sup(tags$a(href = "https://health.clevelandclinic.org/pcos-acne", target = "_blank", "[source]"))
      )
    
    if (stress %in% c("Medium", "High"))
      items[[length(items) + 1]] <- tags$li(
        tags$b(paste0("Stress Level — ", stress, ": ")),
        "Women with PCOS show higher stress markers — including elevated cortisol and heart rate — compared to healthy controls. Stress may actively trigger or worsen PCOS symptoms.",
        tags$sup(tags$a(href = "https://pmc.ncbi.nlm.nih.gov/articles/PMC5892097/", target = "_blank", "[source]"))
      )
    
    if (fertility == "Yes")
      items[[length(items) + 1]] <- tags$li(
        tags$b("Fertility Concern — Yes: "),
        "Around 70% of women with PCOS experience infertility, making it one of the most common causes of hormonal infertility. Speaking with a specialist early is important.",
        tags$sup(tags$a(href = "https://www.ncbi.nlm.nih.gov/books/NBK459251/", target = "_blank", "[source]"))
      )
    
    if (insulin == "Yes")
      items[[length(items) + 1]] <- tags$li(
        tags$b("Insulin Resistance — Yes: "),
        "About 50% of women with PCOS have an abnormal degree of insulin resistance, independent of obesity. It raises androgen production, disrupts ovulation, and worsens symptoms.",
        tags$sup(tags$a(href = "https://www.sciencedirect.com/science/article/abs/pii/S0026049518302336", target = "_blank", "[source]"))
      )
    
    if (length(items) == 0) {
      return(tagList(
        div(class = "dc-note",
            "Your profile does not show strong PCOS risk indicators. A clinical evaluation is still the only way to know for sure."
        ),
        warning_banner
      ))
    }
    
    tagList(
      div(class = "dc-note",
          "Based on your responses, here is what the data and research say about your profile:"
      ),
      tags$ul(class = "dc-conclusions-list", items),
      warning_banner
    )
  })
})
}
