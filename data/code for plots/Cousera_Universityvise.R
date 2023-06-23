library(tidyverse)
mrgc = read.csv("merged_courses.csv")


sub = subset(mrgc, mrgc$Total.Enrollments > 1000
             & mrgc$Total.Ratings > 100)
             

orgy = table(sub$Organiser)
orgy = sort(orgy, decreasing = FALSE)

# orgy = subset(orgy, orgy>13)
n = 30
barplot(orgy[72-n+1:72], col = "brown", cex.name =0.4, horiz = TRUE, las =1)
