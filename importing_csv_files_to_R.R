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


