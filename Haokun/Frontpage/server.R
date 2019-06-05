library(shiny)
library(leaflet)
library(dplyr)
library(DT)
library(tidyverse)
library(data.table)
library(maps)
library(R.utils)
library(mapproj)

# Data wrangling
data <-
  read.csv('./complete.stage2.2017.csv', stringsAsFactors = FALSE)
filtered <- data %>%
  drop_na(longitude, latitude) %>%
  select(state,
         city_or_county,
         latitude,
         longitude,
         participant_age_group,) %>%
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

# More Data wrangling
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

# Data wrangling function
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

# Another data wrangling function
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
  
  # Reactive data wrangling
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
  
  # Plot of a World Map (Focused in US) of leaflet of gun violence occurences
  output$plot <- renderLeaflet({
    leaflet(getMapType()) %>% addTiles() %>% addCircles(lng =  ~ longitude,
                                                        lat =  ~ latitude,
                                                        color = 'red')
  })
  
  # Data table for leaflet
  output$table <- renderDataTable({
    getTableType()
  })
  
  
  output$gun_stolen_plot <- renderPlot({
    sub <-
      gun_data[which(gun_data$gun_stolen %in% input$checkGroup) , ]
    state_shape <- map_data("state")
    ggplot(state_shape) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group)) +
      geom_point(
        data = sub,
        mapping = aes(x = longitude, y = latitude, color = gun_stolen)
      ) +
      coord_map()
  })
  
  # Plot of US of stolen guns
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
  
  # Bar graph about stolen guns
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
  
  # Analysis for Stolen weapons
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
  
  # More analysis for stolen weapons
  output$text_2 <- renderText({
    paste(
      'The data is as same as the upper data, gun violence that happened at 2017.
      Percentage of killed and injured people in gun violence are higher when the stolen guns were used.
      The percentage of killed people is more extreme than injured people when comparing whether the stolen guns were used or not '
    )
  })
  
  # Final analysis for stolen weapons
  output$text_3 <- renderText({
    paste(
      'Looking and analysing the gun violence data of stolen guns could warn people and goverment of the
      regulation of the guns. The stolen guns causes more injured and killed people, so it can warn people
      who owns guns. I thought the coast sides of the United States are safer to live, but there were more
      stolen gun gun violence had happened. However, the data only shows 2017 data and the correlation
      cannot tell causation, so my analysis does not result causation'
    )
  })
  
  # Bar graph for gun type and injuries
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
  
  # Data table for the plot
  output$mytable = renderDataTable({
    datatable(stage2, options = list(
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
        "}"
      )
    ))
  })
  
  # Introduction of the project
  output$introduction <- renderText({
    paste(
      'The dataset that we are going to use is from a github repo containing csv files on gun violence.
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
      '
    )
  })
})
