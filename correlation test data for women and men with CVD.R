View(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean)
table(Stratification2$Class)
cor(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean$Stratification2, 
    Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean$Class)
as.numeric(as.factor(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean$Class))
View(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean)
cor(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean$Class, 
    Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean$Stratification2)
fit <- lm(Data_Value ~ Stratification2, data = Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean)
summary(fit)
fit2 <- lm(Data_Value ~ Stratification2 + LocationAbbr, data = Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean)
summary(fit2)
anova(fit, fit2)
t.test(Data_Value ~ Stratification1, data = Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean_men_women)
fit_women <- lm(Data_Value ~ Stratification2 + LocationAbbr, data = subset(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean_men_women, Stratification1 == "Female"))

fit_men <- lm(Data_Value ~ Stratification2 + LocationAbbr, data = subset(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean_men_women, Stratification1 == "Male"))

summary(fit_women)
summary(fit_men)
ggplot(Heart_Disease_Mortality_Data_Among_US_Adults_35_by_State_Territory_and_County_2019_2021_clean, aes(Stratification2,Data_Value, 
                      color = Stratification2, 
                      shape = Stratification1,
                      alpha = 0.5)) + 
  geom_boxplot()+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

fit_uterine<-lm(`Mortallity rate uterine corps`~ `Data for CVD` , data = CVD_UC_mortaility_data_2019_2023_clean_Sheet1_)
summary(fit_uterine)
library(dplyr)

CVD_UC_clean <- CVD_UC_mortaility_data_2019_2023_clean_Sheet1_ %>%
  filter(!is.na(`Data for CVD`))
nrow(CVD_UC_clean)
fit_uterine <- lm(`Mortallity rate uterine corps` ~ `Data for CVD`, 
                  data = CVD_UC_clean)
summary(fit_uterine)
anova_both <- aov(cbind(`Data for CVD`, `Mortallity rate uterine corps`) ~ `State/Territory`, 
                  data = CVD_UC_mortaility_data_2019_2023_clean_Sheet1_)
summary(anova_both)
summary(CVD_UC_clean$`Data for CVD`)
summary(CVD_UC_clean$`Mortallity rate uterine corps`)
library(ggplot2)

ggplot(CVD_UC_mortaility_data_2019_2023_clean_Sheet1_, aes(x = `Data for CVD`, 
                         y = `Mortallity rate uterine corps`, 
                         label = `State/Territory`)) +
  geom_point(color = "#e36895") +
  geom_text(nudge_y = 0.5, size = 3) +
  geom_smooth(method = "lm", color ="#e36895") 
cor.test(CVD_UC_mortaility_data_2019_2023_clean_Sheet1_$`Data for CVD`, 
         CVD_UC_mortaility_data_2019_2023_clean_Sheet1_$`Mortallity rate uterine corps`)


#CVD statewise 

cvd_data <- read.csv("CVD + UC mortaility data 2019-2023 clean(Sheet1).csv")

cvd_data_clean <- cvd_data %>%
  dplyr::select(
    state = `State/Territory`,
    cvd_rate = `Data for CVD `
  ) %>%
  dplyr::mutate(state = tolower(state))

map_data_state <- us_states_sf %>%
  dplyr::left_join(cvd_data_clean, by = "state")

output$stateMapCVD <- renderLeaflet({
  
  pal <- colorNumeric(
    palette  = c("#e3faff", "#528aae", "#2c67f2", "#000439"),
    domain   = map_data_state$cvd_rate,
    na.color = "white"
  )
  
  labels <- sprintf(
    "<strong>%s</strong><br/>CVD Mortality: %s per 100,000",
    tools::toTitleCase(map_data_state$state),
    ifelse(is.na(map_data_state$cvd_rate), "No data",
           round(map_data_state$cvd_rate, 1))
  )
  
  leaflet(
    map_data_state,
    options = leafletOptions(
      zoomControl = FALSE,
      dragging = FALSE
    )
  ) %>%
    addPolygons(
      fillColor        = ~pal(cvd_rate),
      fillOpacity      = 0.9,
      color            = "white",
      weight           = 1,
      label            = lapply(labels, htmltools::HTML),
      highlightOptions = highlightOptions(
        weight       = 2,
        color        = "#e63985",
        fillOpacity  = 1,
        bringToFront = TRUE
      )
    ) %>%
    addLegend(
      pal = pal,
      values = ~cvd_rate,
      title = "CVD mortality rate per 100,000",
      position = "bottomright"
    ) %>%
    setView(lng = -96, lat = 37.8, zoom = 4)
})
