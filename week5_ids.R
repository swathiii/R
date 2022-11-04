#DATA MINING 

library(tidyverse)
library(MASS)

install.packages("rgl")

library(rgl)  # A 3D visualization package

#----------------linear regression---------------#

data("hills")
nrow(hills) #checking how many rows the hills dataset has

#dist : The horizontal distance involved in the hill climb
#climb : The vertical distance involved in the hill climb
#time : The record time of the hill climb

#35 rows, we're going to take the first 30 for training and last 5 for testing

hills_train <- hills[1:30,]
hills_test <- hills[31:35,]

#exploring the dataset
hills_train[1:10,]

summary(hills_train)

#the dependent variable we're trying to predict is time ; we're interested in how
#time changes as a function of dist or climb

#first step is to sanity check to look visually at the relationship between
#each of the independent variable and time using ggplot

#scatterplot comparing dist to time
ggplot(hills_train, aes(x=dist, y=time)) + 
  geom_point()

#scatterplot comparing climb to time
ggplot(hills_train, aes(climb, time)) +
  geom_point()

#there appears to be more variation in the relationship between climb and time than between dist and time
#we use cor.test to run a correlation analysis

#for dist
cor.test(
  hills_train$dist,
  hills_train$time
)

#for climb
cor.test(
  hills_train$climb,
  hills_train$time
)

#distance is strongly correlated comparatively ; would capture less of what actually informs the
#outcome(time) if you used climb alone

#---fitting the first linear regression---#

#we use R's lm() function to fit the linear regression model to the data

#fitting a model for using dist to predict time, and saving the model object to a variable
mod_dist <- lm(
  formula = time~dist, #predicting time using dist ; <dependent> ~ <independent>
  data = hills_train
)

summary(mod_dist)

coef(mod_dist) #to just see the coefficients of the model without the additional reporting from summary()

#exercise : fitting a model for using climb to predict time
mod_climb <- lm(
  formula = time~climb,
  data = hills_train
)

summary(mod_climb)
coef(mod_dist)
#R squared is 52%, dist is a better predictor of time

#---inspecting the first linear regression model---#

#geom_point defines a straight line using the slope and intercept, which we'll extract
#using the coef function 

coef_dist <- coef(mod_dist)

ggplot(hills_train, 
       aes(x=dist, y=time)) +
  geom_point() + 
  geom_abline( 
    mapping = aes(
      slope = coef_dist["dist"],
      intercept = coef_dist["(Intercept)"] ),
    color = 'red' )

#to see the remaining variance in more detail, we can graph the residuals of the model
#we first calculate the predicted values and the residuals for each input sample 
#using the predict() and residuals() functions in R

hills_resid <- hills_train #making a copy to leave the original dataset untouched

hills_resid$predicted <- predict(mod_dist)
hills_resid$residuals <- residuals(mod_dist)

hills_resid[1:10,] #shows the data with predicted and residual values

#Bens of Jura has a much larger residual than most of the other points : this 
#suggests it may be an outlier, a point that does not follow the same distribution as the other samples

#illustrating the residuals using the geom_segment command
ggplot(
  hills_resid,
  aes(x=dist, y= time)
) + 
  geom_point(size=3) + #make the actual values show up more clearly
  geom_point(size=2, aes(y=predicted), shape=1) + #show the predicted values --------------???------------wasn't y axis already defind
  geom_segment(aes(xend=dist, yend=predicted), alpha = 0.9, color='red') + #showing the residuals
  geom_abline(mapping=aes(    #defining the straight line
    slope=coef_dist["dist"],
    intercept=coef_dist["(Intercept)"]
  ), 
  color='purple'
  )

#we can plot them much more directly using one of the diagnostic plots that R automatically
#generates for linear regression models. To do so, we'll use the plot() function
#which = 1 indicated which of the diagnostic plots to show, here the residuals

plot(
  mod_dist,
  which = 1
)

#instead of using dist or time directly, this plot graphs the predicted value for ---------------???------------what
#each point against its calculated residual. We can now see that bens of Jura and Knock hill are outliers

#EXERCISE : plot for climb, are the outliers the same?
hills_resid <- hills_train
hills_resid[1:10,]

hills_resid$predicted_climb <- predict(mod_climb)
hills_resid$residuals_climb <- residuals(mod_climb)

coef_climb <- coef(mod_climb)

