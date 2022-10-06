#visualization with R 

?matplot

#transposing a matric
t(FieldGoals) #because we want to plot the players but the year was in the column 
matplot(t(FieldGoals/Games), type="b", pch=15:18, col=c(1:4,6))
#adding legends 
legend("bottomleft", inset=0.001, legend=Players, col=c(1:4,6), pch=15:18, horiz=F)


matplot(t(FieldGoals/FieldGoalAttempts), type="b", pch=15:18, col=c(1:4,6))
legend("bottomleft", inset=0.001, legend=Players, col=c(1:4,6), pch=15:18, horiz=F)

#Salaries of players through the years
matplot(t(Salary), type="b", pch=15:18, col=c(1:4,6))
legend("bottomleft", inset=0.001, legend=Players, col=c(1:4,6), pch=15:18, horiz=F)

#how many avg minutes each player played per game throughout the season
MinutesPlayed
Games
matplot(t(MinutesPlayed/Games), type="b", pch=15:18, col=c(1:4,6))
legend("bottomleft", inset=0.001, legend=Players, col=c(1:4,6), pch=15:18, horiz=F)

round(MinutesPlayed/Games)
