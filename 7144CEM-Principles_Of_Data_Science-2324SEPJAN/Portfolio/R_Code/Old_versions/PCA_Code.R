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


#########Principal Component Analysis##############

# Q.No. 01

# Assign labels "No Diabetes" and "Diabetes" to a new 'class' variable based on the 'Target' variable
pca_sample <- strata_sample
pca_sample$class <- ifelse(pca_sample$Target == 0, "No Diabetes", "Diabetes")
strata_sub = pca_sample[,1:8]


# 1. Principal Component Analysis on first 8 input variables
pca_results = prcomp(strata_sub, center=TRUE, scale.=TRUE)
summary(pca_results)

# Variance explained by each principal component and cumulative percentage of variance explained
var_explained = 100*((pca_results$sd)^2)/(sum((pca_results$sd)^2))
var_explained
cumsum(var_explained)

# 1(a). Screeplot using ggplot
ggplot(NULL,aes(x=1:8,y=var_explained),ncp=5) +
  geom_col() +
  geom_line() +
  geom_hline(yintercept = 0, color = "gray", linetype = 2) +
  geom_vline(xintercept = 0, color = "gray", linetype = 2) +
  geom_bar(stat = "identity" ,fill = "skyblue" ) +
  geom_text(aes(label = round(var_explained, 2), vjust = -0.5)) +
  ggtitle('Scree plot - Pima Indians Diabetes (8)') +
  xlab('Principal Component (PC)') +
  ylab('Percentage Variance Explained')

# Loadings plot for the first three principal components
loadings = as.data.frame(pca_results$rotation[,1:3])
loadings
loadings$Symbol = row.names(loadings)
loadings = gather(loadings, key='Component', value='Weight', -Symbol)
ggplot(loadings, aes(x=Symbol,y=Weight)) +
  geom_bar(stat='identity',fill = "skyblue") +
  facet_grid(Component~.) +
  ggtitle('Loadings for PC1-PC3')

# Biplot with labels and loadings for PC1 and PC2 as axes
#install.packages("ggfortify")
#install.packages("ggplot2")
library(ggfortify)
library(ggplot2)
autoplot(pca_results,
         label=TRUE, label.size=3, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,
         data=pca_sample, colour='class') +
  ggtitle("Biplot of PCA Results - PC1/PC2")


# 1(b). Biplot with labels and loadings for PC2 and PC3 as axes
autoplot(pca_results,x=2,y=3,
         label=TRUE, label.size=3, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,
         data=pca_sample, colour='class') + 
  ggtitle("Biplot of PCA Results - PC2/PC3")


