# import dependencies
library(shiny)
library(ggplot2)
library(gridExtra)

# set working directory to location of file and load Rdata object
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("dat.Rdata")

# begin UI function
ui <- fluidPage(
  
  # Application title
  titlePanel("MOOC Analysis Dashboard"),
  
 
  sidebarLayout(
    sidebarPanel(
      # select platform to analyse
      selectInput(
        "platform",
        "Platform",
        c("Comparisons" = "Y", "NPTEL" ="N", "Coursera" = "C", "edX"= "X")
      ),
      uiOutput("app"),
      
      uiOutput("params")
    ),
    

    mainPanel(
      tabsetPanel( type = "tabs",
                   tabPanel("Plot",
                            plotOutput("main")
                   ),
                   
                   
                   tabPanel("Table",
                            tableOutput("table")
                   )
      )
    )
  )
)



#begin server function
server <- function(input, output) {
  
  # reactive UI component: changes according to input of platform
  output$app <- renderUI({
    # X = edx
    if(input$platform == "X"){
      selectizeInput(
        "factor", "Plot",
        c("Violin plots" = "violin", "Courses by subject" = "sbj")
      )
    }
    # N= nptel
    else if(input$platform == "N"){
      
      selectizeInput(
        "factor",
        "Frequency Analysis of",
        c("Institutes"="Sub", "Subjects"="Ins")
      )
    }
    # C= coursera
    else if(input$platform == "C"){
      selectizeInput(
        "factor",
        "Feature",
        c("Buzzword Analysis"="bzw", "Institutes Analysis"= "ins")
      )
    }# Y = comparison of diff plateform
    else if(input$platform == "Y"){
      selectizeInput(
        "factor",
        "Compare",
        c("Difficulty distribution" = "diff", "Top MOOC contributors" = "top", "Subjectwise distribution" = "subj")
      )
    }
  })
  
  output$params <- renderUI({
    
    if(input$platform == "N"){
      # sub = institutes
      if(input$factor == "Sub"){
        selectizeInput(
          "subject",
          "Subject",
          # colleges in nptel
          c("All", nptel$disc)
        )
      }
      else{
        selectizeInput(
          "institute",
          "Institute",
          c("All", nptel$college)
        )
      }
    }
    else if(input$platform == "C"){
      if(input$factor == "ins"){
        tagList( # decieding no. of institutes to display 
          sliderInput("no", "Number",
                      min = 0, max = 40, value = 20
          ),
          
          numericInput(
            "ratings",
            "Min no. of ratings",
            value = 100
          ),
          #input to choose range of no. of enrolments
          numericInput(
            "enr",
            "Min no. of enrolments",
            value = 1000
          )
        )
      } # bzw = buzzwordAnalysis
      else if(input$factor == "bzw"){
        tagList(
          textInput("buzzword",
                    "Buzzword",
                    value = "Data"
          ), # to choose diffculty level , bydefault = All
          checkboxGroupInput(
            "diff",
            "Difficulty",
            choices= c("All" = "all", "Beginner" = "Beginner", "Intermediate" = "Intermediate", "Advanced" = "Advanced"),
            selected = c("all")
          ),
          numericInput(
            "ratings",
            "Ratings threshold",
            value = 100
          ),
          # user input to deciede range of enrolments
          sliderInput("enrol", label = "Enrolments Range", min = 0, 
                      max = 1000000, value = c(10, 500000))
        )
      }
    }
  })
  
  
  # table for displaying data of plot
  output$table <- renderTable({
    
    if(input$platform == "N"){
      if(input$factor=="Ins"){
        if(input$institute == "All"){
          all = table(nptel$disc)
          all = sort(all, decreasing = T)
          all
        }
        else{
          iitk = subset(nptel, nptel$college == input$institute)
          C= table(iitk$disc)
          C = sort(C, decreasing = T)
          C
        }
      }
      else{
        if(input$subject == "All"){
          clgws = table(nptel$college)
          clgws = sort(clgws, decreasing = T)
          clgws
        }
        else{
          # all institutes with selected subject
          a <- subset(nptel, nptel$disc == input$subject)
          clgws = table(a$college)
          clgws = sort(clgws, decreasing = T)
          clgws
        }
      }
    } # mrgc = coursera dataset
    else if(input$platform== "C" & input$factor == "bzw"){
      subs <- subset(mrgc, grepl(input$buzzword, mrgc$Name) & mrgc$Total.Ratings > input$ratings & mrgc$Total.Enrollments >= input$enrol[1] & mrgc$Total.Enrollments <= input$enrol[2])
      if(!("all" %in% input$diff)){
        subs = subset(subs, subs$Difficulty %in% input$diff)
      }
      subs <- subs[order(subs$Total.Enrollments, decreasing = T),]
      subs[,c(5, 6, 7, 8, 9, 10, 11)]
    }
    else if(input$platform == "C" & input$factor == "ins"){
      sub = subset(mrgc, mrgc$Total.Enrollments > input$enr
                   & mrgc$Total.Ratings > input$ratings)
      
      orgy = table(sub$Organiser)
      orgy = sort(orgy, decreasing = TRUE)
      
   
      n = input$no
      orgy[1:n]
    }
    else if(input$platform == "X"){
      if(input$factor == "sbj"){
        sort(table(edx$Subject), decreasing = T) 
      }
    }
    
    
  })
  
  output$main <- renderPlot({
    
    #plots
    if(input$platform == "Y"){ # Comparison mode
      if(input$factor == "diff"){ # compare difficulty distribution
        
        # coursera diffulty distribution
        tab = table(mrgc$Difficulty)
        tab = as.data.frame(sort(tab, decreasing = FALSE))
        p1 <- ggplot(tab, aes(Var1, Freq, fill = Var1))+ geom_bar(stat = "identity", show.legend = F)+
          labs(title= "Coursera difficulty distribution", x ="Difficulty", y = "No. of courses" )
        
        #edx diff. distribution
        tab1 = table(edx$Level)
        tab1 = as.data.frame(sort(tab1, decreasing = FALSE))
        p2 <- ggplot(tab1, aes(Var1, Freq, fill = Var1))+ geom_bar(stat = "identity", show.legend = F)+
          labs(title= "edX difficulty distribution", x ="Difficulty", y = "No. of courses" )
        
        #plotting side by side
        grid.arrange(p1, p2, nrow = 1)
        
      }
      else if(input$factor == "top"){ #top MOOC contibutors
        #comparison of plots: institutes vs no. of courses offered
        tab = table(mrgc$Organiser)
        tab = as.data.frame(sort(sort(tab, decreasing = TRUE)[1:10], decreasing = FALSE))
        p1 <- ggplot(tab, aes(Var1, Freq, fill = Var1))+ geom_bar(stat = "identity", show.legend = F)+
          labs(title= "Coursera top MOOC organisers", x ="Institution", y = "No. of courses" )+ coord_flip()
        
        
        tab2 = table(edx$Institution)
        tab2 = as.data.frame(sort(sort(tab2, decreasing = TRUE)[1:10], decreasing = FALSE))
        
        p2 <- ggplot(tab2, aes(Var1, Freq, fill = Var1))+ geom_bar(stat = "identity", show.legend = F)+
          labs(title= "edX top MOOC organisers", x ="Institution", y = "No. of courses" )+
          coord_flip()
        
        tab3 <- table(nptel$college)
        tab3 <- as.data.frame(sort(sort(tab3, decreasing = TRUE)[1:10], decreasing = FALSE))
        
        p3 <- ggplot(tab3, aes(Var1, Freq, fill = Var1))+ geom_bar(stat = "identity", show.legend =F)+
          labs(title= "NPTEL top MOOC organisers", x ="Institution", y = "No. of courses" )+
          coord_flip()
        
        # all plots togethere
        grid.arrange(p1, p2, p3, nrow = 3)
        
      }
      # subjectwise distibution
      else if(input$factor == "subj"){
        #for edx
        tab2 = table(edx$Subject)
        
        #sorting according to decreasing order of courses offered
        tab2 = as.data.frame(sort(sort(tab2, decreasing = TRUE)[1:10], decreasing = FALSE))
        
        p2 <- ggplot(tab2, aes(Var1, Freq))+ geom_bar(stat = "identity", show.legend = F)+
          labs(title= "edX top subjects", x ="Subject", y = "No. of courses" )+
          coord_flip()
        
        #for nptel
        tab3 <- table(nptel$disc)
        tab3 <- as.data.frame(sort(sort(tab3, decreasing = TRUE)[1:10], decreasing = FALSE))
        
        p3 <- ggplot(tab3, aes(Var1, Freq))+ geom_bar(stat = "identity", show.legend =F)+
          labs(title= "NPTEL top subjects", x ="Subject", y = "No. of courses" )+
          coord_flip()
        
        grid.arrange(p2, p3, nrow = 1)
        
        
      }
    }
    else if(input$platform == "N"){#NPTEL plots
      if(input$factor=="Ins"){ 
        if(input$institute == "All"){
          all = table(nptel$disc)
          all = as.data.frame(sort(all, decreasing = FALSE))
          
          ggplot( all, aes(Var1, Freq, fill = Var1 ))+
            geom_bar(stat= "identity", show.legend = F)+ coord_flip()+ labs(x = "Subject", y = "No. of courses")
        }
        else{
          iitk = subset(nptel, nptel$college == input$institute)
          C= table(iitk$disc)
          C = as.data.frame(sort(C, decreasing = FALSE))
          ggplot( C, aes(Var1, Freq, fill = Var1 ))+
            geom_bar(stat= "identity", show.legend = F)+ coord_flip()+ labs(x = "Subject", y = "No. of courses")
        }
      }
      else{
        if(input$subject == "All"){
          clgws = table(nptel$college)
          clgws = as.data.frame(sort(clgws, decreasing = FALSE))
          ggplot( clgws, aes(Var1, Freq, fill = Var1 ))+
            geom_bar(stat= "identity", show.legend = F)+ coord_flip()+ labs(x = "Institute", y = "No. of courses")
        }
        else{
          a <- subset(nptel, nptel$disc == input$subject)
          clgws = table(a$college)
          clgws = as.data.frame(sort(clgws, decreasing = FALSE))
          ggplot( clgws, aes(Var1, Freq, fill = Var1 ))+
            geom_bar(stat= "identity", show.legend = F)+ coord_flip()+ labs(x = "Institute", y = "No. of courses")
        }
      }
    }
    else if(input$platform=="C"){
      if(input$factor == "ins"){
        # subset of selected enrollement and ratings input of coursera
        sub = subset(mrgc, mrgc$Total.Enrollments > input$enr
                     & mrgc$Total.Ratings > input$ratings)
        #table of sub
        orgy = table(sub$Organiser)
        orgy = sort(orgy, decreasing = TRUE)
        
        n = input$no
        orgy <- sort(orgy[1:n], decreasing = FALSE)
        orgy <- as.data.frame(orgy)
        
        ggplot( orgy , aes(Var1, Freq, fill = Var1) )+
          geom_bar(stat= "identity", show.legend = F)+ coord_flip()+ labs(x = "Institute", y = "No. of courses")
        
      }
      else if(input$factor == "bzw"){
        # subs is subset on basis of selected difficulty level, rating thresholds, no. of enrolments
        subs = subset(mrgc, grepl(input$buzzword, mrgc$Name) & mrgc$Total.Ratings > input$ratings & mrgc$Total.Enrollments >= input$enrol[1] & mrgc$Total.Enrollments <= input$enrol[2] )
        if(!("all" %in% input$diff)){
          subs = subset(subs, subs$Difficulty %in% input$diff)
        }
        
        fac = as.factor(subs$Difficulty)
        
        # scatter plot on rating vs enrolments axes
        plot(x =subs$Avg..User.Rating, y =subs$Total.Enrollments, ylim = c(input$enrol[1], input$enrol[2]), xlim = c(3.6, 4.8),
             col = fac, pch =16,
             xlab = "Avg User Rating",
             ylab = "No. of Enrollments")
        
        legend("topright", col =unique(fac), 
               legend = unique(subs$Difficulty), pch = 16,
               title = "Diffculty")
      }
      
    }
    else if(input$platform == "Y"){}
    else if(input$platform == "X"){
      # sbj = subjects in edx
      if(input$factor == "sbj"){ #subject frequency bar plot 
        y <- as.data.frame(sort(table(edx$Subject), decreasing = F))
        ggplot(y, aes(Var1, Freq, fill = Var1))+
          geom_bar(stat= "identity")+
          labs(title = "Subject frequency in edX", x = "Subject", y = "Frequency")+
          coord_flip()
      }
      else{ # violin plots of course subject vs course length
        ggplot(edx, aes(edx$Subject, edx$time, col = Subject))+
          geom_violin()+
          labs(title = "Course length distribution by subject", x = "Subject", y = "Length")+coord_flip()
      }
    }
    
    
    
    
    
  })
  
}



# Run the application 
shinyApp(ui = ui, server = server)
