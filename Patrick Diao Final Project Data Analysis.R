# ==========================================
# 1. SETUP AND DATA LOADING
# ==========================================
install.packages("readr") 
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)

# Import the raw dataset
csv_data <- read_csv("~/Desktop/julie data/BB_2024_06_13 SPSS.csv")

# ==========================================
# 2. DATA CLEANING: SOCIOECONOMIC VARIABLES
# ==========================================

# Define missing value codes common in SPSS datasets
missing_codes <- c(777, 888, 999)

# Clean demographic variables (A04: Education, A08: Income Category, A09: Household Size)
df_clean <- csv_data %>%
  mutate(
    A08 = ifelse(A08 %in% missing_codes, NA, A08),
    A09 = ifelse(A09 %in% missing_codes, NA, A09),
    A04 = ifelse(A04 %in% missing_codes, NA, A04)
  ) %>%
  filter(!is.na(A08), !is.na(A09), !is.na(A04)) %>%
  rename(education = A04)

# converting income group to an estimated midpoint income  
df_clean$income_mid <- NA 
for (i in 1:nrow(df_clean)) {
  if (df_clean$A08[i] == 1)  df_clean$income_mid[i] <- 5000
  if (df_clean$A08[i] == 2)  df_clean$income_mid[i] <- 15000.5
  if (df_clean$A08[i] == 3)  df_clean$income_mid[i] <- 25000.5
  if (df_clean$A08[i] == 4)  df_clean$income_mid[i] <- 35000.5
  if (df_clean$A08[i] == 5)  df_clean$income_mid[i] <- 45000.5
  if (df_clean$A08[i] == 6)  df_clean$income_mid[i] <- 55000.5
  if (df_clean$A08[i] == 7)  df_clean$income_mid[i] <- 65000.5
  if (df_clean$A08[i] == 8)  df_clean$income_mid[i] <- 75000.5
  if (df_clean$A08[i] == 9)  df_clean$income_mid[i] <- 85000.5
  if (df_clean$A08[i] == 10) df_clean$income_mid[i] <- 95000
}

# Calculate Income Per Capita
df_clean$income_per_capita <- df_clean$income_mid / df_clean$A09



# ==========================================
# 3. VARIABLE CONSTRUCTION
# ==========================================

# Define item groups 
pss_items <- c("R01_0","R02_0","R03_0","R04_0","R05_0","R06_0","R07_0","R08_0","R09_0","R10_0","R11_0","R12_0","R13_0","R14_0")
bayley_outcomes <- c("BR_ERCL_12", "PDI_12",  "MDI_12", "BR_OERS_12", "BR_ERRS_12")
demoralization_items <- c("L01_0", "L02_0", "L03_0", "L04_0", "L05_0", "L06_0", "L07_0", "L08_0", "L09_0", "L10_0", "L11_0", "L12_0", "L13_0", "L14_0", "L15_0", "L16_0", "L17_0", "L18_0", "L19_0", "L20_0", "L21_0", "L22_0", "L23_0", "L24_0", "L25_0", "L26_0", "L27_0")

# Define the subscales for the PSS-14
neg_items <- c("R01_0","R04_0","R05_0","R06_0","R09_0","R12_0","R13_0") # Helplessness
pos_items <- c("R02_0","R03_0","R07_0","R08_0","R10_0","R11_0","R14_0") # Self-Efficacy (to be reversed)


all_variables <- c(pss_items, bayley_outcomes, demoralization_items)
for (v in all_variables) {
  for (i in 1:nrow(df_clean)) {
    if (!is.na(df_clean[[v]][i]) && df_clean[[v]][i] %in% missing_codes) {
      df_clean[[v]][i] <- NA
    }
  }
}


# PSS-14 Scoring: Shift 1-5 scores to 0-4 scale 
shift_items <- c("R01_0","R02_0","R03_0","R04_0")
df_clean[shift_items] <- df_clean[shift_items] - 1

# Reverse-score the positive items 
df_clean[pos_items] <- 4 - df_clean[pos_items]

