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
  geom_point(size=2, aes(y=predicted), shape=1)+ #show the predicted values
  geom_segment(aes(xend=climb, yend=predicted), alpha = 0.9, color='purple') +
  geom_abline(mapping = aes(
    slope=coef_climb["climb"],
    intercept=coef_climb["(Intercept)"]
  ), color='red'
)


plot(
  mod_climb,
  which = 1
)

#the outliers are different : Knock hill, Lairig Ghru and Creag Dubh ------???------there is not that much of a variance for knock hill, why is bens of Jura not mentioned?


#----Making predictions with the linear regression model---#