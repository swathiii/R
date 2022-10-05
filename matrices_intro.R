#---------------MATRICES----------------

#In R tables are stored in matrices, a stepping stone to dataframes

#Building a matrix : matrix() : bends a vector to a matrix
#rbind() : connects rows into matrix
#cbind() : connects columnds into matrix

?matrix

mydata <- 1:20
mydata

A <- matrix(mydata, 4, 5) #4 rows and 5 col ; r * c = len(mydata)
A

A[2,3] #accessing element 10

B <- matrix(mydata, 4, 5, byrow=T)
B

#the data bends differently by executing byrow=T

B[2,5] #accessing element 10 

#rbind()

r1 <- c("this", "is", "key")
r2 <- c("what", "a", "day")
r3 <- c(1, 2, 3)

C <- rbind(r1, r2, r3)
C

#Similarly for cbind()

c1 <- c("this", "is", "grey")
c2 <- c("what", "a", "night")
c3 <- c(8, 9, 0)

D <- cbind(c1, c2, c3)
D
