# Patrick-Diao-s-Final-Assignment-for-Programming-for-Psychologists
The data used in this study comes from the Columbia Center for Children’s Environmental Health (CCCEH). It is a part of the Fairstart study. The data includes 250 participants and was collected recently within the past 5 years. Due to data access rules, this data will not be shared on GitHub. 

Data analysis plan: 
In the present analysis, we examine whether maternal perceived stress and demoralization are associated with infant developmental functioning, as indexed by Bayley Scale of Infant and Toddler Development scores. Maternal stress will be treated as the primary independent variable, and infant cognitive and emotional outcomes will serve as dependent variables. In this dataset, scores from two measures are used as predictors. They are the Perceived Stress Scale -14 items (PSS-14) and the Psychiatric Epidemiology Research Interview—Demoralization Scale (PERI-D). Therefore, regression will be run separately for each. 

To evaluate whether any observed association is attributable to socioeconomic confounding, we will use a stepwise multiple regression model. The initial linear regression models will examine the relationship between maternal stress and maternal demoralization and Bayley outcomes, followed by an adjusted model that includes key socioeconomic covariates, specifically maternal educational attainment and an estimated per-capita income. Other dimensions of the Bayley scale, such as emotion regulation, orienting/attention, and psychomotor development, will also be correlated with maternal perceived stress to explore any potential relationships. 

## Research question

Is maternal stress (perceived stress and/or demoralization) associated with infant developmental outcomes on the Bayley scales, and do any associations persist after adjusting for socioeconomic covariates?

## Key Finding 
Maternal self-efficacy as measured by positive items of PSS-10 was a significant predictor of infant MDI scores in a simple linear regression model (beta = -0.87, p = .011) and remained significant in a multiple regression model (beta = -0.84, p = .015), even after controlling for maternal education and log-transformed income per capita. 
## Go to line 137 to see the detail 

## Variable Construction 
In this dataset, A04 is the highest degree obtained. A08 is the annual household income categorized from 1-10. A09 is the number of people supported by that income. Because the dataset lacks income per capita data, I converted the income category (A08) to an approximate dollar amount using the midpoint values, then divided by household size (A09) to obtain an approximate average income per person. For example, for a participant who scored 2 for A08(10,001 - 20,000 dollars per year), I will just give the midpoint value of 15,000 dollars. Results from descriptive statistics show that participant income is highly positively skewed. Therefore, it is log-transformed before being entered into the regression models. The mean maternal demoralization score is also highly positively skewed. Thus, it is also log-transformed. 

## Dependencies
To run this code, you need R (version 4.0 or higher) and the following packages:

readr: For importing CSV data.
tidyr + dplyr: For data manipulation and filtering.
ggplot2: For generating statistical visuals


## File conversion: 
The original file is in the .sav format. Opening the file directly in R will cause an error. 
spss_data <- read_sav("~/Desktop/julie data/BB_2024_06_13 SPSS.sav") 
Invalid time string (length=8): 02414:57
I recommend opening it directly in SPSS and downloading the file as a CSV. 

## How to Run the Analysis
Open the .R script titled “Patrick Diao Final Project Data Analysis.R”
Run Setup and Cleaning: Execute Sections 1 through 3 to clean missing values (777, 888, 999), calculate income per capita, and reverse-score self-efficacy items.
Run Descriptive Analysis: Section 4 generates histograms to verify distributions and applies log transformations where necessary.
Execute the regression models from sections 5-7. 
# Section 7 contains the regression models that produced the significant results.
View Diagnostics: The end of the script generates the Cook's Distance and Normal Q-Q plots to verify the model’s statistical robustness. 

## Results: 
# Descriptive statistics: 
<img width="384" height="141" alt="Screenshot 2025-12-19 at 06 08 48" src="https://github.com/user-attachments/assets/b35943c2-508b-4a5e-80b6-5888e237dd33" />

# Race cannot be used as a variable because there is simply too much data (87.9 percent) not reported or missing 

distribution of education 
<img width="359" height="176" alt="Screenshot 2025-12-19 at 06 10 19" src="https://github.com/user-attachments/assets/8e70235e-d8f0-41d1-889c-fc02743018dc" />

distribution of income 
<img width="450" height="393" alt="Screenshot 2025-12-19 at 06 10 50" src="https://github.com/user-attachments/assets/399d354a-52ad-40c4-b1fa-1d55b2d9085d" />
# Since the data is positively skewed, it is later log-transformed 

distribution of maternal perceived stress 
<img width="395" height="349" alt="Screenshot 2025-12-19 at 06 12 00" src="https://github.com/user-attachments/assets/c426ef0e-8eb8-452c-93cd-11f4b3f8d8cb" />

distribution of maternal demoralization 
<img width="401" height="341" alt="Screenshot 2025-12-19 at 06 12 44" src="https://github.com/user-attachments/assets/252c09fb-7ae2-4466-b71f-0abe5561c4bc" />
# Since the data is positively skewed, the maternal demoralization mean score is later log-transformed as well

distribution of Infant MDI score 
<img width="424" height="379" alt="Screenshot 2025-12-19 at 06 14 10" src="https://github.com/user-attachments/assets/ee25cb22-df3b-483c-831b-f633705a9a6d" />

