#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)

filtered <- data %>%
    select(
        state,
        city_or_county,
        latitude,
        longitude,
        participant_age_group,
        participant_status,
        participant_type
    )
filtered <- filtered %>%
    mutate('Adult' = str_detect(participant_age_group, coll('Adult'))) %>%
    mutate('Teen' = str_detect(participant_age_group, coll('Teen'))) %>%
    mutate('Child' = str_detect(participant_age_group, coll('Child')))
adult_data <- filtered %>%
    filter(Adult == TRUE)
teen_data <- filtered %>%
    filter(Teen == TRUE)
child_data <- filtered %>%
    filter(Child == TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    getMapType <- reactive({
        if (input$radio == 'adult') {
            return(adult_data)
        } else if (input$radio == 'teen') {
            return(teen_data)
        } else {
            return(child_data)
        }
    })
    
    getTableType <- reactive({
        if (input$radio == 'adult') {
            adult_data <- adult_data %>%
                group_by(state) %>%
                summarise(n())
            return(adult_data)
        } else if (input$radio == 'teen') {
            teen_data <- teen_data %>%
                group_by(state) %>%
                summarise(n())
            return(teen_data)
        } else {
            child_data <- child_data %>%
                group_by(state) %>%
                summarise(n())
            return(child_data)
        }
    })
    
    output$plot <- renderLeaflet({
        leaflet(getMapType()) %>% addTiles() %>% addCircles(
            lng =  ~ longitude,
            lat =  ~ latitude,
            color = 'red'
        )
    })
    
    output$table <- renderDataTable(getTableType())
    
})
