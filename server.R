#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
stage2 <- read.csv("question2.csv", stringsAsFactors = F)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
     ggplot(stage2, aes(gun_type, 
      if(input$status == "Killed"){
        y = stage2$Killed
      } else {
        y = stage2$Injured
      }, fill = stage2$gun_type)) + 
      geom_bar(stat = "identity") +
      labs(y = paste0("Number of ", input$status), x = "Gun Types Used") +
      ggtitle(paste0("Gun Type Versus ", input$status)) +
      theme(axis.text=element_text(size = 7.8), axis.title=element_text(size = 20, face = "bold"), 
            title = element_text(size = 25, face = "bold")) +
      guides(fill=guide_legend(title = "Gun Types"))
  })
  
})