ggplot(
  hills_resid, aes(climb, time)
) + 
  geom_point(size=3) +
  geom_point(size=2, aes(y=predicted_climb), shape=2)+ #show the predicted values
  geom_segment(aes(xend=climb, yend=predicted_climb), alpha = 0.9, color='red') +
  geom_abline(mapping = aes(
    slope=coef_climb["climb"],
    intercept=coef_climb["(Intercept)"]
  ), color='blue'
  )


plot(
  mod_climb,
  which = 1
)

#the outliers are different : Knock hill, Lairig Ghru and Creag Dubh ------???------there is not that much of a variance for knock hill, why is bens of Jura not mentioned?

?geom_point
#----Making predictions with the linear regression model---#

#we can use R's predict function and we can pass new unseen data to it
predict(
  mod_dist,
  newdata = hills_test
)

#include CI of 95% to get a sense of how reliable these predictions are
predict(
  mod_dist,
  newdata = hills_test,
  interval = 'confidence'
)
#gives us a range of possible values around the estimates with swing of 8-20 minutes estimate either way 

#calculating the residuals now that we have true values, diff between predictions and true values
hills_dist_test <- hills_test #making a copy of the test data 
hills_dist_test$predicted <- predict(mod_dist, newdata=hills_dist_test)
#calculating the residual
hills_dist_test$residuals <- hills_dist_test$predicted - hills_dist_test$time

hills_dist_test

#the predictions are all just about wihtin the 95% confidence interval, so the model fit is pretty strong
#we can graph the residuals to see it in a different way 

ggplot(
  data=hills_dist_test,
  aes(x=dist, y=time)
) +
  geom_point(size=3) +   #make the actual values show up clearly
  geom_point(size=2, aes(y=predicted), shape=2) + #showing the predicted values
  geom_segment(aes(xend=dist, yend=predicted), alpha = 0.9, color='red') + #plotting a line from the predicted value to true value 
  geom_abline(
    mapping=aes(
      slope=coef_dist['dist'],
      intercept=coef_dist['(Intercept)']
    ), color= 'blue' 
  )

#calculating the sum of squared errors to get a single overall number we can use for
#comparing different models in terms of how well they predict the test data
sse_dist <- sum(hills_dist_test$residuals**2)
sse_dist

#EXERCISE : use the climb model to make predictions : how do they compare? are the 
#errors different? what does it tell you about their fit?
mod_climb
hills_climb_test
coef_climb

hills_climb_test <- hills_test
hills_climb_test$predicted <- predict(mod_climb, newdata = hills_climb_test)
hills_climb_test$residuals <- hills_climb_test$predicted - hills_climb_test$time

ggplot(data=hills_climb_test,
       aes(x= climb, y=time)
) +
  geom_point(size=3) +
  geom_point(size = 2, aes(y=predicted), shape = 2) +
  geom_segment(aes(xend=climb, yend=predicted), alpha=0.9, color='red') +
  geom_abline(mapping=aes(
    slope= coef_climb['climb'],
    intercept = coef_climb['(Intercept)']
  ), color='blue')

sse_climb <- sum(hills_climb_test$residuals**2)
sse_climb

#---multi-variate linear regression---#

#a regression with two or more variables
#colinearity : when two variables change in line with each other

#checking dist and climb together(ignoring time for now) to see if they look colinear
ggplot(
  data=hills_train,
  aes(x=dist, y=climb)
) + geom_point()

#there is some relation but a lot of scatter, which means adding them together can be helpful
cor.test(hills_train$dist, hills_train$climb)
#correlation of 0.53 says they're definitely correlated but they're also definitely not perfect 
#predictors of each other

#plotting dist and climb together with time to see how they relate : using rgl library 
library(rgl)
plot3d(
  x=hills_train$dist,
  y=hills_train$climb,
  z=hills_train$time
)
rglwidget()

#training the multivariate regression, we use lm() command but now indicate multiple predictor variables
mod_hills <- lm(
  formula = time~climb+dist,
  data=hills_train
)

#we can still visualize the regression model but now in a 2d plane instead of a line
open3d()

plot3d(
  x=hills_train$dist,
  y=hills_train$climb,
  z=hills_train$time,
  type='s', size=2, col='purple' #show the data points as purple spheres for visibility
)

coefs <- coef(mod_hills)
planes3d(a=coefs["dist"],
         b=coefs["climb"],
         c= -1,
         d=coefs["(Intercept)"], col='grey')
rglwidget()
?planes3d()

#EXERCISE : using predict() method calculate residuals and SSE
#compare it with the single-variable model

plot(
  mod_hills,
  which=1
)

