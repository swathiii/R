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

#rgdal package to help read shapefiles using readOCR() function
#LSOA : lower-layer super output areas


sheffieldShape <- readOGR( dsn = "./BoundaryData", layer = 'england_lsoa_2011')
#dsn is the directory where shapefile can be found
#layer is the name of shapefile - without the .shp extension

head(sheffieldShape@data, n=2)

head(sheffieldShape@polygons, n=1)

qtm(sheffieldShape) #quick thematic map

#--------MAKING THE PLOT INTERACTIVE-------------------

tmap_mode('view')

qtm(sheffieldShape)

#change parameter to the qtm() to alter the appearance of the map
#if you don't want the shapefile to appear dark, remove the FILL: 
qtm(sheffieldShape, fill = NULL )

#to turn off interactive mapping
tmap_mode('plot')

#-----COLOURING THE THEMATIC MAP--------------------

#directly downloading file7 from URL using read.csv()
deprivation2015 <- read.csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/467774/File_7_ID_2015_All_ranks__deciles_and_scores_for_the_Indices_of_Deprivation__and_population_denominators.csv')

View(deprivation2015)



#selecting some of the columns to work with using select() from tidyverse
library(tidyverse)

deprivation2015pop <- deprivation2015 %>%
  select(LSOA.name..2011.,
         LSOA.code..2011.,
         Total.population..mid.2012..excluding.prisoners.,
         Dependent.Children.aged.0.15..mid.2012..excluding.prisoners.,
         Population.aged.16.59..mid.2012..excluding.prisoners.,
         Older.population.aged.60.and.over..mid.2012..excluding.prisoners.)

#shortening the column names
names(deprivation2015pop)[names(deprivation2015pop) == 'LSOA.name..2011.'] <- 'LSOA_name'
names(deprivation2015pop)[names(deprivation2015pop) == 'LSOA.code..2011.'] <- 'LSOA_code'
names(deprivation2015pop)[names(deprivation2015pop) == 'Total.population..mid.2012..excluding.prisoners.'] <- 'Total_population'
names(deprivation2015pop)[names(deprivation2015pop) == 'Dependent.Children.aged.0.15..mid.2012..excluding.prisoners.'] <- 'Child_population'
names(deprivation2015pop)[names(deprivation2015pop) == 'Population.aged.16.59..mid.2012..excluding.prisoners.'] <- 'MidAge_population'
names(deprivation2015pop)[names(deprivation2015pop) == 'Older.population.aged.60.and.over..mid.2012..excluding.prisoners.'] <- 'Elderly_population' 

head(deprivation2015pop)

#joining the deprivation data frame to existing shapefile using left_join()
sheffieldShape@data <- left_join( sheffieldShape@data, deprivation2015pop,
                                  by = c( 'code' = 'LSOA_code'))

#plotting the map to fill regions in Sheffield based on total population
qtm(sheffieldShape, fill = 'Total_population')

#using fuller map function for plotting data : tm_shape() function
tm_shape(sheffieldShape) +
  tm_fill('Elderly_population', style = 'kmeans', border.col = 'black') +
  tm_borders( alpha = 0.5 ) #alpha controls transparency

#adding alpha parameter to tm_fill() to make the fill transparent

tmap_mode('view') #making the map interactive again

tm_shape(sheffieldShape) +
  tm_fill('Elderly_population', alpha = 0.5, style = 'kmeans', border.col = 'black') +
  tm_borders(alpha = 0.5)

#EXERCISE 
#plot the same map for middle aged population
View(sheffieldShape@data)
tm_shape(sheffieldShape) +
  tm_fill('MidAge_population', alpha = 0.5, style = 'kmeans', border.col = 'black') +
  tm_borders(alpha = 0.5)


#-----FURTHER REFINEMENTS-----------
#we can add more layers since it's based on ggplot2

sheffElderly <- tm_shape(sheffieldShape) +
  tm_fill('Elderly_population', alpha = 0.5, 
          style = 'kmeans', border.col = 'black') +
  tm_borders(alpha = 0.5)

#adding a scale bar to the plot using the tm_scale_bar()
sheffElderly +
  tm_scale_bar() #visible at the bottom right

#adding a compass : set the map mode to plot then add tm_compass()
tmap_mode('plot')

sheffElderly +
  tm_scale_bar() +
  tm_compass( position = c('right', 'top'))

#displaying multiple maps at once using tm_fill()
tmap_mode('view')

tm_shape(sheffieldShape) +
  tm_fill( c('Total_population',
             'Child_population',
             'MidAge_population',
             'Elderly_population'),
           
           title = c('Total population (mid 2012)',
                     'Child population',
                     'Adult population',
                     'Elderly population'),
           
           convert2density = TRUE) +
  tm_borders(alpha = 0.5)

#PLOTTING CRIMES IN SHEFFIELD

crimes <- read.csv('2022-10-south-yorkshire-street.csv', header = TRUE)
View(crimes)

#viewing crimes by a specific LSOA code
crimes %>%
  filter( LSOA.code == 'E01007321')

#we can count the number of crimes in each LSOA
numCrimesbyLSOA <- crimes %>%
  select( LSOA.code, LSOA.name, Crime.type) %>% #selecting the columns we're interested in
  group_by(LSOA.code) %>% #grouping the data by LSOA code
  summarise( Num.crimes = n() ) #countung the number of rows in eacy group using summarise
#and creating a new variable called Num.crimes

numCrimesbyLSOA

#we join this data to the shape file by LSOA code using left_join()
sheffieldShape@data <- left_join(sheffieldShape@data, numCrimesbyLSOA,
                                 by = c( 'code' = 'LSOA.code' ))

#plotting it using qtm() in interactive mode
tmap_mode('view')

tm_shape(sheffieldShape) +
  tm_fill('Num.crimes', alpha = 0.5, 
          style = 'kmeans', border.col = 'black') +
  tm_borders(alpha = 0.5)

#removing the missing data by assigning it a 0 value 
sheffieldShape[ is.na(sheffieldShape@data$Num.crimes) ] <- 0
tm_shape(sheffieldShape) +
  tm_fill('Num.crimes', alpha = 0.5, style = 'kmeans', border.col = 'black') +
  tm_borders(alpha = 0.5)


#---VISUALISATION USING CARTOGRAMS------------------
#cartograms distort a map based on variable

install.packages('cartogram')
library(cartogram)

sheffCarto <- cartogram_cont(sheffieldShape, weight = 'Num.crimes', itermax =  10,
                             prepare = 'adjust')

tm_shape( sheffCarto ) +
  tm_fill('Num.crimes', style = 'jenks', alpha = 0.5 ) +
  tm_borders() +
  tm_layout( frame = F )