#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(shinythemes)
library(DT)

stage2 <- read.csv("question2.csv", stringsAsFactors = F)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("sandstone"),
  # Application title
  titlePanel("Gun Type vs. Killed/Injured"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "status",
        label = "Choose between Killed or Injured",
        choices = c("Killed", "Injured")
      ),
     
      
      h4("According to the data, we have found that 30-06 Springfield is 
         the most frequent culprit of both killed or injuried cases: 
         this could be due to 30-06 is one of most common gun type for sport, self-defence and hunting.
         Also, we found that gun type and its level of power has no apperent correlation with number of cases", align = "left"),
      
      img(src = "imgs/guns.png", alt = "different gun types")
    ),
    mainPanel(
       plotOutput("distPlot"),
       dataTableOutput("mytable")
    )
  )
))
