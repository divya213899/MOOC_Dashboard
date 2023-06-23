crsr = read.csv("merged_courses.csv")


tab = table(crsr$Difficulty)
tab = sort(tab, decreasng = FALSE)

barplot(tab[c(4,2,1)], col = "brown")
