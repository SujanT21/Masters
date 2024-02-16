
# 7144CEM Principles of Data Science

# This dataset comes from an article in the Journal of Statistics Education
# "Exploring Relationships in Body Dimensions"
# Article: http://jse.amstat.org/v11n2/datasets.heinz.html
# Dataset: http://jse.amstat.org/jse_data_archive.html

# The original dataset has 506 rows (246 males and 260 females).
# I have taken a subset of 40 males and 40 females, but
# deliberately including some outliers in the PCA biplot.
# 80 rows and 12 measurements


#-------------------------------------------------
# GROUP TASK -- Multivariate Statistical Analysis
#-------------------------------------------------

# Reminder: RStudio
# Session Menu / Set Working Directory/ To Source File Location


library(tidyverse)
library(factoextra)
library(ggfortify)

body = read_csv('body_sample.csv')
colnames(body)
dim(body)
View(body)

# Arrange rows by gender then weight
body = body %>%
  group_by(gender) %>%
  arrange(weight) %>%
  ungroup()
View(body)
#---
print('\nGroup Task -- Part (1) PCA -- 7 body girth measurements')

# PCA biplot
body_sub = select(body,-id,-gender)
pca_results = prcomp(body_sub, center=TRUE, scale.=TRUE)
summary(pca_results)
#pca_results1 = princomp(body_sub)
#summary(pca_results1)
# Biplot (with gender as colour)
library(ggfortify)
autoplot(pca_results,
         label=TRUE, label.size=3, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,
         data=body, colour='gender')
# Note: PC1 (64.4%) + PC2 (114.3%) gives us around 80% of variance
scores=pca_results$x
# sub_body[,3] is heigth
a1=cor(body_sub[,3],scores[,1])
a2=cor(body_sub[,3],scores[,2])
# What is the meaning of vectors in biplot
# These are loading for each variables

# Screeplot
var_explained = 100*((pca_results$sd)^2)/(sum((pca_results$sd)^2))
var_explained
cumsum(var_explained)
ggplot(NULL,aes(x=1:10,y=var_explained)) +
  geom_col() +
  ggtitle('Scree plot (10 body girth measurements)') +
  xlab('Principal Component (PC)') +
  ylab('Percentage Variance Explained')
# Note: PC3 (10.1%) 

# Loadings plot
loadings = as.data.frame(pca_results$rotation[,1:7])
loadings
loadings$Symbol = row.names(loadings)
loadings = gather(loadings, key='Component', value='Weight', -Symbol)
ggplot(loadings, aes(x=Symbol,y=Weight)) +
  geom_bar(stat='identity') +
  facet_grid(Component~.) +
  ggtitle('Loadings for PC1-PC4')
# Note: PC1 is some kind of average size of the body
#       PC2 has hip+knee+thigh (positive) and bicep+shoulder+wrist (negative)
#         perhaps a hip/thigh dimension and a shoulder/wrist dimension
#       PC3 has bicep/shoulder/thigh (positive) and ankle/knee/wrist (negative)
#         perhaps a fatty/muscle vs bone dimension

# PC2/PC3
# https://stackoverflow.com/questions/35890459/show-non-default-principal-components-using-autoplot-ggfortify
autoplot(pca_results,x=2,y=3,
         label=TRUE, label.size=3, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,
         data=body, colour='gender')
# VERY interesting, worth commenting

# Could explore gender further with separate PCA biplots for female/male

body_female = filter(body, gender=='f')
body_female_sub = select(body_female,-id,-age,-weight,-height,-gender)
pca_results = prcomp(body_female_sub, scale.=TRUE)
summary(pca_results)
# Biplot (female only)
library(ggfortify)
autoplot(pca_results,
         label=TRUE, label.size=3, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,
         data=body_female, colour='gender')
# Factor Analysis (FA)
#install.packages('nFactors')
library(nFactors)
cor(body_sub)
ev=eigen(cor(body_sub))
Ns=nScree(x=ev$values)
plotnScree(Ns, legend=F)
print(ev$values)
fit1=factanal(body_sub,3, rotation='none')
print(fit1,digits=3,cutoff=0, sort=T)
fit2=factanal(body_sub,3, rotation='varimax')
print(fit2,digits=3,cutoff=0, sort=T)
#fa.diagram(fit1,factors=2)
#install.packages('psych')
#install.packages('GPArotation')
#install.packages('paran')
library(GPArotation)
library(paran)
library(psych)
fit=fa(body_sub, nfactors=3, cutoff=0.5,rotate='varimax')
#t(fit$loadings)
#recon=fit$Loadings%*%t(fit$loadings)+diag(fit$uniquenesses)
KMO(body_sub)
fa.diagram(fit)

#---
print('\nGroup Task -- Part (2) Cluster by person')

# Justify scaling
#install.packages('factoextra')
library(factoextra)
library(cluster)
BBB = scale(body_sub)
D = dist(BBB, method="euclidean")
#cluster_results=hclust(D, method='single')
cluster_results = agnes(D, method='ward')
# "average", "single", "complete", "ward"
plot(cluster_results, which.plots=2,
     main='Cluster by person using 7 girths (Euclidean/Ward)')
#rect.hclust(cluster_results, k=4, border=3)
clusters = cutree(cluster_results, k=4)