# Create PSS Subscales and Total Sum
df_clean$pss_sum_0  <- rowSums(df_clean[pss_items], na.rm = TRUE)
df_clean$pss_helpless_0 <- rowSums(df_clean[neg_items], na.rm = TRUE)
df_clean$pss_selfeff_0 <- rowSums(df_clean[pos_items], na.rm = TRUE)
df_clean$mean_demoralization <- rowMeans(df_clean[demoralization_items], na.rm = TRUE)


# ==========================================
# 4. Descriptive Statistics and Log Transformations 
# ==========================================


# examining descriptive statistics. The following codes will look at the racial distribution
df_clean <- df_clean %>%
  mutate(race_label = case_when(
    RACE == 1 ~ "American Indian/Alaska Native",
    RACE == 2 ~ "Asian",
    RACE == 3 ~ "Black or African American",
    RACE == 4 ~ "Native Hawaiian/Pacific Islander",
    RACE == 5 ~ "White",
    RACE == 6 ~ "More Than One Race",
    RACE == 7 ~ "Unknown/Not Reported"))

for (i in 1:nrow(df_clean)) { 
  if (is.na(df_clean$race_label[i])) { 
    df_clean$race_label[i] <- "Unknown/Not Reported" } }

total_population <- nrow(df_clean)
race_data <- df_clean %>% group_by(race_label) %>% summarise(count = n())%>% mutate(percentage = (count / total_population) * 100)

print (race_data)

# Race cannot be used as a variable because there is simply too much data (87.9 percent) not reported or missing 

# The following code will look at the distribution of education level

df_clean <- df_clean %>%
  mutate(edu_label = case_when(
    education == 1 ~ "Less than high school",
    education == 2 ~ "High school diploma",
    education == 3 ~ "Alternative high school diploma or GED",
    education == 4 ~ "1-4 years of undergraduate but no degree",
    education == 5 ~ "Community college or 2 year degree",
    education == 6 ~ "Bachelor's degree (4 year college)",
    education == 7 ~ "Masters or other graduate degree"
  ))

for (i in 1:nrow(df_clean)) { 
  if (is.na(df_clean$edu_label[i])) { 
    df_clean$edu_label[i] <- "Unknown/Not Reported"  } }

edu_data <- df_clean %>% 
  group_by(edu_label) %>% 
  summarise(count = n()) %>%
  mutate(percentage = (count / nrow(df_clean)) * 100)

print(edu_data)

# only 8.62 percent of the data in education is missing. This is usable as a variable. 


# The following code looks at the distribution of income using a histogram and also looks directly at summary statistics

library(ggplot2)

ggplot(df_clean, aes(x = income_per_capita)) +
  geom_histogram(fill = "steelblue", color = "white", bins = 20) +  labs(title = "Distribution of Income Per Capita", subtitle = paste("Sample Size N =", sum(!is.na(df_clean$income_per_capita))),
                                                                         x = "Annual Income Per Person ($)",
                                                                         y = "Count of Person"
  ) +  theme_minimal() + scale_x_continuous(labels = scales::dollar_format())

summary(df_clean$income_per_capita)

# Since the data is positively skewed, we will log transform it 

df_clean <- df_clean %>% mutate(log_income_per_capita = log(income_per_capita + 1))

# maternal stress is normally distributed 

ggplot(df_clean, aes(x = pss_sum_0)) +
  geom_histogram(fill = "thistle", color = "white", bins = 20) + 
  scale_x_continuous(limits = c(0, 60), breaks = seq(0, 60, by = 10)) +
  labs( title = "Distribution of Maternal Perceived Stress",
        subtitle = paste("Sample Size N =", sum(!is.na(df_clean$pss_sum_0))),
        x = "Mother Stress PSS Total Score",
        y = "Number of Mothers"  ) +  theme_minimal()



# mean maternal demoralization is extremely positively skewed 

ggplot(df_clean, aes(x = mean_demoralization)) +
  geom_histogram(fill = "lightblue", color = "white", bins = 20) + 
  labs( title = "Distribution of Maternal Demoralization mean score", subtitle = paste("Sample Size N =", sum(!is.na(df_clean$mean_demoralization))), x = "Mean Demoralization Score (Raw)", y = "Frequency" ) + theme_minimal()

