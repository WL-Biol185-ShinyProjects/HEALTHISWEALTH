library(shiny)
library(leaflet)
library(wordcloud2)
library(tm)
library(RColorBrewer)
library(dplyr)
library(countrycode)
library(rnaturalearth)
library(sf)
library(maps)
library(shinyjs)
library(ggplot2)
library(ggwordcloud)
library(plotly)
library(readxl)

server <- function(input, output, session) {
  
  # ── DATA LOADING ────────────────────────────────────────────────────────────
  
  pcos <- read.csv("pcos.csv", stringsAsFactors = FALSE, check.names = FALSE)
  colnames(pcos) <- c("country","cases_1990","incidence_1990",
                      "cases_2021","incidence_2021","aapc","p_value")
  pcos$country        <- trimws(gsub("\\s+", " ", gsub("[\n\r]", " ", pcos$country)))
  pcos$cases_1990     <- as.numeric(gsub(",", "", pcos$cases_1990))
  pcos$incidence_1990 <- as.numeric(pcos$incidence_1990)
  pcos$cases_2021     <- as.numeric(gsub(",", "", pcos$cases_2021))
  pcos$incidence_2021 <- as.numeric(pcos$incidence_2021)
  pcos$iso3           <- countrycode(pcos$country, origin = "country.name", destination = "iso3c")
  
  world           <- ne_countries(scale = "medium", returnclass = "sf")
  map_data_joined <- world %>% left_join(pcos, by = c("iso_a3" = "iso3"))
  
  state_data <- read.csv("Uterine_corpus_statewise.csv", stringsAsFactors = FALSE, check.names = FALSE)
  colnames(state_data) <- c("state","incidence","mortality_rate","death_estimates","new_cases")
  state_data$state           <- tolower(trimws(state_data$state))
  state_data$incidence       <- as.numeric(state_data$incidence)
  state_data$mortality_rate  <- as.numeric(state_data$mortality_rate)
  state_data$death_estimates <- as.numeric(state_data$death_estimates)
  state_data$new_cases       <- as.numeric(state_data$new_cases)
  state_data$mortality_rate[state_data$state == "kentucky"] <- 8.5
  
  us_states       <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))
  us_states$state <- tolower(us_states$ID)
  map_data_state  <- merge(us_states, state_data, by = "state", all.x = TRUE)
  
  cvd_uc <- read.csv("CVD + UC mortaility data 2019-2023 clean(Sheet1).csv",
                     stringsAsFactors = FALSE, check.names = FALSE)
  cvd_uc <- cvd_uc[, colnames(cvd_uc) != ""]
  
  region_df        <- read.csv("Region.csv", check.names = FALSE)
  region_long      <- tidyr::pivot_longer(region_df, cols = c(`Prev 1990`,`Prev 2021`),
                                          names_to = "Year", values_to = "Prevalence")
  region_long$Year <- ifelse(region_long$Year == "Prev 1990", "1990", "2021")
  region_df$Difference <- region_df$`Prev 2021` - region_df$`Prev 1990`
  
  sdi_df        <- read.csv("SDI.csv", check.names = FALSE)
  sdi_long      <- tidyr::pivot_longer(sdi_df, cols = c(`Prev 1990`,`Prev 2021`),
                                       names_to = "Year", values_to = "Prevalence")
  sdi_long$Year <- ifelse(sdi_long$Year == "Prev 1990", "1990", "2021")
  sdi_df$Difference <- sdi_df$`Prev 2021` - sdi_df$`Prev 1990`
  
  
  # ── WORD CLOUD ──────────────────────────────────────────────────────────────
  
  output$wordcloud <- renderPlot({
    df <- data.frame(
      word = c("PCOS","hormones","insulin","ovaries","fertility","acne","weight",
               "irregular cycles","cysts","androgens","diagnosis","treatment",
               "metformin","lifestyle","stress","fatigue","hair loss","period",
               "estrogen","progesterone","inflammation","glucose","cortisol",
               "ovulation","cycle","ultrasound","symptoms","testosterone",
               "metabolic","obesity","hirsutism","bloating","cramps","mood",
               "anxiety","depression","sleep","diet","exercise","insulin resistance",
               "uterus","endometrium","pelvic","reproductive","imbalance","chronic","syndrome"),
      freq = c(1000,600,580,550,520,400,380,360,340,320,200,190,180,170,160,
               100,95,90,85,80,60,58,56,54,52,50,48,46,44,42,35,34,33,32,31,
               30,29,28,27,26,20,19,18,17,15,14,13)
    )
    ggplot(df, aes(label = word, size = freq, color = freq)) +
      geom_text_wordcloud_area(rm_outside = TRUE, padding = 1.0,
                               eccentricity = 0.7, max_steps = 10000) +
      scale_size_area(max_size = 90) +
      scale_color_gradientn(colors = c("#FFB6C1","#FF69B4","#FF1493","#DB7093","#C71585")) +
      theme_minimal() +
      theme(plot.background  = element_rect(fill = "white", color = NA),
            panel.background = element_rect(fill = "white", color = NA),
            panel.grid = element_blank(), axis.text = element_blank(),
            axis.title = element_blank(), axis.ticks = element_blank(),
            legend.position = "none")
  })
  
  
  # ── GLOBAL PCOS MAP 2021 ────────────────────────────────────────────────────
  
  output$pcosMap <- renderLeaflet({
    pal <- colorNumeric(palette = c("#FFB6C1","#DC5987","#C13450","#870009"),
                        domain  = map_data_joined$incidence_2021, na.color = "white")
    labels <- sprintf(
      "<strong>%s</strong><br/>Incidence (2021): %s per 100,000<br/>Cases (2021): %s",
      map_data_joined$name,
      ifelse(is.na(map_data_joined$incidence_2021), "No data",
             round(map_data_joined$incidence_2021, 2)),
      ifelse(is.na(map_data_joined$cases_2021), "No data",
             formatC(map_data_joined$cases_2021, format = "d", big.mark = ","))
    ) %>% lapply(htmltools::HTML)
    leaflet(map_data_joined, options = leafletOptions(minZoom = 2)) %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels,
                       options = providerTileOptions(opacity = 0)) %>%
      addPolygons(fillColor = ~pal(incidence_2021), fillOpacity = 0.8,
                  color = "white", weight = 0.5, smoothFactor = 0.5,
                  highlight = highlightOptions(weight = 2, color = "#e63985",
                                               fillOpacity = 0.95, bringToFront = TRUE),
                  label = labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "4px 8px"),
                    textsize = "13px", direction = "auto")) %>%
      addLegend(pal = pal, values = ~incidence_2021, opacity = 0.85,
                title = "Incidence<br/>per 100,000", position = "bottomright",
                na.label = "No data") %>%
      setView(lng = 10, lat = 20, zoom = 2)
  })
  
  
  # ── GLOBAL PCOS MAP 1990 ────────────────────────────────────────────────────
  
  output$pcosMap1990 <- renderLeaflet({
    pal <- colorNumeric(palette = c("#FFB6C1","#DC5987","#C13450","#870009"),
                        domain  = map_data_joined$incidence_1990, na.color = "white")
    labels <- sprintf(
      "<strong>%s</strong><br/>Incidence (1990): %s per 100,000<br/>Cases (1990): %s",
      map_data_joined$name,
      ifelse(is.na(map_data_joined$incidence_1990), "No data",
             round(map_data_joined$incidence_1990, 2)),
      ifelse(is.na(map_data_joined$cases_1990), "No data",
             formatC(map_data_joined$cases_1990, format = "d", big.mark = ","))
    ) %>% lapply(htmltools::HTML)
    leaflet(map_data_joined, options = leafletOptions(minZoom = 2)) %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels,
                       options = providerTileOptions(opacity = 0)) %>%
      addPolygons(fillColor = ~pal(incidence_1990), fillOpacity = 0.8,
                  color = "white", weight = 0.5, smoothFactor = 0.5,
                  highlight = highlightOptions(weight = 2, color = "#e63985",
                                               fillOpacity = 0.95, bringToFront = TRUE),
                  label = labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "4px 8px"),
                    textsize = "13px", direction = "auto")) %>%
      addLegend(pal = pal, values = ~incidence_1990, opacity = 0.85,
                title = "Incidence<br/>per 100,000", position = "bottomright",
                na.label = "No data") %>%
      setView(lng = 10, lat = 20, zoom = 2)
  })
  
  
  # ── US STATE MAPS ───────────────────────────────────────────────────────────
  # Helper to avoid repeating map code four times
  
  make_state_map <- function(col, legend_title) {
    pal <- colorNumeric(palette = c("#e3faff","#528aae","#2c67f2","#000439"),
                        domain  = map_data_state[[col]], na.color = "white")
    labels <- sprintf("<strong>%s</strong><br/>%s: %s",
                      tools::toTitleCase(map_data_state$state), legend_title,
                      ifelse(is.na(map_data_state[[col]]), "No data",
                             round(map_data_state[[col]], 1))) %>%
      lapply(htmltools::HTML)
    leaflet(map_data_state,
            options = leafletOptions(zoomControl = FALSE, dragging = FALSE)) %>%
      addPolygons(fillColor = ~pal(get(col)), fillOpacity = 0.9,
                  color = "white", weight = 1, label = labels,
                  highlightOptions = highlightOptions(weight = 2, color = "#e63985",
                                                      fillOpacity = 1, bringToFront = TRUE)) %>%
      addLegend(pal = pal, values = map_data_state[[col]],
                title = legend_title, position = "bottomright") %>%
      setView(lng = -96, lat = 37.8, zoom = 4)
  }
  
  output$stateMap          <- renderLeaflet({ make_state_map("incidence",       "Incidence per 100,000")    })
  output$stateMapMortality <- renderLeaflet({ make_state_map("mortality_rate",  "Mortality rate per 100,000") })
  output$stateMapDeath     <- renderLeaflet({ make_state_map("death_estimates", "Death Estimates")           })
  output$stateMapNew       <- renderLeaflet({ make_state_map("new_cases",       "New Cases")                 })
  
  
  # ── SCATTER: INCIDENCE 1990 vs AAPC ────────────────────────────────────────
  
  output$scatter_aapc <- renderPlotly({
    rho <- round(cor(pcos$incidence_1990, pcos$aapc, method = "spearman",
                     use = "complete.obs"), 3)
    p   <- round(suppressWarnings(
      cor.test(pcos$incidence_1990, pcos$aapc, method = "spearman")$p.value), 4)
    
    fit      <- lm(aapc ~ incidence_1990, data = pcos)
    x_seq    <- seq(min(pcos$incidence_1990, na.rm = TRUE),
                    max(pcos$incidence_1990, na.rm = TRUE), length.out = 100)
    pred     <- predict(fit, newdata = data.frame(incidence_1990 = x_seq),
                        interval = "confidence")
    trend_df <- data.frame(x = x_seq, y = pred[,"fit"],
                           ymin = pred[,"lwr"], ymax = pred[,"upr"])
    
    plot_ly() %>%
      add_ribbons(data = trend_df, x = ~x, ymin = ~ymin, ymax = ~ymax,
                  fillcolor = "rgba(215,25,28,0.15)",
                  line = list(color = "transparent"),
                  showlegend = FALSE, hoverinfo = "skip") %>%
      add_lines(data = trend_df, x = ~x, y = ~y,
                line = list(color = "#d7191c", width = 2),
                showlegend = FALSE, hoverinfo = "skip") %>%
      add_markers(data = pcos, x = ~incidence_1990, y = ~aapc,
                  marker = list(color = "#e65389", opacity = 0.6, size = 7),
                  text = ~paste0(
                    "<b>", country, "</b><br>",
                    "Incidence 1990: ", round(incidence_1990, 2), " per 100,000<br>",
                    "Incidence 2021: ", round(incidence_2021, 2), " per 100,000<br>",
                    "Cases 1990: ", formatC(cases_1990, format = "d", big.mark = ","), "<br>",
                    "Cases 2021: ", formatC(cases_2021, format = "d", big.mark = ","), "<br>",
                    "AAPC: ", round(aapc, 3)),
                  hoverinfo = "text", showlegend = FALSE) %>%
      layout(
        title      = list(text = "Baseline Incidence (1990) vs AAPC 1990-2021",
                          font = list(size = 15)),
        xaxis      = list(title = "Incidence 1990 (per 100,000)"),
        yaxis      = list(title = "AAPC"),
        hoverlabel = list(bgcolor = "white", font = list(size = 13),
                          bordercolor = "#e65389"),
        annotations = list(list(
          x = 0.98, y = 0.98, xref = "paper", yref = "paper",
          text = paste0("Spearman \u03c1 = ", rho, "<br>p = ", p),
          showarrow = FALSE, font = list(size = 12, color = "gray30"),
          align = "right"))
      )
  })
  
  
  # ── REGION PLOTS ────────────────────────────────────────────────────────────
  
  output$regionBarPlot <- renderPlot({
    ggplot(region_long, aes(x = Region, y = Prevalence, fill = Year)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_fill_manual(values = c("1990" = "#FFB6C1", "2021" = "#C71585")) +
      labs(title = "PCOS Prevalence by Region (1990 vs 2021)",
           x = "Region", y = "Prevalence per 100,000") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 30, hjust = 1))
  })
  
  output$regionDiffPlot <- renderPlot({
    ggplot(region_df, aes(x = Region, y = Difference)) +
      geom_bar(stat = "identity", fill = "#DC5987") +
      labs(title = "Increase in PCOS Prevalence (1990 \u2192 2021)",
           x = "Region", y = "Change in Prevalence") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 30, hjust = 1))
  })
  
  output$regionTTest <- renderPrint({
    t.test(region_df$`Prev 1990`, region_df$`Prev 2021`, paired = TRUE)
  })
  
  
  # ── SDI PLOTS ───────────────────────────────────────────────────────────────
  
  output$sdiBarPlot <- renderPlot({
    ggplot(sdi_long, aes(x = `SDI Level`, y = Prevalence, fill = Year)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_fill_manual(values = c("1990" = "#FFB6C1", "2021" = "#C71585")) +
      labs(title = "PCOS Prevalence by SDI Level (1990 vs 2021)",
           x = "SDI Level", y = "Prevalence per 100,000") +
      theme_minimal()
  })
  
  output$sdiDiffPlot <- renderPlot({
    ggplot(sdi_df, aes(x = `SDI Level`, y = Difference)) +
      geom_bar(stat = "identity", fill = "#DC5987") +
      labs(title = "Increase in PCOS Prevalence by SDI Level (1990 \u2192 2021)",
           x = "SDI Level", y = "Change in Prevalence") +
      theme_minimal()
  })
  
  output$sdiTTest <- renderPrint({
    t.test(sdi_df$`Prev 1990`, sdi_df$`Prev 2021`, paired = TRUE)
  })
  
  
  # ── BMI + HEALTH CHECK OUT ──────────────────────────────────────────────────
  
  output$bmi_display <- renderUI({
    req(input$calculate)
    isolate({
      weight <- as.numeric(input$weight)
      height <- as.numeric(input$height) / 100
      if (is.na(weight) || is.na(height) || weight <= 0 || height <= 0)
        return(div(class = "dc-placeholder",
                   "Enter weight and height above and click Submit."))
      bmi      <- weight / (height ^ 2)
      category <- if (bmi < 18.5) "Underweight" else if (bmi < 25) "Normal weight" else if (bmi < 30) "Overweight" else "Obese"
      div(class = "dc-bmi-row",
          div(class = "dc-bmi-value",    round(bmi, 1)),
          div(class = "dc-bmi-category", category))
    })
  })
  
  output$health_summary_styled <- renderUI({
    req(input$calculate)
    isolate({
      rows <- list(
        c("Age",                  if (!is.na(input$age))     paste(input$age, "years") else "—"),
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
  
  output$data_conclusions <- renderUI({
    req(input$calculate)
    isolate({
      req(input$weight, input$height, input$acne, input$age,
          input$menstrual, input$stress, input$fertility, input$insulin)
      weight <- as.numeric(input$weight);  height <- as.numeric(input$height) / 100
      if (is.na(weight) || is.na(height) || weight <= 0 || height <= 0) return(NULL)
      bmi     <- weight / (height ^ 2)
      bmi_cat <- if (bmi < 18.5) "Underweight" else if (bmi < 25) "Normal" else if (bmi < 30) "Overweight" else "Obese"
      
      warning_banner <- div(class = "dc-warning",
                            tags$strong("Remember: "),
                            "PCOS is undiagnosed in almost 70% of women. These findings are informational only — please consult a healthcare professional for a proper diagnosis.")
      
      all_clear <- bmi_cat %in% c("Normal","Underweight") && input$menstrual == "Regular" &&
        input$acne %in% c("None","Mild") && input$stress == "Low" &&
        input$fertility == "No" && input$insulin == "No"
      
      if (all_clear) return(tagList(
        div(class = "dc-note",
            "Your profile does not show strong PCOS risk indicators. However, up to 70% of cases go undiagnosed. A clinical evaluation is the only way to know for sure."),
        warning_banner))
      
      items <- list()
      age <- as.numeric(input$age)
      
      if (!is.na(age) && age >= 15 && age <= 16)
        items[[length(items)+1]] <- tags$li(tags$b("Age (15-16): "),
                                            "Research shows adolescents with higher free androgen index at ages 15-16 are more likely to develop PCOS by age 26.")
      if (bmi_cat %in% c("Overweight","Obese"))
        items[[length(items)+1]] <- tags$li(tags$b(paste0("BMI — ", bmi_cat, ": ")),
                                            "Roughly 50-70% of women with PCOS are overweight or obese. Excess weight worsens insulin resistance and raises androgen levels.",
                                            tags$sup(tags$a(href="https://www.sciencedirect.com/science/article/abs/pii/S0026049518302336", target="_blank","[source]")))
      if (input$menstrual == "Irregular")
        items[[length(items)+1]] <- tags$li(tags$b("Menstrual Regularity — Irregular: "),
                                            "Approximately 75-85% of women with PCOS experience menstrual dysfunction.",
                                            tags$sup(tags$a(href="https://pmc.ncbi.nlm.nih.gov/articles/PMC5542050/", target="_blank","[source]")))
      if (input$acne %in% c("Moderate","Severe"))
        items[[length(items)+1]] <- tags$li(tags$b(paste0("Acne Severity — ", input$acne, ": ")),
                                            "PCOS raises androgen levels (hyperandrogenism), which worsens acne.",
                                            tags$sup(tags$a(href="https://health.clevelandclinic.org/pcos-acne", target="_blank","[source]")))
      else if (input$acne == "Mild")
        items[[length(items)+1]] <- tags$li(tags$b("Acne Severity — Mild: "),
                                            "Even mild hormonally-driven acne can be an early signal of elevated androgens associated with PCOS.")
      if (input$stress %in% c("Medium","High"))
        items[[length(items)+1]] <- tags$li(tags$b(paste0("Stress Level — ", input$stress, ": ")),
                                            "Women with PCOS show higher stress markers including elevated cortisol and heart rate.",
                                            tags$sup(tags$a(href="https://pmc.ncbi.nlm.nih.gov/articles/PMC5892097/", target="_blank","[source]")))
      if (input$fertility == "Yes")
        items[[length(items)+1]] <- tags$li(tags$b("Fertility Concern — Yes: "),
                                            "Around 70% of women with PCOS experience infertility, making it one of the most common causes of hormonal infertility.",
                                            tags$sup(tags$a(href="https://www.ncbi.nlm.nih.gov/books/NBK459251/", target="_blank","[source]")))
      if (input$insulin == "Yes")
        items[[length(items)+1]] <- tags$li(tags$b("Insulin Resistance — Yes: "),
                                            "About 50% of women with PCOS have an abnormal degree of insulin resistance, independent of obesity.",
                                            tags$sup(tags$a(href="https://www.sciencedirect.com/science/article/abs/pii/S0026049518302336", target="_blank","[source]")))
      
      if (length(items) == 0) return(tagList(
        div(class = "dc-note", "Your profile does not show strong PCOS risk indicators."),
        warning_banner))
      
      tagList(
        div(class = "dc-note", "Based on your responses, here is what the data and research say about your profile:"),
        tags$ul(class = "dc-conclusions-list", items),
        warning_banner)
    })
  })
  
  
  # ── TREATMENT TOGGLE CARDS ──────────────────────────────────────────────────
  
  toggle_card <- function(body_id, chev_id) {
    shinyjs::toggle(body_id, anim = TRUE, animType = "slide", time = 0.3)
    shinyjs::toggleClass(chev_id, "open")
  }
  observeEvent(input$toggle_diet, { toggle_card("body_diet","chev_diet") })
  observeEvent(input$toggle_lod,  { toggle_card("body_lod", "chev_lod")  })
  observeEvent(input$toggle_art,  { toggle_card("body_art", "chev_art")  })
  observeEvent(input$toggle_ocp,  { toggle_card("body_ocp", "chev_ocp")  })
  
  
  # ── RISKS & COMORBIDITIES — tab tracker ─────────────────────────────────────
  
  observe({
    req(input$conditions_tabs)
    cat("[Risks Tab Active]:", input$conditions_tabs, "\n")
  })
  
  
  # ── CVD + UTERINE CANCER SCATTER ────────────────────────────────────────────
  
  output$cvd_uc_scatter <- renderPlotly({
    
    fit      <- lm(`Mortallity rate uterine corps` ~ `Data for CVD`, data = cvd_uc)
    x_seq    <- seq(min(cvd_uc$`Data for CVD`, na.rm = TRUE),
                    max(cvd_uc$`Data for CVD`, na.rm = TRUE), length.out = 100)
    pred     <- predict(fit,
                        newdata = data.frame(`Data for CVD` = x_seq, check.names = FALSE),
                        interval = "confidence")
    trend_df <- data.frame(x = x_seq, y = pred[,"fit"],
                           ymin = pred[,"lwr"], ymax = pred[,"upr"])
    
    plot_ly() %>%
      add_ribbons(data = trend_df, x = ~x, ymin = ~ymin, ymax = ~ymax,
                  fillcolor = "rgba(227,104,149,0.15)",
                  line = list(color = "transparent"),
                  showlegend = FALSE, hoverinfo = "skip") %>%
      add_lines(data = trend_df, x = ~x, y = ~y,
                line = list(color = "#e36895", width = 2),
                showlegend = FALSE, hoverinfo = "skip") %>%
      add_markers(data = cvd_uc,
                  x = ~`Data for CVD`,
                  y = ~`Mortallity rate uterine corps`,
                  marker = list(color = "#e36895", opacity = 0.7, size = 8),
                  text  = ~paste0("<b>", `State/Territory`, "</b><br>",
                                  "CVD Rate: ",     round(`Data for CVD`, 2), "<br>",
                                  "UC Mortality: ", round(`Mortallity rate uterine corps`, 2)),
                  hoverinfo = "text", showlegend = FALSE) %>%
      layout(
        xaxis      = list(title = "CVD Mortality Rate"),
        yaxis      = list(title = "Uterine Corpus Mortality Rate"),
        hoverlabel = list(bgcolor = "white", font = list(size = 13),
                          bordercolor = "#e36895")
      )
  })
  
  
  # ── CVD + UTERINE CANCER CORRELATION ────────────────────────────────────────
  
  output$cvd_uc_corr <- renderPrint({
    cor.test(cvd_uc$`Data for CVD`, cvd_uc$`Mortallity rate uterine corps`)
  })
  
  
  # ── HEART DISEASE MORTALITY BY RACE BOXPLOT ──────────────────────────────────
  
  output$cvd_race_box <- renderPlot({
    cvd_race <- readxl::read_excel(
      "Heart_Disease_Mortality_Data_Among_US_Adults__35___by_State_Territory_and_County___2019-2021 clean.xlsx"
    )
    ggplot(cvd_race,
           aes(x = Stratification2, y = Data_Value,
               color = Stratification2, shape = Stratification1)) +
      geom_boxplot(alpha = 0.5) +
      scale_color_manual(values = c("#C71585","#e63985","#FF69B4",
                                    "#FFB6C1","#DC5987","#870009",
                                    "#DB7093","#F48CBB")) +
      labs(title  = "Heart Disease Mortality by Race & Sex",
           x      = "Race / Ethnicity",
           y      = "Mortality Rate per 100,000",
           color  = "Race", shape = "Sex") +
      theme_minimal() +
      theme(axis.text.x   = element_text(angle = 60, hjust = 1, size = 11),
            plot.title     = element_text(family = "serif", size = 16, color = "#1a1a2e"),
            legend.position = "right")
  })
  
}