distribution of Infant Emotion Regulation score 
<img width="412" height="362" alt="Screenshot 2025-12-19 at 06 15 06" src="https://github.com/user-attachments/assets/063af29c-a6c7-4f5c-86c5-cdaef63f9b80" />

## Regressions and ANOVA
# Relationship between Maternal Perceived Stress and Bayley Outcomes 
Because the PSS-14 has a two-factor structure. I first tested whether the two subscales correlate with the key outcome variables in this dataset. 

Correlation between the Infant Mental Development Score on the Bayley and Self-efficacy items on PSS-14
<img width="459" height="231" alt="Screenshot 2025-12-19 at 06 16 20" src="https://github.com/user-attachments/assets/8134af21-46df-4e19-81eb-5a0b24d9478e" />

Correlation between the Infant Mental Development Score on the Bayley and Helplessness items on PSS-14
<img width="503" height="256" alt="Screenshot 2025-12-19 at 06 17 57" src="https://github.com/user-attachments/assets/8ddf7d8a-a0f7-48b1-9865-2211877fb4d8" />

Correlation between the Infant Emotion Regulation Score on the Bayley and Self-Efficacy items on PSS-14
<img width="536" height="219" alt="Screenshot 2025-12-19 at 06 19 08" src="https://github.com/user-attachments/assets/7b3e4735-4b92-4344-a543-8408bed5257b" />

Correlation between the Infant Emotion Regulation Score on the Bayley and Helplessness items on PSS-14
<img width="491" height="223" alt="Screenshot 2025-12-19 at 06 20 00" src="https://github.com/user-attachments/assets/c65dc602-30a8-4676-ad60-ab95adf19cc9" />

Scatterplot of the Infant Mental Development Score on the Bayley and Self-efficacy items on PSS-14
<img width="395" height="352" alt="Screenshot 2025-12-19 at 06 21 49" src="https://github.com/user-attachments/assets/e647c6a1-d7a9-4480-a0a7-da3acc9d4b5a" />

#  Pearson correlations were conducted to determine the relationship between the two PSS-14 subscales and the Infant Mental Development Index (MDI) scores. The correlation between maternal self-efficacy (pss_selfeff_0) and infant MDI was negative and trended toward significance (r = -0.14, p = 0.089). The correlation between maternal helplessness (pss_helpless_0) and infant MDI was not statistically significant (r = -0.08, p = 0.311). These results suggest that lower self-efficacy may be weakly linked to lower infant mental development scores, but the relationship does not meet the standard threshold for statistical significance. The other two correlations tested, the association between PSS-14 subscales and Bayley emotion regulation raw score were both insignificant. 

M1 seeks to test the relationship between maternal perceived stress (pss_sum_0)and infant MDI scores. Summary of the linear regression (M1) can be seen below: 
<img width="423" height="254" alt="Screenshot 2025-12-19 at 06 25 04" src="https://github.com/user-attachments/assets/c9e2d84d-bb6d-4126-82ee-2d2282d0613b" />

A simple linear regression (M1) showed that maternal perceived stress (pss_sum_0) did not significantly predict infant MDI scores (beta = -0.207, p = 0.104). 
<img width="378" height="332" alt="Screenshot 2025-12-19 at 06 22 30" src="https://github.com/user-attachments/assets/08a63935-ef74-4a5a-aa99-c219797c6f41" />

M2 models tested the relationship between infant MDI scores and income and education. Summary of the linear regression models (M2) can be seen below: 
<img width="419" height="249" alt="Screenshot 2025-12-19 at 06 26 46" src="https://github.com/user-attachments/assets/2b64764a-e113-4e2f-95eb-26ef9850e173" />

<img width="425" height="234" alt="Screenshot 2025-12-19 at 06 26 59" src="https://github.com/user-attachments/assets/4ba3186a-74aa-4a37-845e-cbe924c835b3" />
The results show that log-transformed per-capita income  (p = 0.433) and education (p = 0.204) alone (M2) were not significant predictors of infant MDI in simple linear regression models. 

M2_full model included maternal stress, education, and log income per capita were included in a single model to predict infant MDI score. Summary of the linear regression models (M2_full) can be seen below: 
<img width="453" height="322" alt="Screenshot 2025-12-19 at 06 29 54" src="https://github.com/user-attachments/assets/008d8bb9-542d-4c61-a2d3-44314e168969" />
The overall model remained non-significant, p = 0.246. Perceived stress remained non-significant after controlling for socioeconomic factors (p = 0.127). Neither education (p = 0.292) nor log-transformed income (p = 0.746) was a significant predictor in the adjusted model. 

The M3 model tested the relationship between infant Emotion Regulation scores and Maternal stress. Summary of the linear regression models (M3) can be seen below: 
<img width="506" height="369" alt="Screenshot 2025-12-19 at 06 31 46" src="https://github.com/user-attachments/assets/78964e27-5571-49e6-87ab-8418d184af15" />
Maternal stress (m3) did not significantly predict infant emotion regulation raw scores (beta = -0.076, p = 0.362) 

