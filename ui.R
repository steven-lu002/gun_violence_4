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
stage2 <- read.csv("question2.csv", stringsAsFactors = F)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("cerulean"),
  # Application title
  titlePanel("Gun Type vs. Killed/Injured"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "status",
        label = "Choose between Killed or Injured",
        choices = c("Killed", "Injured")
      )
    ),
  
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
