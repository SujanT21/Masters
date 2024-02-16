# R Studio

# 7144CEM Principles of Data Science

# The original dataset has 768 rows (500 ‘no diabetes’ and 268 ‘diabetes’).
# We have taken a subset of 200 ‘no diabetes’ cases and 200 ‘diabetes’ cases.
# 400 observations and 8 variables.

########################################################################
# INDIVIDUAL TASK -- Exploratory Data Analysis and  Linear Models (MLO2)
########################################################################


# Install the tidyverse package if not already installed
#install.packages("tidyverse”)
library(tidyverse)

########################################################
# Uncomment below code when extracting the data sample
########################################################

# Setting the seed to ‘733’
#set.seed(733)

# Read Pima Indians Diabetes Dataset as csv file
#data = read_csv('Pima_Indians_Diabetes_Dataset1.csv')
#View(data)

# To take stratified random sampling based on the 'Target' variable
#strata_sample = data %>% 
#  group_by(Target) %>% 
#  slice_sample(n=200) %>% 
#  ungroup()
#View(strata_sample)

# Save the obtained stratified sample
#write_csv(strata_sample, 'PI_Diabetes_Datasample.csv')

# Read PI_Diabetes_Datasample Dataset as csv file and convert to Tibble
strata_sample <- as_tibble(read_csv('PI_Diabetes_Datasample.csv'))

# Install the GGally package if not already installed
#install.packages("GGally")
library(GGally)

# Renaming the 'Target' variable to more understandable categories
strata_sample$Target <- ifelse(strata_sample$Target == 0, "No Diabetes", "Diabetes")
strata_sample$Target <- as_factor(strata_sample$Target)

###########Q No. 01#############

# Creating a scatterplot matrix to visualize relationships among variables
strataSample <- select(strata_sample, -Target)
ggpairs(strataSample)

# Fitting a linear regression model and summarizing its results
x <- strataSample$`Body mass index`
y <- strataSample$`Diabetes pedigree function`
lm_01 = lm(y~x)
summary(lm_01)
AIC(lm_01)


###########Q No. 02(a)#############

# [Add specific code or analysis for Question 02(a) if required]

###########Q No. 02(b)#############

# MODEL #1:

# Fitting a linear model with 'Diabetes pedigree function' as the response and 'Body mass index' and 'Diastolic blood pressure' as predictors
lm_02B_1 = lm(data = strataSample, `Diabetes pedigree function` ~ `Body mass index` + 
                `Diastolic blood pressure`)
summary(lm_02B_1)
AIC(lm_02B_1)

# Install the ggfortify package if not already installed
#install.packages("ggfortify")
library(ggfortify)

# Visualizing the model using ggfortify package
autoplot(lm_02B_1)

# MODEL #2:

# Fitting a linear model with 'Diabetes pedigree function' as the response and 'Body mass index' and 'Triceps skinfold thickness' as predictors
lm_02B_2 = lm(data = strataSample, `Diabetes pedigree function` ~ `Body mass index` +
                `Triceps skinfold thickness`)
summary(lm_02B_2)
AIC(lm_02B_2)

autoplot(lm_02B_2)

# MODEL #3:

# Fitting a linear model with 'Diabetes pedigree function' as the response and multiple predictors including 'Body mass index', 'Diastolic blood pressure', '2-Hour serum insulin', and 'Plasma glucose concentration'
lm_02B_3 = lm(data = strataSample, `Diabetes pedigree function` ~ `Body mass index` +
                `Triceps skinfold thickness` +
                `2-Hour serum insulin` +
                `Plasma glucose concentration`)
summary(lm_02B_3)
AIC(lm_02B_3)

autoplot(lm_02B_3)
