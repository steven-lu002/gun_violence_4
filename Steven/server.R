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
shinyServer(function(input, output) {
  # if statement seems kinda unnecessary, but i couldn't get the code to work any other way.
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
  output$mytable = renderDataTable({
    #fail attempt to make colors in boxes
    #brks <- quantile(df, probs = seq(.05, .95, .05), na.rm = TRUE)
    #clrs <- (round(seq(255, 40, length.out = length(brks) + 1), 0) )#%>% {paste0("rgb(255,", ., ",", ., ")")})
    
    datatable(stage2, options = list(initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
      "}")#formatStyle(names(stage2), backgroundColor = styleInterval(brks, clrs))
      )
    ) 
    ###rounding?
    
  })
})
