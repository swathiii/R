#---LAW OF LARGE NUMBERS---

rm(counter)
counter <- 0 
for(i in rnorm(1000000)){
  if(i >= -1 & i <= 1){
    counter = counter + 1
  }
}
answer = counter/1000000
answer 