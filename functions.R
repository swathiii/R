#creating a function called myplot, instead of assigning a vector we assign a function

myplot <- function(data, rows=1:10){      #setting default rows to be displayed if param is not mentioned
Data <- data[rows,,drop=F]
matplot(t(Data), type="b", pch=15:18, col=c(1:4,6))
legend("bottomleft", inset=0.001, legend=Players[rows], col=c(1:4,6), pch=15:18, horiz=F)
}

myplot(1:4)    #by setting row param
myplot(1:6) 

myplot(Salary, 1:3)     #by setting data param

myplot(MinutesPlayed)
myplot(FieldGoals, c(4, 7))     #field goals of 4th and 7th player

myplot(FieldGoals/Games, 1:3)

#-----basketball insights-----

#Salary
myplot(Salary)
myplot(Salary/Games)
myplot(Salary / FieldGoals)

#In-Game Metrics
myplot(MinutesPlayed)
myplot(Points)

#In-Game Metrics Normalized
myplot(FieldGoals / Games)
myplot(FieldGoals / FieldGoalAttempts)
myplot(FieldGoalAttempts / Games)
myplot(Points / Games)

#Interesting Observation
myplot(MinutesPlayed / Games)
myplot(Games)

#Time
myplot(FieldGoals / MinutesPlayed)

#Player Style
myplot(Points / FieldGoals)
