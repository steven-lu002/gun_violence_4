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
     
      
      h4("A few conclusions can be drawn from the type of gun as well as the caliber used 
         in correlation to the number of killed/ injured. Data shows that the larger the 
         caliber from starting 9mm to 30-06 Spr (a known sniper caliber) the higher the chance of casualties. 
         This calculated by the number of killed divided the number of injured as it shows the potential 
         power of the caliber itself. Another conclusion that we are able to determine is that pistol calibers 
         such as 9mm, 10mm, 40s&w, and .45 acp (listed as 45 auto) are less likely to kill and injured despite 
         being the most used within gun violence. Out of the 4 different shotgun calibers listed within the 
         datatables 16 gauge listed the highest on the killed chart while the .410 gauge listed the 
         highest on the injured charts.", align = "left")
      # img(src='guns.png', alt = "different gun types", align = "left")
      # <img src = "imgs/guns.png", width="400", height="300", alt = "different gun types">
    ),
    mainPanel(
       plotOutput("distPlot"),
       dataTableOutput("mytable")
    )
  )
))
