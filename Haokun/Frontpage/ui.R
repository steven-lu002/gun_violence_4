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
library(leaflet)
library(DT)
# Define UI for application that draws a histogram

state_names_array <- function() {
  choices <- list('National (State)' = 'National_State')
  choices[['National (City)']] <- 'National_City'
  for (i in 1:length(state.name)) {
    choices[[state.name[i]]] <- state.name[i]
  }
  return(choices)
}

choicesList <- state_names_array()

UI = fluidPage(
  theme = shinytheme("cosmo"),
  
  # Application title
  titlePanel("Gun Violence Analysis"),
  
  
  # Show a plot of the generated distribution
  tabsetPanel(
    tabPanel(
      "State and City",
      titlePanel('Gun Violence by State and City'),
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
        ),
    
    tabPanel("Stolen Weapons",
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput(
                   "checkGroup",
                   label = h3("Stolen vs. Unknown"),
                   choices = c("Unknown", "Stolen"),
                   selected = "Stolen"
                 ),
                 hr(),
                 fluidRow(column(3, verbatimTextOutput("value"))),
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
             )),
    tabPanel(
      "Gun Type vs. Killed/Injured",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "status",
            label = "Choose between Killed or Injured",
            choices = c("Killed", "Injured")
          ),
          
          h3(
            "How does the type of gun or caliber of the bullet affect
            the number of killed/ injured within a given incident?"
          ),
          
          h4(
            "A few conclusions can be drawn from the type of gun as well as the caliber used
            in correlation to the number of killed/ injured. Data shows that the larger the
            caliber from starting 9mm to 30-06 Spr (a known sniper caliber) the higher the chance of casualties.
            This calculated by the number of killed divided the number of injured as it shows the potential
            power of the caliber itself. Another conclusion that we are able to determine is that pistol calibers
            such as 9mm, 10mm, 40s&w, and .45 acp (listed as 45 auto) are less likely to kill and injured despite
            being the most used within gun violence. Out of the 4 different shotgun calibers listed within the
            datatables 16 gauge listed the highest on the killed chart while the .410 gauge listed the
            highest on the injured charts.",
            align = "left"
          ),
          img(
            src = 'guns.png',
            width = "550px",
            height = "300px",
            alt = "different gun types",
            align = "left"
          )
          ),
        mainPanel(plotOutput("distPlot"),
                  dataTableOutput("mytable"))
        )
        )
    
    
        )
  
      )
