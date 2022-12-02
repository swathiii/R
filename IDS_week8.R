#WEEK 8 - DATA VISUALIZATION WITH R

#-----------------------EXPLORING THE TIME-SERIES DATA--------------------

library(tidyverse)
library(lubridate)

#nycflights13 contains example data that we can use for a time-series graph
library(nycflights13)
flights
View(flights)

#data is spread across columns (year, month, day) : 
#we use make_date() and mutate() to put these in a single column

flightsEdited <- flights %>%
  mutate(date=make_date(year, month, day))

#displaying the mutated column 
flightsEdited %>% select(year, month, day, date) %>%
  head

#displaying the number of flights thata depart NYC each day over time
daily <- flightsEdited %>%
  group_by(date) %>%
  summarise(n=n())

head(daily)

#plotting the flights using ggplot
ggplot(daily, aes(date, n)) +
  geom_line()

#adding columns to show the weekday and month for the date
updatedFlightsEdited <- flightsEdited %>%
  mutate(weekday = wday(date, label = TRUE)) %>%
  mutate(month = month(date, label = TRUE))

updatedFlightsEdited %>% select(year, month, day, weekday) %>%
  head


#EXERCISE : try selecting data just for haniary and compute daily
#number of flights
january <- updatedFlightsEdited %>%
  filter(month == 'Jan') %>%
  group_by(date) %>%
  summarise(n=n())

View(january)

ggplot(january, aes(date, n)) +
  geom_line()

#-------------CREATING A CORRELATION MATRIX------------------------
data("mtcars")
str(mtcars)

#using correlation func : cor() on the entire dataset
mcor <- cor(mtcars)
round(mcor, digits = 2)

#to visualize this : corrplot()
install.packages('corrplot')
library(corrplot)
corrplot(mcor)

#producing a similar correlation plot using : ggcorr() from GGally package
library(GGally)
ggcorr(mtcars)
?cor.test

#exercise 2 : correlation score between cyl and disp 
View(mcor)
#0.9020329


#------------------CREATING A HEATMAP--------------------------------

nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")
head(nba)

#data manipulation to rename index for the rows of the data frame
#to be the player's name (atm its 1, 2,..)
row.names(nba) <- nba$Name
head(nba)

#remove the Name column as we have just used the name to index
#each row in the data frame
nba <- nba[,2:20]

#Finally, converting the DF into a matrix because the heatmap()
#function expects a matrix as the input
nbaMatrix <- data.matrix(nba)

heatmap(nbaMatrix, Rowv = NA, colv = NA, 
        col = heat.colors(256), scale = 'column',
        margins = c(5, 10))


#----------------CREATING A NETWORK GRAPH--------------------------
install.packages('igraph')
library(igraph)

#creating a very simple graph manually by specifying nodes and edges
#as a vector and using the graph() function
gDirected <- graph(c(1,2,  2,3,  2,4,  1,4,  5,5,  3,6))
gDirected

plot(gDirected)

#creating an undirected graph by simply including a parameter 
#to the graph() function
gUndirected <- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6), directed = FALSE)
gUndirected

plot(gUndirected)

#loading dataset netscix2016 : dataset contains examples of 
#network data stored in different ways. The dataset reflect
#media organisations and links between them
nodes <- read.csv('Dataset1-Media-Example-NODES.csv', header = T, as.is = T)
head(nodes)

links <- read.csv('Dataset1-Media-Example-EDGES.csv', header = T, as.is = T)
head(links)

#need to first create a graph based on the links and nodes data frames 
net <- graph_from_data_frame(d = links, vertices = nodes, directed = T)
net

#accessing information about the vertices
#getting a list of all media names in the nodes :
V(net)$media

#similarly for edges : 
E(net)

plot(net, edge.arrow.size = .4, vertex.label = V(net)$media,
     vertex.color = V(net)$media.type)


#-----------CREATING THEMATIC MAPS WITH TMAP-----------------------
#ine of the most common forms of spatial data viz is the use 
#of thematic or choropleth maps, spatial objects are
#represented by polygons which are filled or colored according
#to some variable

install.packages('tmap')
install.packages('rgdal')
library(tmap)
library(rgdal)




