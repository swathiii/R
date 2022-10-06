#--------SUBSETTING-----------

x <- c("a", "b", "c", "d","e")
x

x[c(1, 5)]
x[1]

Games
Games[1:3, 6:10]

#comparing 1st and 10th player across all years
Games[c(1,10),]

#all games for two specific years
Games[,c(5,6)]

#or

Games[ ,c("2009", "2010")]


Games[1,]
Games[1,5]

#both of them result in a vector which can be checked using is.mattrix()

is.matrix(Games[1,])
is.matrix(Games[1,5])

#they turn in 2D, which turns into a vector.
#R assumed it's vector since you're looking for a one dimensional object 

#to fix that : drop=F : drop is set to true, which drops uneccessary dimensions
#by setting it False (drop=F), we retain the matrix by not dropping any dimension

Games[1,,drop=F]
Games[1,5,drop=F]

is.matrix(Games[1,,drop=F])
is.matrix(Games[1,5,drop=F])

#returns TRUE as it retains dimensions of the matrix