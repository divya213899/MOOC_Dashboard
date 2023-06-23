npt = read.csv("nptel.csv")


iitk = subset(npt, npt$college == "IIT Kanpur")

C= table(iitk$disc)
C = sort(C, decreasing = FALSE)
barplot(C, col = "brown", las =2, cex.names =0.2, horiz = TRUE,
        xlab = "No. of Courses",
        offset = 0,
        main = "IITK MOOCs on NTPEL departmentwise")

all = table(npt$disc)
all = sort(all, decreasing = FALSE)
barplot(all, col = "Brown", las =2, cex.names =0.2, horiz = TRUE,
        xlab = "No. of Courses",
        offset = 0,
        main = "All MOOCs on NTPEL departmentwise")

clgws = table(npt$college)
clgws = sort(clgws, decreasing = FALSE)
barplot(clgws, col = "Brown", las =2, cex.names =0.2, horiz = TRUE,
        xlab = "No. of Courses",
        offset = 0,
        main = "No. of MOOCs uploaded by each instituiton")