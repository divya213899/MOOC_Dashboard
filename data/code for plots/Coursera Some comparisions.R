dat = read.csv("courses.csv")
alp = read.csv("all_products.csv")
npt = read.csv("nptel.csv")
mrgc = read.csv("merged_courses.csv")


sub = subset(dat,dat$Total.Enrollments<500000 & dat$Total.Enrollments > 1000
             & dat$Total.Ratings > 100)

fac = as.factor(sub$Difficulty)

############ Duration vs No. of Enrollemnts ##########

plot(y =sub$Total.Enrollments, x =sub$Length..Hours.,
     col = fac, pch =16,
     xlab = "Duration (in Hours)",
     ylab = "No. of Enrollments")

legend("topright", col = c(3,4,2,1), 
       legend = unique(sub$Difficulty), pch = 16,
       title = "Difiiculty")


#############

par(mfrow = c(2,2))

j = 0;
for(i in unique(sub$Difficulty)){
  #A little hardcoding to make the color match the previous plot
  j = j+ 1
  { if(j==1) k= 3
    if(j==2) k= 4
    if(j==3) k= 2
    if(j==4) k= 1 }
  sub1 = subset(sub, sub$Difficulty == i)
  plot(y =sub1$Total.Enrollments, x =sub1$Length..Hours.,
       col = k, pch =16,
       xlab = "Duration (in Hours)",
       ylab = "No. of Enrollments",
       xlim = c(0, 80),
       ylim = c(0, 500000),
       main = i)
  
}




############ Duration vs Rating #############



plot(y =sub$Avg..User.Rating, x =sub$Length..Hours.,
     col = fac, pch =16,
     xlab = "Duration (in Hours)",
     ylab = "Average user Rating")

legend("bottomright", col = c(3,4,2,1), 
       legend = unique(sub$Difficulty), pch = 16,
       title = "Difiiculty")



par(mfrow = c(2,2))

j = 0;
for(i in unique(sub$Difficulty)){
  #A little hardcoding to make the color match the previous plot
  j = j+ 1
  { if(j==1) k= 3
    if(j==2) k= 4
    if(j==3) k= 2
    if(j==4) k= 1 }
  sub1 = subset(sub, sub$Difficulty == i)
  plot(y =sub1$Avg..User.Rating,, x =sub1$Length..Hours.,
       col = k, pch =16,
       xlab = "Duration (in Hours)",
       ylab = "Average user Rating",
       xlim = c(0, 80),
       ylim = c(4, 5),
       main = i)
  
}
