summary(pcos_prediction_dataset)
library(ggplot2)
view(pcos_prediction_dataset)
ggplot(pcos_prediction_dataset, aes(`Urban/Rural`, Diagnosis)) + geom_bar()
library(tidyverse)
r
library(ggplot2)

# Plot 1 - diagnosis rate by country (top 10)
country_summary <- aggregate(pcos_prediction_dataset$Diagnosis == "Yes", 
                             by = list(Country = pcos_prediction_dataset$Country), 
                             FUN = mean)
colnames(country_summary) <- c("Country", "diag_rate")
country_summary <- country_summary[order(country_summary$diag_rate, decreasing = TRUE), ]
top10 <- country_summary[1:10, ]

ggplot(top10, aes(x = reorder(Country, diag_rate), y = diag_rate)) +
  geom_col(fill = "#5DCAA5") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "Top 10 countries by PCOS diagnosis rate", x = NULL, y = "Diagnosis rate") +
  theme_minimal()

# Plot 2 - BMI distribution
ggplot(pcos_prediction_dataset, aes(x = pcos_prediction_dataset$BMI)) +
  geom_bar(fill = "#5DCAA5") +
  labs(title = "BMI distribution in sample", x = "BMI category", y = "Count") +
  theme_minimal()

# Plot 3 - diagnosis by menstrual regularity
ggplot(pcos_prediction_dataset, aes(x = pcos_prediction_dataset$`Menstrual Regularity`, 
                                    fill = pcos_prediction_dataset$Diagnosis)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("Yes" = "#5DCAA5", "No" = "#B4B2A9")) +
  labs(title = "Diagnosis rate by menstrual regularity", x = NULL, y = "Proportion") +
  theme_minimal()

# Plot 4 - PCOS awareness by ethnicity
ggplot(pcos_prediction_dataset, aes(x = pcos_prediction_dataset$Ethnicity, 
                                    fill = pcos_prediction_dataset$`Awareness of PCOS`)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("Yes" = "#5DCAA5", "No" = "#B4B2A9")) +
  labs(title = "PCOS awareness by ethnicity", x = NULL, y = "Proportion") +
  theme_minimal()

# Plot 5 - socioeconomic status by urban/rural
ggplot(pcos_prediction_dataset, aes(x = pcos_prediction_dataset$`Urban/Rural`, 
                                    fill = pcos_prediction_dataset$`Socioeconomic Status`)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("High" = "#5DCAA5", "Middle" = "#85B7EB", "Low" = "#F0997B")) +
  labs(title = "Socioeconomic status by urban/rural setting", x = NULL, y = "Proportion") +
  theme_minimal()
