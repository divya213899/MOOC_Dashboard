mrgc = read.csv("merged_courses.csv")
tab= table(mrgc$Location)
tab = sort(tab, decreasing = FALSE)
barplot(tab, col = "brown", cex.name =0.46, horiz = TRUE, las =1)
