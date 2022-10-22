
#we use dplyr package which is specifically designed for data wrangling
#cheat sheet for commonly used packages: https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

#main functions of dyplyr:
# filter() : Pick observations by their values
# arrange() : Reorder the rows 
# select() : Pick variable by their names
# mutate() : Create new variable with functions of existing variables
# summarise() : Collapse many values down to a single summary

library(tidyverse)
str(mpg) #we will use mpg data set which contains information about cars ; more about mpg : https://rdrr.io/cran/gamair/man/mpg.html

#------------------filtering observations - filter()-----------------------

#filter() : selecting manufacturer Audi 
filter(mpg, manufacturer == "audi") #use == and not = 

#filtering data where the engine displacement is greater than 2
filter(mpg, displ>2)
 
filter(mpg, displ >= 2)

#creating more complex matching conditions using logical operators
#select rows where engine displacement is > 2 and the number of cylinders is > 6
filter(mpg, displ > 2 & cyl > 6)

#selecting Audi cars built in 1999 
filter(mpg, manufacturer == "audi" & year == 1999)
#or
filter(mpg, manufacturer == "audi", year == 1999)

#EXERCISE : 1) manufacturer is Audi OR the year of production is 1999? 
# 2) year of production is 1999 and not manufacturer is NOT Audi

#1)
filter(mpg, manufacturer == "audi" || year == 1999)
#OR
filter(mpg, manufacturer == "audi" | year == 1999)
#Doubt : they yield different results, what's the difference?

#2)
filter(mpg, year == 1999 & manufacturer != "audi")

#checking Audi or Chevrolet from 1999
filter(mpg, (manufacturer== "audi" | manufacturer == "chevrolet"), year==1999)
#-----------to simply this using %in%--------------#
filter(mpg, (manufacturer %in% c("audi", "chevrolet")), year == 1999)

#sample_frac() to select a random sample of observations or rows
sample_frac(mpg, 0.05, replace = TRUE) #to sample 5% of the data


#----------------Reordering rows - arrange()------------------

rio2016medals <- read_csv("Rio2016.csv")

arrange(rio2016medals, Country)

arrange(rio2016medals, desc(Country))

#rearranging multiple columns

arrange(rio2016medals, desc(Gold), desc(Silver), desc(Bronze))
#here, when we have the same number of gold medals (e.g. from row 9 and 10) then the data is sorted by number of Silver medals. 

#EXERCISE : pipe the results of the arrange function into the function view to better view the ordered tibble

View(arrange(rio2016medals, desc(Gold), desc(Silver), desc(Bronze) ) )


#---------------Selecting columns - select()-----------------

#selecting manufacturer and highway fuel efficiency columns
select(mpg, manufacturer, hwy)

#helper functions that can be used with the subset() function and used for selecting columns
select(mpg, starts_with("d")) #selecting columns that start with d

#we can pipe select() and filter() using %>% to filter out rows and columns
select(mpg, manufacturer, hwy) %>% filter(manufacturer=="chevrolet" & hwy >= 20)

#we can combine command using %>% to also arrange the data
select(mpg, manufacturer, hwy) %>%
  filter(manufacturer != "chevrolet" & hwy >= 20) %>%
  arrange(desc(manufacturer))
#functions can work without specifying the data is they are part of a pipe chain
#we can also start with your data and then chain all the functions, example:
mpg %>%
  select(manufacturer, hwy) %>%
  filter(manufacturer != "chevrolet" & hwy >= 20) %>%
  arrange(desc(manufacturer))

#---------------Creating new variables - mutate()-----------------

#mutate() allows making new variables that are typically based on existing variables

mutate(rio2016medals, Total = Gold + Silver + Bronze) #similar to rowSums

#if you want to save the new column, you will have to save the mutate to a new variable
#if you create a column with the same name as an already existing one, it will overwrite the existing one

#---------------Collapse many values down to a single summary - summarise()---------------#

#summarise() allows to summarise data into a single row of values
summarise(mpg, avg=mean(hwy))

#summarise() function is paired with the group_by() function - like mutate, it creates a new col

group_by(mpg, year, manufacturer) %>% summarise(count=n())

#using group_by and summarise() together to count the number of rows we have for each manufacturer using the n()
group_by(mpg, manufacturer) %>%
  summarise(count=n())

#EXERCISE: 
#1) How many unique models do each manufacturer produce? 
mpg
test<- group_by(mpg,model, manufacturer) %>%
  summarise(count=n())
  
View(test)

solution <- group_by(test, manufacturer ) %>%
  summarise(count=n())

View(solution)

#2 ratio of hwy and cty as hwyctyratio

mutate(mpg, hwyctyratio = hwy/cty) %>%
  select(manufacturer, hwyctyratio)