# Since it is so positively skewed, we will log transform it 
df_clean<- df_clean %>% mutate(log_mean_demoralization = log(mean_demoralization + 1))

# Infant MDI and ERRS scores on the Bayley are pretty normally distributed. Thus, there is no need to transform these outcome variables for regression 
hist(df_clean$MDI_12, main = "Distribution of Infant MDI Scores", xlab = "MDI Score", col = "seagreen", border = "white")

ggplot(df_clean, aes(x = MDI_12)) + 
  geom_histogram(fill = "seagreen", color = "white", bins = 20) + 
  labs(
    title = "Distribution of Infant MDI Scores",
    subtitle = paste("Sample Size N =", sum(!is.na(df_clean$MDI_12))),
    x = "MDI Score",
    y = "Frequency"
  ) + theme_minimal()

ggplot(df_clean, aes(x = BR_ERRS_12)) + 
  geom_histogram(fill = "seagreen", color = "white", bins = 20) + 
  labs(title = "Distribution of Infant Emotional Regulation (ERRS)",
       subtitle = paste("Sample Size N =", sum(!is.na(df_clean$BR_ERRS_12))),
       x = "ERRS Score",
       y = "Frequency"
  ) +  scale_x_continuous(limits = c(min(df_clean$BR_ERRS_12, na.rm=T)-10, max(df_clean$BR_ERRS_12, na.rm=T)+10)) +
  theme_minimal()


# Filter for final analysis set (participants with complete PSS and MDI data)
reg_main <- df_clean %>% filter(!is.na(pss_sum_0), !is.na(MDI_12))




# ==========================================
# 5. STATISTICAL ANALYSIS: MATERNAL PERCEIVED STRESS
# ==========================================

# Correlation between PSS subscales and MDI 
cor.test(reg_main$MDI_12, reg_main$pss_selfeff_0)
cor.test(reg_main$MDI_12, reg_main$pss_helpless_0)
cor.test(reg_main$BR_ERRS_12, reg_main$pss_selfeff_0)
cor.test(reg_main$BR_ERRS_12, reg_main$pss_helpless_0)


# Plot: Maternal self-efficacy vs Infant MDI 
ggplot(reg_main, aes(x = pss_selfeff_0, y = MDI_12)) + 
  geom_point(alpha = 0.5, color = "darkblue") + 
  geom_smooth(method = "lm", color = "red", fill = "pink") + 
  labs(
    title = "Maternal Self-Efficacy and Infant Mental Development",
    # Combined both pieces of info into one subtitle
    subtitle = paste("N =", sum(!is.na(reg_main$pss_selfeff_0)), 
                     " p = .089"),
    x = "Maternal Stress: Self-Efficacy Subscale", 
    y = "Infant MDI Score"
  ) + 
  theme_minimal()


# Model 1 & 2: effects of maternal stress, income, and education on MDI 
m1 <- lm(MDI_12 ~ pss_sum_0, data = reg_main)

# Plot: Maternal Stress vs Infant MDI 
ggplot(reg_main, aes(x = pss_sum_0, y = MDI_12)) + 
  geom_point(alpha = 0.5, color = "darkblue") +
  geom_smooth(method = "lm", color = "red", fill = "pink") + 
  labs(title = "Maternal Stress and Infant Development", 
       subtitle = paste("N =", sum(!is.na(reg_main$pss_sum_0)), 
                        " p = 0.104"),
       x = "Perceived Stress Scale (PSS-14)", y = "Infant MDI Score") +  theme_minimal()



m2_income <- lm(MDI_12 ~ log_income_per_capita, data = reg_main)
m2_education<- lm(MDI_12 ~ education, data = reg_main)
summary(m1)
summary(m2_income)
summary(m2_education)

# Model 2 Full: Adjusted Multiple Regression
m2_full <- lm(MDI_12 ~ pss_sum_0 + education + log_income_per_capita, data = reg_main)
summary(m2_full)


