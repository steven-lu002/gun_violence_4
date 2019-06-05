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

data <-
  read.csv('./complete.stage2.2017.csv', stringsAsFactors = FALSE)
filtered <- data %>%
  drop_na(longitude, latitude) %>%
  select(state,
         city_or_county,
         latitude,
         longitude,
         participant_age_group,
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

gun_data <-
  select(data, gun_stolen, longitude, latitude, n_killed, n_injured) %>%
  filter(latitude > 20 & latitude < 50) %>%
  filter(longitude < -69 & longitude > -132)
gun_data$gun_stolen <- gsub("\\|.*", "", gun_data$gun_stolen)
gun_data$gun_stolen <- gsub(".*\\:", "", gun_data$gun_stolen)
stolen <- length(which(gun_data$gun_stolen == 'Stolen'))
without_Unknown <- filter(gun_data, gun_stolen != 'Unknown') %>%
  filter(gun_stolen != '')

stage2 <- read.csv("question2.csv", stringsAsFactors = F)

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
    if (input$select == 'National_State') {
      getCrimeCount(data, 'State')
    } else if (input$select == 'National_City') {
      getCrimeCount(data, 'City')
    } else {
      data <- data %>%
        filter(State == input$select)
      getCrimeCount(data, 'City')
    }
    
  })
  
  output$plot <- renderLeaflet({
    leaflet(getMapType()) %>% addTiles() %>% addCircles(lng =  ~ longitude,
                                                        lat =  ~ latitude,
                                                        color = 'red')
  })
  
  output$table <- renderDataTable({
    getTableType()
  })
  
  
  output$gun_stolen_plot <- renderPlot({
    sub <-
      gun_data[which(gun_data$gun_stolen %in% input$checkGroup) ,]
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
    ggplot(without_Unknown,
           aes(gun_stolen,
               y = n_killed,
               fill = without_Unknown$gun_stolen)) +
      geom_bar(stat = 'identity') +
      labs(x = "gun types", y = "killed") +
      ggtitle("Stolen or not stolen vs. killed people") +
      theme(
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 10, face = "bold"),
        title = element_text(size = 10, face = "bold")
      ) +
      guides(fill = guide_legend(title = "Stolen Guns - Killed people"))
  })
  
  output$gun_stolen_plot3 <- renderPlot({
    ggplot(
      without_Unknown,
      aes(gun_stolen,
          y = n_injured,
          fill = without_Unknown$gun_stolen)
    ) +
      geom_bar(stat = 'identity') +
      labs(x = "Stolen or not stolen", y = "injured") +
      ggtitle("Stolen or not stolen vs. injured people") +
      theme(
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 10, face = "bold"),
        title = element_text(size = 10, face = "bold")
      ) +
      guides(fill = guide_legend(title = "Stolen Guns - Injured people"))
  })
  
  output$text_1 <- renderText({
    paste(
      'This dot distribution shows the stolen gun data of gun violence happened at 2017.
      The map shows the distrubution of stolen gun used in violence at U.S.
      States like California, New York and Florida are experiencing the highest number of gun-related crimes as
      the distribution is densed.
      In contrast, states like Oregon, Washington, and other Mid States are experiencing the lowest numbers
      of gun-related criminal incidents as the dot distrubution is not densed.
      We can see that hhe stolen guns are mostly distributed in the east side of United States.
      Most of the gun violence that used stolen guns occured in coast side of the United States.
      '
    )
  })
  
  output$text_2 <- renderText({
    paste(
      'The data is as same as the upper data, gun violence that happened at 2017.
      Percentage of killed and injured people in gun violence are higher when the stolen guns were used.
      The percentage of killed people is more extreme than injured people when comparing whether the stolen guns were used or not '
    )
  })
  
  output$text_3 <- renderText({
    paste(
      'Looking and analysing the gun violence data of stolen guns could warn people and goverment of the
      regulation of the guns. The stolen guns causes more injured and killed people, so it can warn people
      who owns guns. I thought the coast sides of the United States are safer to live, but there were more
      stolen gun gun violence had happened. However, the data only shows 2017 data and the correlation
      cannot tell causation, so my analysis does not result causation'
    )
  })
  
  output$distPlot <- renderPlot({
    ggplot(stage2, aes(gun_type,
                       if (input$status == "Killed") {
                         y = stage2$Killed
                       } else {
                         y = stage2$Injured
                       }, fill = stage2$gun_type)) +
      geom_bar(stat = "identity") +
      labs(y = paste0("Number of ", input$status), x = "Gun Types Used") +
      ggtitle(paste0("Gun Type Versus ", input$status)) +
      theme(
        axis.text = element_text(size = 7.8),
        axis.title = element_text(size = 20, face = "bold"),
        title = element_text(size = 25, face = "bold")
      ) +
      guides(fill = guide_legend(title = "Gun Types"))
  })
  output$mytable = renderDataTable({
    #fail attempt to make colors in boxes
    #brks <- quantile(df, probs = seq(.05, .95, .05), na.rm = TRUE)
    #clrs <- (round(seq(255, 40, length.out = length(brks) + 1), 0) )#%>% {paste0("rgb(255,", ., ",", ., ")")})
    
    datatable(stage2, options = list(
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
        "}"
      )#formatStyle(names(stage2), backgroundColor = styleInterval(brks, clrs))
    ))
    ###rounding?
    
  })
  output$introduction <- renderText({
    paste('The dataset that we are going to use is from a github repo containing csv files on gun violence.
          This data is collected from gun violence archives and can be accessed from the csv files located 
          on the repo. This data was collected through the use of python scripts in order to sort and clean 
          the data. The filters include things such as incident, location, date, gun type, etc. Our project
          answers three questions : How many guns used in violence are stolen versus legally bought?
          How does the type of gun affect the number of killed/ injured within a given incident.
          What is the most impacted age group (victims/ participants) in different regions?
          Our target audiences are State legislatures looking at gun control laws and parents looking at gun 
          statistics based on age, and anyone concerned with their safety regarding gun violence cases. This is due to
          the impact that this analysis could have. The correlation between gun types and violence results could assist 
          in determining the potential gun control laws and the impacted age group could be informative for parents looking 
          for gun statistics. 
          \n
          This project is created by  Nicola Beirer, Steven Lu, Haokun Cai, Sunny Lee.
          ')
  })
  })