# Individuals 1-40 are male and 41-80 are female
# -- look at which individuals are in which clusters, e.g., {31,53}
# -- which of these are outliers on the biplot
# -- which of these are clusters on the biplot
# -- compare distance metrics (manhattan, etc)
#      and clustering methods (single, complete)
# -- aggolmerative coefficient
# -- investigate GENDER effect

print('\nGroup Task -- Part (2) Cluster by measure')

# Justify scaling

BBB = scale(body_sub)
D = dist(t(BBB), method="euclidean")
cluster_results = agnes(D, method='ward')
plot(cluster_results, which.plots=2,
     main='Cluster by measure using 7 girths (Euclidean/Ward)')
clusters = cutree(cluster_results, k=5)
rect.hclust(clusters_results, k=5, border=3)

# {shoulder,bicep,wrist} vs {hip, thigh} vs {knee,ankle}
# -- compare to biplot
# -- include height, weight, age
# -- aggolmerative coefficient
# -- investigate GENDER effect


#------------------------------------------
# INDIVIDUAL TASK -- EDA and Linear Models
#------------------------------------------

library(tidyverse)
body = read_csv('body_sample.csv')
body = select(body,-id)
body = body %>%
  group_by(gender) %>%
  arrange(weight) %>%
  ungroup()
colnames(body)

print('\nIndividual Task -- Part (1) Scatter Matrix')

library(GGally)
ggpairs(body, aes(color=body$gender))


print('\nIndividual Task -- Part (1) Shoulder/Hip')

ggplot(body,aes(x=hip,y=shoulder)) +
  geom_point(aes(colour=gender))
ggplot(body,aes(x=shoulder-hip,colour=gender)) +
  geom_boxplot()
ggplot(body,aes(x=shoulder,colour=gender)) +
  geom_boxplot()
ggplot(body,aes(x=hip,colour=gender)) +
  geom_boxplot()
# Note: seems to be mostly a SHOULDER effect


#---
print('\nIndividual Task -- Part (2) Linear Models (1 predictor)')


library(stats)
library(olsrr)
library(ggfortify)

body_weight = select(body,-age,-height)
colnames(body_weight)
body_height = select(body,-age,-weight)
colnames(body_height)



# Best one-predictor model of weight: bicep
model = lm(weight~bicep, data=body)
summary(model) # R-squared=0.7902
AIC(model)     # AIC=542.43
autoplot(model)

# Best one-predictor model of height: wrist
model = lm(height~wrist, data=body)
summary(model) # R-squared=0.4769
AIC(model)     # AIC=539.991
autoplot(model)


#---
print('\nIndividual Task -- Part (3) Linear Models (AIC and more predictors)')


# WEIGHT

# Best two-predictor model of weight: shoulder+hip
model = lm(weight~., data=body_weight)
summary(model)
ols_step_best_subset(model)
model = lm(weight~shoulder+hip, data=body_weight)
summary(model) # R-squared=0.9166
AIC(model)     # AIC=470.6571
autoplot(model)

# Best four-predictor model of weight
model = lm(weight~gender+shoulder+hip+knee, data=body_weight)
summary(model) # R-squared=0.9496
AIC(model)     # AIC=434.2571
autoplot(model)

# Compare to SUBSET of legs+arms+gender
model = lm(weight~thigh+bicep+knee+ankle+wrist+gender, data=body_weight)
summary(model)
# REMOVE wrist (not significant)
model = lm(weight~thigh+bicep+knee+ankle+gender, data=body_weight)
summary(model) # R-squared=0.9416
AIC(model)     # AIC=448.0835
autoplot(model)


# HEIGHT

# Best two-predictor model of height: wrist+gender
model = lm(height~., data=body_height)
summary(model)
ols_step_best_subset(model)
model = lm(height~wrist+gender, data=body_height)
summary(model) # R-squared=5616
AIC(model)     # AIC=527.8709
autoplot(model)

# Best four-predictor model of height
model = lm(height~gender+bicep+knee+wrist, data=body_height)
summary(model) # R-squared=0.6161
AIC(model)     # AIC=521.2494
autoplot(model)

# Compare to SUBSET of core+gender
model = lm(height~shoulder+hip+gender, data=body_height)
summary(model)
# REMOVE hip (not significant)
model = lm(height~shoulder+gender, data=body_height)
summary(model) # R-squared=0.4864
AIC(model)     # AIC=540.5202
autoplot(model)


#---
print('\nIndividual Task -- Part (4) compare residuals')

# Compare on my SPECIAL plot
model_A = lm(weight~shoulder+hip, data=body_weight)
model_B = lm(weight~thigh+bicep+knee+ankle+wrist, data=body_weight)

# Compare residuals
ggplot(body, aes(x=model_A$residuals, y=model_B$residuals,colour=gender)) +
  geom_point()
cor(model_A$residuals, model_B$residuals) # 0.28 so weak-moderate
# seem to be well-mixed, some outliers but mostly a big cloud

# Customised plot
ggplot(body, aes(x=weight)) +
  geom_point(aes(y=model_A$residuals), shape=2, size=5) +
  geom_point(aes(y=model_B$residuals), shape=16, size=5) +
  geom_segment(aes(x=weight,xend=weight,y=model_A$residuals,yend=model_B$residuals))
# http://environmentalcomputing.net/plotting-with-ggplot-colours-and-symbols/
#   shape=2 is empty triangle, shape=16 is filled circle
# Highlights some residuals are increased, some a decreased.
# Which individuals have the greatest difference in residuals?

# -- the end --