# Model 3: Stress and Emotion Regulation 
m3 <- lm(BR_ERRS_12 ~ pss_sum_0, data = reg_main)
summary(m3)

# Model 4: ANOVA to see if maternal stress differs by clinical risk categories 
m4 <- aov(pss_sum_0 ~ as.factor(BR_ERCL_12), data = reg_main)
summary(m4)

# Model 5 & 6: Stress vs Psychomotor (PDI) and Orienting (OERS) 
m5 <- lm(PDI_12 ~ pss_sum_0, data = reg_main)
m6 <- lm(BR_OERS_12 ~ pss_sum_0, data = reg_main)
summary(m5)
summary(m6)

# ==========================================
# 6. STATISTICAL ANALYSIS: MATERNAL DEMORALIZATION
# ==========================================

# Model 7: Demoralization and MDI 
m7_demo_mdi <- lm(MDI_12 ~ log_mean_demoralization, data = reg_main)
m7_full <- lm(MDI_12 ~ log_mean_demoralization + education + log_income_per_capita, data = reg_main)
summary(m7_demo_mdi)
summary(m7_full)

# Plot: Demoralization vs MDI 
ggplot(reg_main, aes(x = log_mean_demoralization, y = MDI_12)) + 
  geom_point(alpha = 0.5, color = "darkblue") + 
  geom_smooth(method = "lm", color = "red", fill = "pink") + 
  labs(
    title = "Log Maternal Demoralization & Infant Development", 
    subtitle = paste("N =", sum(!is.na(reg_main$log_mean_demoralization))), 
    x = "Log Maternal Demoralization (PERI-D)", 
    y = "Infant MDI Score"
  ) + 
  theme_minimal()


# Model 8: Demoralization and Emotion Regulation
m8 <- lm(BR_ERRS_12 ~ log_mean_demoralization, data = reg_main)
m8_full <- lm(BR_ERRS_12 ~ log_mean_demoralization + education + log_income_per_capita, data = reg_main)
summary(m8)
summary(m8_full)


# ============================================================
# 7. FURTHER EXPLORATION OF THE MOST SIGNIFICANT RESULTS
# ============================================================

# Since the correlation between positive items on PSS-14 and MDI was fairly close to statistical significance, I want to explore whether taking out the items that have low factor loadings would improve the correlation. Therefore, I decided to follow the subscale construction of PSS-10 and take out I4,I5,I13 of the original PSS-14 as a sensitivity analysis. For relevant scholarship, see (Koğar & Koğar, 2023). In the code below, I am recreating the positive items group in the PSS-10.

pss_10_pos_items <- c("R02_0","R03_0","R10_0","R11_0")
reg_main$pss10_pos_sum <- rowSums(reg_main[pss_10_pos_items], na.rm = TRUE)
m9_pss10 <- lm(MDI_12 ~ pss10_pos_sum, data =reg_main) 
summary(m9_pss10)
m9_full <- lm(MDI_12 ~ pss10_pos_sum + education + log_income_per_capita, data = reg_main)
summary(m9_full)


# here we have a p=0.01, a significant result!!! Even after controlling for income and education, it is still significant

ggplot(reg_main, aes(x = pss10_pos_sum, y = MDI_12)) +
  geom_point(alpha = 0.5, color = "darkblue") +
  geom_smooth(method = "lm", color = "red", fill = "pink") +
  labs(
    title = "Maternal Self-Efficacy Predicts Infant Cognitive Development",
    subtitle = paste("Significant negative relationship p = .0113 | beta = - 0.8721 | N =", nrow(reg_main)),
    x = "PSS-10 Positive Items",
    y = "Infant Bayley MDI Score " ) +
  theme_minimal()

# testing for the effect of outliers on the linear regression model. Outlier does not seem to influence the result 
cooks_d <- cooks.distance(m9_full)
summary(cooks_d)
# testing for distribution of residuals 
ggplot(m9_full, aes(sample = .resid)) +
  stat_qq(color = "darkblue", alpha = 0.6) +
  stat_qq_line(color = "red") +
  labs(
    title = "Normal Q-Q Plot of Residuals",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  ) +
  theme_minimal()

