#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(DT)

state_names_array <- function() {
    choices <- list('National' = 'National')
    for (i in 1:length(state.name)) {
        choices[[state.name[i]]] <- state.name[i]
    }
    return(choices)
}

choicesList <- state_names_array()

shinyUI(fluidPage(
    fluidRow(column(4),
             column(
                 6,
                 titlePanel('Gun Violence by State and City')
             )),
    
    sidebarLayout(fluidRow(
        column(1),
        column(
            4,
            radioButtons(
                "radio",
                label = h3("Choose Data"),
                choices = list(
                    "Adult (18+)" = 'adult',
                    "Teen (12-17)" = 'teen',
                    "Child (0-11)" = 'child'
                ),
                selected = 'adult'
            )
        ),
        
        column(6, leafletOutput("plot"))
    ),
    fluidRow(
        column(1),
        column(4,
               selectInput(
                   "select",
                   label = h3("Select State"),
                   choices = choicesList,
               )),
        column(6, dataTableOutput("table"))
    ))
))
