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
library(DT)
library(tidyverse)

data <- read.csv('./complete.stage2.2017.csv', stringsAsFactors = FALSE)
filtered <- data %>%
    drop_na(longitude, latitude) %>%
    select(
        state,
        city_or_county,
        latitude,
        longitude,
        participant_age_group,
        participant_status,
        participant_type
    ) %>%
    rename(State = state) %>%
    rename(City = city_or_county) %>%
    mutate('Adult' = str_detect(participant_age_group, coll('Adult'))) %>%
    mutate('Teen' = str_detect(participant_age_group, coll('Teen'))) %>%
    mutate('Child' = str_detect(participant_age_group, coll('Child')))
adult_data <- filtered %>%
    filter(Adult == TRUE)
teen_data <- filtered %>%
    filter(Teen == TRUE)
child_data <- filtered %>%
    filter(Child == TRUE)

getCrimeCount <- function(data, city_or_state) {
    if (city_or_state == 'State') {
        data <- data %>%
            group_by(State) %>%
            summarise(n()) %>%
            rename(Count = 'n()') %>%
            arrange(desc(Count))
        return(data)
    } else {
        data <- data %>%
            group_by(City) %>%
            summarise(n()) %>%
            rename(Count = 'n()') %>%
            arrange(desc(Count)) %>%
            rename('City/County' = City)
        return(data)
    }
}

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
            data <- adult_data
        } else if (input$radio == 'teen') {
            data <- teen_data
        } else {
            data <- child_data
        }
        if (input$select == 'National') {
            getCrimeCount(data, 'State')
        } else {
            data <- data %>%
                        filter(State == input$select)
            getCrimeCount(data, 'City')
        }
        
    })
    
    output$plot <- renderLeaflet({
        leaflet(getMapType()) %>% addTiles() %>% addCircles(
            lng =  ~ longitude,
            lat =  ~ latitude,
            color = 'red'
        )
    })
    
    output$table <- renderDataTable({
        getTableType()
    })
    
})
