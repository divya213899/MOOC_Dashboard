edx = read.csv("edX_Course.csv")


tab = table(edx$Level)
tab = sort(tab, decreasng = FALSE)

barplot(tab[14:12], col = "brown")