#OR to plot all three side by side
layout(matrix(1:3, ncol=3))
plot(mod_dist, which=1) # dist-based model
plot(mod_climb, which=1) # climb-based model
plot(mod_hills, which=1) 

predict(
  mod_hills,
  newdata=hills_test,
  interval='confidence'
)

hills_final_test <- hills_test
hills_final_test$predicted <- predict(mod_hills, newdata=hills_final_test)
hills_final_test$residuals <- hills_final_test$predicted - hills_final_test$time

hills_final_test

#calculating the SSE
sse_hills_final <- sum(hills_final_test$residuals**2)
sse_hills_final #608.8576

#other factors not included
#in the dataset: weather, fitness, breaks


#---Classification and linear separability---#

#setting up the iris dataset
data("iris")
iris[1:5,]

#to make sure that our training data and test data includes
#samples of all three species, we'll first shuffle the rows

iris <- iris[sample(1:nrow(iris)),] #shuffling the rows of the dataframe in random order
iris[1:5,]

#using 70% of the data for training and 30% for testing [70/30 split]
#separate randomly into training and test data
train_size = 0.7  #using 70% of data for training
iris_train <- iris[1:(train_size*nrow(iris)),]
iris_test <- iris[(nrow(iris_train)+1):nrow(iris),]


#Visualizing data for classification
#with classification the goal is to draw a line that SEPARATES the categories of the data

#to graph the iris dataset using 2 of the 4 independent features : sepal length/width

colors <- c('#1b9e77', '#d95f02', '#7570b3') # colors chosen to be visually una
#mbiguous: see https://colorbrewer2.org/

iris_train_colors <- colors[as.numeric(iris_train$Species)]
shapes <- c('o', '+', 'x')
iris_train_shapes <- shapes[as.numeric(iris_train$Species)]

ggplot(
  data=iris_train,
  aes(x=Sepal.Length, y=Sepal.Width)
) +
  geom_point(color=iris_train_colors, shape=iris_train_shapes, size=5)

#Linear Separability

#for now, we're just going to look at whether the Specie is viginica or not

#-------------??????------------------
binaryColors <- function(data, species) {
  tf_values <- data$Species == species
  color_indices <- as.numeric(tf_values)+1
  return(colors[color_indices])
}

binaryShapes <- function(data, species) {
  tf_values <- data$Species == species
  shape_indices <- as.numeric(tf_values)+1
  return(shapes[shape_indices])
}

#looking at sepal l/w
binarySpecies = 'virginica'

ggplot(
  data = iris_train,
  aes(x=Sepal.Length, y=Sepal.Width)
) +
  geom_point(
    color = binaryColors(iris_train, binarySpecies),
    shape = binaryShapes(iris_train, binarySpecies),
    size=5
  )

#looking at petal l/w
binarySpecies = 'virginica'
ggplot(
  data= iris_train,
  aes(x=Petal.Length, y=Petal.Width)
) +
  geom_point(
    color = binaryColors(iris_train, binarySpecies),
    shape = binaryShapes(iris_train, binarySpecies),
    size = 5
  )

#we note that when using Petal.Length and Petal.Width independent variables,
#we can separate the classes in the data pretty well, these data are (mostly) linearly separable

#EXERCISE : graph the binary class labels for the other two species : setosa and versicolor
#how seperable are these classes? How well would a LM work for classifying these bunary versions of the data

#SETOSA
binarySpecies = 'setosa'
ggplot(
  data=iris_train,
  aes(x=Sepal.Length, y=Sepal.Width)
) +
  geom_point(
    color = binaryColors(iris_train, binarySpecies),
    shape = binaryShapes(iris_train, binarySpecies),
    size = 5
  )

binarySpecies = 'setosa'
ggplot(
  data=iris_train,
  aes(x=Petal.Length, y=Petal.Width)
) +
  geom_point(
    color = binaryColors(iris_train, binarySpecies),
    shape = binaryShapes(iris_train, binarySpecies),
    size = 5
  )

#VERSICOLOR
binarySpecies = 'versicolor'
ggplot(
  data = iris_train, 
  aes(x=Sepal.Length, y=Sepal.Width)
) +
  geom_point(
    color = binaryColors(iris_train, binarySpecies),
    shape = binaryShapes(iris_train, binarySpecies),
    size = 5
  )

