#vectorized operations 

x <- rnorm(5)
x

#to print everything one after another
#R-specific programming loop
for(i in x){
  print(i)
}

#conventional programming loop
for(j in 1:5){
  print(x[j])
}

#----------vectorized vs devectorized---------------

N <- 100
a <- rnorm(N)
b <- rnorm(N)

#vectorized approach

c <- a * b 

#devectorized approach 

d <- rep(NA,N) #creating an empty vector

for( i in 1:N ){
  d[i] <- a[i] * b[i]
}

#------functions in R------------

#functions so far

rnorm()
?seq()
?rep()
isTRUE()
is.numeric()
c() #combine
print()
typeof()
sqrt()
paste()

#? before a func gives full information 

?rnorm()
