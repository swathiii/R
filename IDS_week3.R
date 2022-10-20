library(MASS)
#loading a very simple dataset
data("women")
women

summary(women)
#plotting the distribution of the continuous variable
hist(women$height)
hist(women$weight)

#changing the looks of the histogram
hist(x=women$height, breaks = 4, main= "Histogram showing women's heights", xlab = "Height")

#breaks sets the values at which the data is grouped and not the number of bins
par(mfrow=c(1,2)) #mfrow to say we want to display any plots generated after each other in rows and columns (in this case, one row and two columns)
hist(x=women$height, breaks = 4, main= "Histogram showing women's heights", xlab = "Height")
hist(x=women$weight, breaks = 4, main= "Histogram showing women's weights", xlab = "Weight")

#using scatterplot to explore the relationship between height and weight
plot(women)


#packages in R

installed.packages() #displays all the packages that has already been installed
View(installed.packages())

library(tidyverse) #the package centres around the idea of handling data in a tidy way


#importing datasets

#data() to call the dataset : data(dataset_name)

library(tidyverse)

#loading a .tsv file
testfile <- read_tsv("test.tsv")
#readr package is a part of tidyverse : functions for importing and exporting data
#it is fast to execute provides a more coherent set of parameters. Also provides loading bars if the file is very large

testfile

#to make it ignore the header, col_name tp False, or  provide a vector of three names
testfile <- read_tsv("test.tsv", col_names = FALSE)


#loading a .csv file

testcsvfile <- read_csv("freeschoolmeals.csv", col_types = "cciici")
testcsvfile
#col_types imposes the data type of each column where each character defines the data type

#loading an excel file
library(readxl) #read-XL and not X1
excelfile  <- file.path("indicator hiv estimated prevalence% 15-49.xlsx")
testexcelfile <- read_excel(excelfile, sheet="Data")

head(testexcelfile)

#importing text files into R using the readtext package

install.packages("readtext")
#readtext : package with good single set of functions for importing various kinds 
#of (textual) data in a uniform way which is saved as a data frame
library(readtext)

txt <- readtext("http://ir.shef.ac.uk/cloughie/download/inaugral.txt")
str(txt)

#reading HTML and XML data with rvest
install.packages("rvest")
library(rvest)

url <- "https://en.wikipedia.org/wiki/Sheffield"
wikipage <- read_html(url)

wikipage

#to get all the content from the HTML for heading 2 (<h2) tags

h2Sections <- wikipage %>%
  html_nodes("h2") 
h2Sections

#to get the content of the page, select all of the content which is marked using <p>
#(paragraph) tags using the html_nodes() function as follows
pageText <- wikipage %>%
  html_nodes("p") %>%
  html_text()

#each paragraph is now stored in pageText, we can access it using std list notation

pageText[1] #to access just the first paragraph
pageText[2]

#useful tutorials 
#https://uc-r.github.io/scraping_HTML_text
#https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/
#https://www.datacamp.com/community/tutorials/r-web-scraping-rvest


#Reading JSON files (from APIs) with the jsonlite package

install.packages("jsonlite")
library(jsonlite)

#JSON files are just text files that allow you to encode data all into one object

json <-
  '[
{"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"},
{"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"},
{},
{"Name" : "Bowser", "Occupation" : "Koopa"}
]'

mydf <- fromJSON(json)
mydf

#converting R data structures into JSON which is very convenient for then sharing your R objects
myjson <- toJSON(mydf)
myjson

#tutorial : : https://cran.rproject.org/web/packages/jsonlite/vignettes/json-apis.html