In the Bayley, there is a classification system of emotion regulation for infants. Emotion regulation risk categories (ERCL) includes: 0 non-optimal, 1 questionable, and 2 within normal limits. Therefore, I conducted a One-Way ANOVA (m4) to confirm whether maternal stress levels differ by emotion regulation risk categories.  Summary of the ANOVA results (M4) can be seen below: 
<img width="625" height="95" alt="Screenshot 2025-12-19 at 06 36 45" src="https://github.com/user-attachments/assets/d823e7b1-18a1-40c5-a40a-92d8d987240e" />
The One-Way ANOVA (m4) confirmed that maternal stress levels did not differ significantly across infant emotion regulation risk categories (F = 0.655, p = 0.522)

In M5 and M6, a linear regression model was used to test the relationship between stress and psychomotor development and orienting/attention. Results are shown below: 
here is the linear regression for psychomotor development index 
<img width="415" height="262" alt="Screenshot 2025-12-19 at 06 39 20" src="https://github.com/user-attachments/assets/1dca2456-b9bc-44b6-a286-9890b821e522" />
here is the linear regression for orienting and attention
<img width="376" height="258" alt="Screenshot 2025-12-19 at 06 40 02" src="https://github.com/user-attachments/assets/d92a466f-18d8-43f6-9b26-5c2a32055f66" />
In M5 and M6, maternal perceived stress was not associated with psychomotor development (p = 0.6) or orienting/attention (p = 0.739).

#  The following models use the average PERI-D demoralization score and other demographic variables to predict Bayley outcomes. Please note that the predictor variable has changed from PSS-14 score to PERI-D 

The M7 model tested the relationship between infant MDI scores and log-transformed mean Maternal Demoralization scores. Summary of the linear regression models (M7) can be seen below: 
<img width="403" height="259" alt="Screenshot 2025-12-19 at 06 42 37" src="https://github.com/user-attachments/assets/dd2b3f87-c9f3-4465-b11b-70cb46c28e73" />
In M7, log-transformed maternal demoralization was not a significant predictor of infant MDI (p = 0.281).
here is a scatterplot of this linear regression 
<img width="433" height="380" alt="Screenshot 2025-12-19 at 06 43 49" src="https://github.com/user-attachments/assets/bc0fccbd-984d-4b54-9893-3257fa00eb02" />

In the M7_full model, education and log-transformed income, as well as demoralization, were entered into the same model to predict infant MDI. All variables remained non-significant. Results are shown below
<img width="529" height="307" alt="Screenshot 2025-12-19 at 06 45 11" src="https://github.com/user-attachments/assets/9aa35f05-6e7a-4f85-81dd-fb65bdc8d766" />

In M8, log-transformed mean demoralization score did not significantly predict infant emotion regulation raw score (p=0.8722)
<img width="514" height="292" alt="Screenshot 2025-12-19 at 06 46 18" src="https://github.com/user-attachments/assets/03f54005-7815-41a7-afa6-4a4b44dbadcc" />

In M8 (full), after including sociodemographic variables, the model remained non-significant. 
<img width="432" height="301" alt="Screenshot 2025-12-19 at 06 46 40" src="https://github.com/user-attachments/assets/d83c7a7e-c3f6-47f3-9171-102d60d45c83" />

#  The following results contain those that are statistically significant 
Based on the psychometric recommendations of Koğar and Koğar (2023), a refined 4-item subscale from the PSS-10 was utilized to further test the relationship between maternal self-efficacy and infant Mental Development score . Results indicated that maternal self-efficacy was a significant predictor of infant MDI scores in a simple linear regression model (beta = -0.87, p = .011) and remained significant in a multiple regression model (beta = -0.84, p = .015), even after controlling for maternal education and log-transformed income per capita. 
<img width="353" height="272" alt="Screenshot 2025-12-19 at 06 48 11" src="https://github.com/user-attachments/assets/36226018-23ac-4add-8287-5cbce05cf601" />
<img width="432" height="269" alt="Screenshot 2025-12-19 at 06 48 29" src="https://github.com/user-attachments/assets/b6e05406-cc69-4fe0-9a31-c02153b913db" />

The graph of the simple linear regression is shown here. 
<img width="540" height="416" alt="Screenshot 2025-12-19 at 06 48 59" src="https://github.com/user-attachments/assets/a573dae8-e342-48e6-919f-3aa80bce5350" />

Further diagnostic testing confirmed the robustness of this finding: residuals were normally distributed as shown by the Q-Q plot, and an analysis of Cook’s Distance (Max D = 0.085) indicated that influential outliers did not drive the results. These findings suggest that maternal psychological perceptions of efficacy may play a small but statistically significant role in affecting early cognitive outcomes.
<img width="500" height="435" alt="Screenshot 2025-12-19 at 06 49 21" src="https://github.com/user-attachments/assets/bb881833-4f0c-4b7b-a88f-ed66dd1251fe" />
<img width="721" height="153" alt="Screenshot 2025-12-19 at 06 49 41" src="https://github.com/user-attachments/assets/b78534de-1d1f-47d2-ad5e-8829193de944" />


