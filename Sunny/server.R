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
    paste('This dot distribution shows the stolen gun data of gun violence happened at 2017.
         The map shows the distrubution of stolen gun used in violence at U.S.
          States like California, New York and Florida are experiencing the highest number of gun-related crimes as 
          the distribution is densed.
          In contrast, states like Oregon, Washington, and other Mid States are experiencing the lowest numbers
          of gun-related criminal incidents as the dot distrubution is not densed.
          We can see that hhe stolen guns are mostly distributed in the east side of United States.
          Most of the gun violence that used stolen guns occured in coast side of the United States.
          ')
  })
  
  output$text_2 <- renderText({
    paste('The data is as same as the upper data, gun violence that happened at 2017.
          Percentage of killed and injured people in gun violence are higher when the stolen guns were used. 
          The percentage of killed people is more extreme than injured people when comparing whether the stolen guns were used or not ')
  })
  
  output$text_3 <- renderText({
    paste('Looking and analysing the gun violence data of stolen guns could warn people and goverment of the 
          regulation of the guns. The stolen guns causes more injured and killed people, so it can warn people
          who owns guns. I thought the coast sides of the United States are safer to live, but there were more
          stolen gun gun violence had happened. However, the data only shows 2017 data and the correlation 
          cannot tell causation, so my analysis does not result causation')
  })
})

