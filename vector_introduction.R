#----------------VECTORS---------------
#vectors are basically a series of data elements of the SAME basic type
#even a single number/character is stored as a vector (of lenghth 1)

myfirstvector <- c(1, 2, 39, 354, 575) #c() combined all the data 
myfirstvector

is.numeric(myfirstvector)
#to check if object is nuumeric
is.integer(myfirstvector)
#will provide false as R stores as double  by default
is.double(myfirstvector)


v2<- c(1L, 2L, 39L, 354L )
#storing values as integers
is.integer(v2)

v3 <- c("a", "b", "1718", "Swathi", 87)
#creating a character vector
is.character(v3)
is.integer(v3)
is.numeric(v3)

#functions

seq() #sequence
rep() #replicate

seq(1,20)
#this function allows an additional parameter: step
seq(1,20, 2)

z <- seq(1, 15, 4)
z

rep(3, 10) #replicating number 3 ten times
rep("a", 50) #replicating a character
rep(z, 5) #replicating a vector

#using the [] brackets

z[2] #to access the second element
z[-3] #to access all but the third element
z1 <- z[-3] #creating a new vector
z1

z[1:3] #accessing the first three elements
z[c(1,4)] #accessing only the first and the fourth 