binarySpecies = 'versicolor'
ggplot(
  data=iris_train,
  aes(x=Petal.Length, y=Petal.Width)
) +
  geom_point(
    color = binaryColors(iris_train, binarySpecies),
    shape = binaryShapes(iris_train, binarySpecies),
    size = 5
  )

#----LOGISTING REGRESSION - BINOMIAL----#
#predicting a binary(yes/no) variable.

#--Learning the logistic regression model--#
#transforming the iris data to have a binary label for prediction. We'll start by predicting if a given sample is virginica or not 

iris_train$binarySpecies <- iris_train$Species == 'virginica'
iris_train$binarySpecies <- iris_train$binarySpecies * 1 #convert from TRUE/FALSE to 1/0

iris_train[1:10,] #examining data to verify is binaryspecies label was set correctly

#R's glm() function to estimate a logistic regression model based on training data
#it has the same syntax as lm(), also need to specify family argument for the function

?glm()

#start by using petal length/width to predict the class
binarySpecies = 'virginica'

iris_binary_model <- glm(
  binarySpecies ~ Petal.Width + Petal.Length, #predicting the binarySpecies label using petal l/w
  family = binomial(link = 'logit'), #use a logistic regression
  data = iris_train
)

#officially trained my first machine learning model !!

#---Testing and evaluating the logistic regression model---#

binomial_probabilities <- predict(
  iris_binary_model,
  newdata = iris_test,
  type = 'response'
)

print(binomial_probabilities)
#these are the estimated probabilities that each sample is of species virginica, 
#for evaluation purposed, now we need to convert these to discrete labels
#which we'll do by binarizing at 0.5
binomial_predictions <- ifelse(
  binomial_probabilities > 0.5,
  1,
  0
)

print(binomial_predictions)

#we can compare this to our discrete 0/1 true labels, we'll have to evaluate
#the model by accuracy, which is the propotion of test samples where the model
#made the right prediction 

#first, converting the test set labels to binary, like we did for training set
iris_test$binarySpecies <- iris_test$Species == 'virginica'
iris_test$binarySpecies <- iris_test$binarySpecies * 1

iris_test

#now we calculate the error as the number of cases where we did not get the
#right label, and the accuracy as 1 minus that

binomial_classification_error <- mean(
  binomial_predictions != iris_test$binarySpecies
)

print(paste('Accuracy', 1 - binomial_classification_error))
#Accuracy : 0.95 : virginica-petal l/w

#EXERCISE : evaluate the model  using sepal l/w instead of petal l/w

iris_binary_model <- glm(
  binarySpecies ~ Sepal.Width+Sepal.Length,
  family = binomial(link='logit'),
  data = iris_train
)
#testing and evaluating the model
binomial_classification_error <- mean(
  binomial_predictions != iris_test$binarySpecies
)

print(paste('Accuracy', 1 - binomial_classification_error))

#Accuracy : 0.82 : virginica-sepal l/w

#EXERCISE : Binary classification for setosa and versicolor. How do the accuracies
#compare to virginica, does this align to separability

#SETOSA 
#sepal l/w
iris <- iris[sample(1:nrow(iris)),] #shuffling the rows of the dataframe in random order
iris[1:5,]

train_size = 0.7  #using 70% of data for training
iris_train <- iris[1:(train_size*nrow(iris)),]
iris_test <- iris[(nrow(iris_train)+1):nrow(iris),]


binarySpecies = 'setosa'

iris_train$binarySpecies <- iris_train$Species == 'setosa'
iris_train$binarySpecies <- iris_train$binarySpecies * 1 #converting to 1/0

iris_train[1:10,] 


#training the model
iris_binary_model <- glm(
  binarySpecies ~ Sepal.Width + Sepal.Length,
  family = binomial(link = 'logit'),
  data = iris_train
)

#evaluating
binomial_probabilities <- predict(
  iris_binary_model,
  newdata = iris_test,
  type = 'response'
)

binomial_predictions <- ifelse(
  binomial_probabilities > 0.5,
  1,
  0
)

iris_test$binarySpecies <- iris_test$Species == 'setosa'
iris_test$binarySpecies <- iris_test$binarySpecies * 1 

binomial_classification_error <- mean(
  binomial_predictions != iris_test$binarySpecies
)

print(paste('Accuracy', 1 - binomial_classification_error))
#Accuracy : 0.97 

#petal l/w
iris_binary_model <- glm(
  binarySpecies ~ Petal.Width + Petal.Length, #predicting the binarySpecies label using petal l/w
  family = binomial(link = 'logit'), #use a logistic regression
  data = iris_train
)


