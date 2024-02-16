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
#data <- read_csv('Pima_Indians_Diabetes_Dataset1.csv')
#View(data)

# To take stratified random sampling based on the 'Target' variable
#strata_sample = data %>% 
#  group_by(Target) %>% 
#  slice_sample(n=200) %>% 
#  ungroup()
#View(strata_sample)

# Save the obtained stratified sample
#write_csv(strata_sample, 'PI_Diabetes_Datasample.csv')

strata_sample <- read_csv('PI_Diabetes_Datasample.csv')


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

#---Extracting loadings, squared loadings, and communalities for analysis—---
# factor analysis without rotation
mlfa1 = factanal(strata_sample, factors = 3, rotation = 'none')
print(mlfa1, sort = T)
lm1 <- loadings(mlfa1)
print(lm1)
sl1 <- lm1^2
communalities1 <- rowSums(sl1)
print(communalities1)

# factor analysis with “promax” rotation
mlfa2 = factanal(strata_sample, factors = 3, rotation = 'promax')
print(mlfa2, sort = T)
lm2 <- loadings(mlfa2)
print(lm2)
sl2 <- lm2^2
communalities2 <- rowSums(sl2)
print(communalities2)

# factor analysis with “varimax” rotation
mlfa3 = factanal(strata_sample, factors = 3, rotation = 'varimax')
print(mlfa3, sort = T)
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


###############Cluster Analysis##################
# Q.No. 03
#importing the  library ('cluster') for clustering
library('cluster')

data_clustering <- strata_sample[, 1:8]

# Perform hierarchical clustering with different methods and distance metrics
methods <- c("single", "complete", "average", "ward")
dist_metrics <- c("manhattan", "euclidean")

#The results list is used to store the clustering results.
results <- list()
# By for loop, performing hierarchical clustering for all combinations of methods and distance metrics and stores the results in the 'results' list.
for (method in methods) {
  for (dist_metric in dist_metrics) {
    agnes_result <- agnes(data_clustering, method = method, metric = dist_metric)
    results[[paste(method, dist_metric)]] <- agnes_result
  }
}

# Print and interpret the dendrograms for a selected method and distance metric
selected_method <- "ward"
selected_dist_metric <- "euclidean"
selected_agnes <- results[[paste(selected_method, selected_dist_metric)]]
# Set graphical parameters for a clear and clean plot
par(mfrow=c(1,1), mar=c(6,6,2,2))
# Modify global text size and then plot the dendrogram
par(cex = 0.8)  # Adjust text size here
# Plot the dendrogram with clear labels
plot(selected_agnes, main = paste("Dendrogram - Method:", selected_method, "Distance Metric:", selected_dist_metric), hang = -1)
# Evaluate clustering results (you can use agnes_result$ac to get the agglomerative coefficient)
cat("Agglomerative coefficient:", selected_agnes$ac, "\n")

# Task 1.3 (b) Cluster the diabetes measurements (columns) using a combination of distance metric and hierarchical clustering method
# Define the best distance metric and hierarchical clustering method
best_dist_metric <- "euclidean"
best_method <- "ward"
# Transpose the data to cluster the measurements (columns)
data_transposed <- t(data_clustering)
# Perform hierarchical clustering on the transposed data
best_cluster_result <- agnes(data_transposed, method = best_method, metric = best_dist_metric)
# Plot the dendrogram for feature clustering
par(mfrow=c(1, 1))
plot(best_cluster_result, main = paste("Dendrogram - Method:", best_method, "Distance Metric:", best_dist_metric), hang = -1)

# Evaluate clustering results for feature clustering (agglomerative coefficient)
cat("Agglomerative coefficient for feature clustering:", best_cluster_result$ac, "\n")


