#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

library(shinythemes)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("slate"),
  # Application title
  titlePanel("Stolen Gun around United States"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("checkGroup", label = h3("Stolen vs. Unknown"), 
                         choices = c("Unknown", "Stolen"), 
                         selected = "Stolen"),
      hr(),
      fluidRow(
        column(3, verbatimTextOutput("value"))
      ),
      textOutput("text_1"),
      hr(),
      textOutput("text_2"),
      hr(),
      textOutput("text_3")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("gun_stolen_plot"),
       plotOutput("gun_stolen_plot2"),
       plotOutput("gun_stolen_plot3")
    )
  )
))

