#------LOGICAL OPERATORS----------

#TRUE T 
#FALSE F

4 < 5
10 > 100

4 == 5

# == equal to 
# != not equal to 
# < 
# > 
# <= 
# >= 
# ! NOT operator
# | OR operator 
# & 
# isTRUE(x)

result <- 4< 5 
result 

typeof(result)

result2 <- !T
result2

example2 <- !(5 > 1)
example2

result | result2 
#returns true as one of them is true 

result & result2 
#returns false as one of them is false 

isTRUE(result) #to check is var is true or not 
isTRUE(result2)

a <- 5 > 6
isTRUE(a)