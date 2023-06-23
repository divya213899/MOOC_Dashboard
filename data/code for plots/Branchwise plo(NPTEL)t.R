npt = read.csv("nptel.csv")


branch = "Computer Science and  Engineering"

clgb = subset(npt, npt$disc == branch)

clgws = table(clgb$college)
clgws = sort(clgws, decreasing = FALSE)
barplot(clgws, col = "Brown", las =2, cex.names =0.2, horiz = TRUE,
        xlab = "No. of Courses",
        offset = 0,
        main = paste(c("No. of" , branch , " MOOCs uploaded by each instituiton"), sep = " "))
