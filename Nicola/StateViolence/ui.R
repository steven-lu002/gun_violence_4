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
    choices <- list('National (State)' = 'National_State')
    choices[['National (City)']] <- 'National_City'
    for (i in 1:length(state.name)) {
        choices[[state.name[i]]] <- state.name[i]
    }
    return(choices)
}

choicesList <- state_names_array()

shinyUI(fluidPage(
    fluidRow(column(4),
             column(
                 8,
                 titlePanel('Gun Violence by State and City')
             )),
    
    sidebarLayout(
        fluidRow(
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
                    selected = 'teen'
                )
            ),
            
            column(12, leafletOutput("plot"))
        ),
        fluidRow(
            column(1),
            column(4,
                   selectInput(
                       "select",
                       label = h3("Select State"),
                       choices = choicesList,
                   )),
            column(12, dataTableOutput("table"))
        )
    ),
    fluidRow(HTML(paste(
        h3('Analysis'),
        '</br>',
        h4(
            'In general most of the gun violence appears on the East Coast
                   of the United States. There is a notable lack in observations in
                   the mid west states. For Adults the Cities with the most amount
                   of occurences are famous for their violence: Chicago, Baltimore,
                   New Orleans, Saint Louis and Philadelphia. Chicago and Saint Louis are
                   the most violent throughout all age groups while the others drop in and out
                   depending on age. One interesting observation is that the state with the most gun
                   incidents with an Adult is California, which does not have a city in the
                   top 10 most violent. Three cities that do not get a lot of attentions but
                   showed a high amount of violence across age groups were Memphis, Houston,
                   and Milwaukee. The state with the highest amount of child incidents was Texas.'
        )
    )))
))
