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
