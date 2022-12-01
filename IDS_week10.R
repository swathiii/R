#----------SETTING UP THE DATASET-------------------------

raw_data <- read.delim("bsa2019_poverty_open.tab", header = TRUE,
                   sep = "\t", quote = "" )

data <- read.delim("bsa2019_poverty_open.tab", header = TRUE,
                   sep = "\t", quote = "" )
#installing plyr to allow us to run counts
install.packages("plyr", repos="http://cran.case.edu/")
library(plyr)

#exploring the dataset

head(data)
View(data)

count(data, vars = 'skipmeal')
nrow(data)
ncol(data)
summary(data)


#------------PREPARING THE DATA FOR ANALYSIS----------------------
#missing values : -1 (<0 ) and values > 7
#tag them as NA and remove them when applicable 

data2 <- data
View(data2)

count(data2, vars = 'skipmeal')

#tagging -1 as NA
data2$skipmeal[ data2$skipmeal < 0 ] <- NA

#removing the row containing NA values 
data2 <- na.omit(data2)
nrow(data2)


#focusing on how different results break down by respondents age
#variable that reports respondents' age : 
head(data$RAgeCat)

#missing values are : -1, 8
count(data, vars = 'RAgeCat')

#setting them as NA and removing the rows 
data$RAgeCat[ data$RAgeCat > 7] <- NA
data <- na.omit(data)

nrow(data)

hist(data$RAgeCat)
#its not an even distribution 

#to breakdown the results by only 4 age groups
#re scale variables from 
# 1 = 18-34   (group 1 and 2)
# 2 = 35-54   (group 3 and 4)
# 3 = 55-64   (group 5 and 6)
# 4 = 65 +    (7)

data2 <- data
data2$RAgeCat[ data2$RAgeCat > 7 ] <- NA
data2 <- na.omit(data2)

count(data2, vars = 'RAgeCat')

data2$RAgeCat[ data2$RAgeCat < 3] <- 1
data2$RAgeCat[ (data2$RAgeCat > 2) & (data2$RAgeCat < 5) ] <- 2
data2$RAgeCat[ (data2$RAgeCat > 4) & (data2$RAgeCat < 7) ] <- 3
data2$RAgeCat[ data2$RAgeCat > 6 ] <- 4

hist(data2$RAgeCat)
#it does not look more or less even than before?


#------------EXPLORATORY DATA ANALYSIS-----------------------------

#finding correlation between age and education level

#find education level : drop rows with missing values
count(data2, vars = 'HEdQual3')

#missing value : 8 
data2$HEdQual3[ data2$HEdQual3 == 8] <- NA
head(data2$HEdQual3)

nrow(data2)

#removing NA values in HEdQual3
data2 <- na.omit(data2)

#matrix : row is Age and Columns are Educational Level 
table(data2$RAgeCat, data2$HEdQual3)


#perform Chi-square test : p-val, H0
#H0 : there is no correlation between Age and Education Level
?chisq.test

chisq.test(table(data2$RAgeCat, data2$HEdQual3))
#x-squared = 409.81
#df = 9
# p-value < 2.2e-16  ;  p is essentially < 0.05 
#we can reject H0 and state that there is a significant 
#correlation between Age and Education 

#------EXTRA--------
library(tidyverse)
library(corrplot)

#plotting correlation 
corr <- cor(data2)
corrplot(corr)

library(GGally)
ggcorr(data2)

View(corr)

cor.test(data2$RAgeCat, data2$HEdQual3)
#correlation score between education and age is 0.30018842


#--------------------DEVELOPING PREDICTIVE MODELS-------------------
data3 <- raw_data

#-------NatFrEst : 
count(data3, vars = 'NatFrEst')
count(data3, vars = 'eq_inc_quintiles')

#missing data : 998 and 999 and -1 
data3$NatFrEst[ data3$NatFrEst == 998 ] <- NA
data3$NatFrEst[ data3$NatFrEst == 999 ] <- NA
data3$eq_inc_quintiles[ data3$eq_inc_quintiles < 0 ] <- NA

library(tidyr)
data3 <- data3 %>% drop_na()

#removing the missing values from NatFrEst and eq_inc_quintiles
data3 <- na.omit(data3)


#train the linear regression model to predict NatfrEst using these
#variables : libauth, leftrigh, welfare2, Politics and eq_inc_quintiles

nrow(data3) 
#there's 2144 rows in total 

#I will split the model 80 : 20 
#1716 rows for training and 428 remaining rows to test the model

data3_train <- data3[ 1: 1716, ]
data3_test <- data3[1717 : 2144, ]

data3_train[1:5, ]

summary(data3_train)

?lm()

model_natfrest <- lm(
  formula = NatFrEst ~ libauth + leftrigh + welfare2 + Politics + eq_inc_quintiles,
  data = data3_train
)

summary(model_natfrest)
#Residual standard error: 24.48 on 1710 degrees of freedom
#Multiple R-squared:  0.1454,	Adjusted R-squared:  0.1429 
#F-statistic: 58.17 on 5 and 1710 DF,  p-value: < 2.2e-16


#model only using libauth + leftrigh + welfare2
model2_natfrest <- lm(
  formula = NatFrEst ~ libauth + leftrigh + welfare2,
  data = data3_train
)

summary(model2_natfrest)
#Residual standard error: 25.72 on 1712 degrees of freedom
#Multiple R-squared:  0.05526,	Adjusted R-squared:  0.05361
#F-statistic: 33.38 on 3 and 1712 DF,  p-value: < 2.2e-16

