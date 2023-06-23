library(rvest)
library("tidyr")
edx <- read.csv("edX_Course.csv")
edx <- edx[,-12:-14]
edx <- edx[,-3]
edx$Length <- gsub("Weeks","",edx$Length)
edx$Length <- gsub("hours per week","",edx$Length)
edx$Effort <- gsub("hours per week","",edx$Effort)
edx$Effort <- substring(edx$Effort,3,4)
edx$Effort<- gsub("-","",edx$Effort)
edx$Price <- gsub("USD","",edx$Price)
edx$Price <- gsub("Missing",NA,edx$Price)
edx$Length <- as.integer(edx$Length)
edx$Effort <- as.integer(edx$Effort)
edx$Already.Enrolled <- gsub("Missing",NA,edx$Already.Enrolled)

for( i in 1:nrow(edx)){
  if(is.na(edx$Already.Enrolled[i])){
    tryCatch({
      con <- url(edx[i,1], "rb") 
      pg <- read_html(con)
      
      enroll <- html_elements(pg,".small div")%>%html_text()
      edx$Already.Enrolled[i] <- gsub("already enrolled!","",enroll[1])
      close(con)}, error = function(e){}
      
      
      
    )
    
    
  }
  
  
}



#edx <- complete.cases(edx)
edx_new<- na.omit(edx)

edx_new <- edx_new[-c(270,692),]
index <- which(substring(edx_new[,5],1,1)== "$")
for( i in index){
  edx_new[i,5] <- gsub('[^[:alnum:] ]',"",edx_new[i,5])
  edx_new[i,5] <- as.double(edx_new[i,5])*80.50
}
