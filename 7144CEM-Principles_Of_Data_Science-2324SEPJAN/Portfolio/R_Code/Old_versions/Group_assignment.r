# R Studio

# 7144CEM Principles of Data Science

# The original dataset has 768 rows (500 ‘no diabetes’ and 268 ‘diabetes’).
# We have taken a subset of 200 ‘no diabetes’ cases and 200 ‘diabetes’ cases.
# 400 observations and 8 variables.

########################################################
# GROUP TASK -- Multivariate Statistical Analysis (MLO2)
########################################################



# Install the tidyverse package if not already installed
#install.packages("tidyverse”)
library(tidyverse)

# Setting the seed to ‘733’
set.seed(733)

# Read Pima Indians Diabetes Dataset as csv file
data = read_csv('Pima_Indians_Diabetes_Dataset1.csv')
View(data)

# To take stratified random sampling based on the 'Target' variable
strata_sample = data %>% 
  group_by(Target) %>% 
  slice_sample(n=200) %>% 
  ungroup()
View(strata_sample)

# Save the obtained stratified sample
#write_csv(strata_sample, 'PI_Diabetes_Datasample.csv')



##############Factor Analysis##############
# Q.No. 02

# Remove the 'Target' column for further analysis
strata_sample <- select(strata_sample, -Target)
summary(strata_sample)

# Computing correlation matrix
cor <- cor(strata_sample)
View(cor)

# Computing eigenvalues
ev <- eigen(cor)
print(ev$values)

# Performing scree plot analysis
#install.packages("nFactors")
library(nFactors)
NScree = nScree(x = ev$values)
plotnScree(NScree)

# factor analysis without rotation
mlfa1 = factanal(strata_sample, factors = 3, rotation = 'none')
print(mlfa1, sort = T)

# factor analysis with “promax” rotation
mlfa2 = factanal(strata_sample, factors = 3, rotation = 'promax')
print(mlfa2, sort = T)

# factor analysis with “varimax” rotation
mlfa3 = factanal(strata_sample, factors = 3, rotation = 'varimax')
print(mlfa3, sort = T)

#---Extracting loadings, squared loadings, and communalities for analysis—---

lm1 <- loadings(mlfa1)
print(lm1)
sl1 <- lm1^2
communalities1 <- rowSums(sl1)
print(communalities1)

lm2 <- loadings(mlfa2)
print(lm2)
sl2 <- lm2^2
communalities2 <- rowSums(sl2)
print(communalities2)

lm3 <- loadings(mlfa3)
print(lm3)
sl3 <- lm3^2
communalities3 <- rowSums(sl3)
print(communalities3)

# Install the psych package if not already installed
#install.packages("psych")
library(psych)

# Assess sample using the Kaiser-Meyer-Olkin (KMO) measure
KMO(strata_sample)

# Install below packages if not already installed
#install.packages("GPArotation")
#install.packages("paran")
#install.packages("semPlot")
library(semPlot)
library(GPArotation)
library(paran)

#------Performing factor analysis with diagrams using different rotations--------
fa1 = fa(strata_sample, nfactors = 3, rotate = 'none')
fa.diagram(fa1)

fa2 = fa(strata_sample, nfactors = 3, rotate = 'promax')
fa.diagram(fa2)

fa3 = fa(strata_sample, nfactors = 3, rotate = 'varimax')
fa.diagram(fa3)