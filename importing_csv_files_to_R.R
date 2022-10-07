?read.csv()

#Method 1 :  select the file manually
stats <- read.csv(file.choose())
stats


#Method 2: Set working directory and read data from there 
getwd() #shows which dir you're currently working in

setwd("D:/R") #setting the wd

#importing the csv file from wd (just overwriting stats for now)
rm(stats)
stats <- read.csv("P2-Demographic-Data.csv")


#------------EXPLORING DATASET----

stats

nrow(stats) #number of rows
ncol(stats) #number of columns
head(stats) #gives the top 6 rows
tail(stats) #gives the bottom 6 rows

head(stats, n=9) #gives the first 9 rows
tail(stats, n=3)  #gives the bottom 3 rows

str(stats) #gives the structure of the data frame
summary(stats) #gives a breakdown for every column
