
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


#------------------combining datasets------------------------#

install.packages("nycflights13")
library(nycflights13)

nycflights13::airlines

# :: is the R way of identifying functions within a package, we can also view other datasets
nycflights13::airports
nycflights13::flights

#dropping unimportant variables to make it easier to understand the join results
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
flights2

#we will join flights2 with the airlines table using left_join()

flights2 %>%
  left_join(airlines, by="carrier")

#left_join is an example of a mutating join
#a mutating join allows you to combine variables from two tables. It first matches observations by their keys, then copies across variables from one table to the other.


#----------------------working with real data---------------------#


meals <- read_csv("freeschoolmeals.csv", col_types = "cciici")
View(meals)

#about the dataset: https://www.data.gov.uk/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/free-school-meals
#9999 is a fake value, cannot treat it as an actual value

#to see the effects of missing data - NA
summary(meals$FSMTaken)
mean(meals$FSMTaken)
#doesn't work as there are missing values, to counter this : 
mean(meals$FSMTaken, na.rm=TRUE) 
#na.rm=TRUE parameter says remove any NA values when computing the mean
#the value is still very high as it considers 9999 as a real value

length(meals$FSMTaken)

actualFSMTaken <- meals$FSMTaken[meals$FSMTaken != 9999]
length(actualFSMTaken) #we have 206/250 rows

#using dplyr
filter(meals, FSMTaken<9999)
filter(meals, FSMTaken<9999) %>%
  count() #we have 189/250 rows 

#different bc filter also removed the data with NA values, to keep NA values :
filter(meals, (FSMTaken<9999 | is.na(FSMTaken))) %>%
  count()
#this says filter and return values of FSMTaken that are less than 9999 OR where the value is NA

#instead of ignoring NA, we can replace it with mean values, example: 
y <- c(4, 5, 6, NA)
is.na(y)

y[is.na(y)] <- mean(y, na.rm=TRUE)
y

#to do this on our actualFSMTaken vector
actualFSMTaken[is.na(actualFSMTaken)] <- floor(mean(actualFSMTaken, na.rm=TRUE))
#the floor function is useful to transform the mean value from double to an integer so there is no mismatch over values

#using dply to add a new column to the dataset instead of assigning the corrected value to a vector
meals2 <- filter(meals, (FSMTaken<9999 | is.na(FSMTaken))) %>%
  mutate(newFSMTaken=ifelse(is.na(FSMTaken), floor(mean(FSMTaken, na.rm=TRUE)), 
                            FSMTaken)) #else use the original FSMTaken value

View(meals2)

#EXERCISE : consider the values 9999 to be 4 and calculate mean, do the same for 0
#1) Value 4
meals3 <- mutate(meals, newFSMTaken = ifelse(FSMTaken == 9999, 4,
                                             FSMTaken))
View(meals3)

mean(meals3$newFSMTaken, na.rm=TRUE)
#mean is 25.01388

meals3 <- mutate(meals, newFSMTaken = ifelse(FSMTaken == 9999, 0,
                                             FSMTaken))

#mean is 24.25751
