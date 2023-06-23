college <- c("IITM","IITKGP","IITK","IITB","IISC Banglore","CMI","IITR","Others")
value <- c(106,66,95,20,9,11,26)
pie(value,labels = value,radius = 1,cex = 0.4,col = rainbow(length(value)))
legend("bottomleft",cex=0.4,legend = college,fill = rainbow(length(value)))
 nptel <- read.csv("nptel.csv")       
 lev <- levels(factor(nptel$college))
 freq <- numeric(length = length(lev))
for( i in 1:length(lev)){
  k <- subset(nptel,nptel$college==lev[i])
  freq[i] <- nrow(k)
} 
 f <- numeric(length = 31)
for(i in 1:31){
  f[i] <- freq[[i]]
}
 pie(f,labels = f,radius = .7,cex = 0.4,col = rainbow(length(factor(f))),main = "nptel dataset 2022")
 legend("topleft",cex=0.2,legend = lev,fill = rainbow(length(f)),title = "universities offering")
  
 
 
 
 
  