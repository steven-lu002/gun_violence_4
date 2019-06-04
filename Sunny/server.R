#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#



library(plotly)
library(shiny)
library(dplyr)
library(ggplot2)
library(data.table)
library(maps)
library(R.utils)
library(mapproj)

#data <- paste0("./complete.stage2.2017.csv")
data <- read.csv('./complete.stage2.2017.csv', stringsAsFactors = FALSE)

gun_data <- select(data, gun_stolen, longitude, latitude, n_killed, n_injured) %>% 
  filter(latitude > 20 & latitude <50) %>% 
  filter(longitude < -69 & longitude > -132) 
gun_data$gun_stolen <- gsub("\\|.*","", gun_data$gun_stolen)
gun_data$gun_stolen <- gsub(".*\\:","", gun_data$gun_stolen)
stolen <- length(which(gun_data$gun_stolen == 'Stolen'))
without_Unknown <- filter(gun_data, gun_stolen != 'Unknown') %>% 
  filter(gun_stolen != '')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$gun_stolen_plot <- renderPlot({
    sub <- gun_data[ which(gun_data$gun_stolen %in% input$checkGroup) , ]
    state_shape <- map_data("state")
    ggplot(state_shape) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group)) +
      geom_point(
        data = sub, 
        mapping = aes(x = longitude, y = latitude, color = gun_stolen) 
      ) +
      coord_map() 
  })
  
  output$gun_stolen_plot2 <- renderPlot({
    ggplot(without_Unknown, aes(gun_stolen,
                        y= n_killed,
       fill = without_Unknown$gun_stolen)) +
      geom_bar(stat = 'identity') +
      labs(x = "gun types", y = "killed") +
      ggtitle("Stolen or not stolen vs. killed people") +
      theme(axis.text=element_text(size = 10), axis.title=element_text(size = 10, face = "bold"), 
            title = element_text(size = 10, face = "bold")) +
      guides(fill=guide_legend(title = "Stolen Guns - Killed people"))
  })
  
  output$gun_stolen_plot3 <- renderPlot({
    ggplot(without_Unknown, aes(gun_stolen,
                                y= n_injured,
                                fill = without_Unknown$gun_stolen)) +
      geom_bar(stat = 'identity') +
      labs(x = "Stolen or not stolen", y = "injured") +
      ggtitle("Stolen or not stolen vs. injured people") +
      theme(axis.text=element_text(size = 10), axis.title=element_text(size = 10, face = "bold"), 
            title = element_text(size = 10, face = "bold")) +
      guides(fill=guide_legend(title = "Stolen Guns - Injured people"))
  })
  
  output$text_1 <- renderText({
    paste('The map shows the distrubution of stolen gun used in violence at U.S')
  })
  
  output$text_2 <- renderText({
    paste('Percentage of killed and injured people in gun violence are higher when the stolen guns were used')
  })
})

