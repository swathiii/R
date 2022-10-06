#-------------MATRIX OPERATIONS----------------

Games
rownames(Games)
colnames(Games)

Games["LeBronJames", "2012"] #instead of counting what index the values are in

FieldGoals

#to find out how many field goals every player scored per game
FieldGoals / Games
round(FieldGoals / Games) #rounding the values 

round(FieldGoals / Games, 1) #rounding upto 1 decimal point

#how many minutes each player played in every single one of these seasons
round(MinutesPlayed / Games)

round(FieldGoals/FieldGoalAttempts)
FieldGoalAttempts/FieldGoals
