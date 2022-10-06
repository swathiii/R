#named vectors
Charlie <- 1:5
Charlie


#give names : names() <- c() 

names(Charlie) <- c("a", "b", "c", "d", "e")
Charlie
#to access number 4 ; should be in double quotes 
Charlie["d"]

#clear names : names() <- NULL
names(Charlie) <- NULL
Charlie

#Naming Matrix Dimensions 1
temp.vec <- rep(c("a", "b", "zZ"), each=3)
temp.vec

Bravo <- matrix(temp.vec, 3, 3)
Bravo

rownames(Bravo) <- c("How", "are", "you")
colnames(Bravo) <- c("X", "Y", "Z")

Bravo

Bravo["are", "Y"]

rownames(Bravo)
colnames(Bravo)
