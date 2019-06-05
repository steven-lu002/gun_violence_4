library(shiny)
library(shinythemes)
library(leaflet)
library(DT)

# Data Wrangling
state_names_array <- function() {
  choices <- list('National (State)' = 'National_State')
  choices[['National (City)']] <- 'National_City'
  for (i in 1:length(state.name)) {
    choices[[state.name[i]]] <- state.name[i]
  }
  return(choices)
}

choicesList <- state_names_array()

# UI Page
UI = fluidPage(
  theme = shinytheme("cosmo"),
  
  titlePanel("Gun Violence Analysis"),
  
  # Tabs of different questions
  tabsetPanel(
    # First Panel, Introduction
    tabPanel(
      "Introduction",
      titlePanel('Introduction'),
      fluidRow(column(8,
                      textOutput("introduction")))
    ),
    # Second Panel, Gun Violence occurences
    tabPanel(
      "State and City",
      titlePanel('Gun Violence by State and City'),
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
      ))),
      # Radio Buttons
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
          
          # Leaflet
          column(12, leafletOutput("plot"))
        ),
        # Select Box
        fluidRow(
          column(1),
          column(4,
                 selectInput(
                   "select",
                   label = h3("Select State"),
                   choices = choicesList,
                 )),
          # Data frame
          column(12, dataTableOutput("table"))
        )
      )
    ),
    
    # Third Panel, Stolen Weapon Data
    tabPanel("Stolen Weapons",
             sidebarLayout(
               # Checkbox
               sidebarPanel(
                 checkboxGroupInput(
                   "checkGroup",
                   label = h3("Stolen vs. Unknown"),
                   choices = c("Unknown", "Stolen"),
                   selected = "Stolen"
                 ),
                 hr(),
                 fluidRow(column(3, verbatimTextOutput("value"))),
                 # 3 Text Analysis
                 textOutput("text_1"),
                 hr(),
                 textOutput("text_2"),
                 hr(),
                 textOutput("text_3")
               ),
               
               # US Map Plot and 2 Bar Graphs
               mainPanel(
                 plotOutput("gun_stolen_plot"),
                 plotOutput("gun_stolen_plot2"),
                 plotOutput("gun_stolen_plot3")
               )
             )),
    # Final Panel, Gun Type vs Injuries
    tabPanel(
      "Gun Type vs. Killed/Injured",
      sidebarLayout(
        # Select Box
        sidebarPanel(
          selectInput(
            inputId = "status",
            label = "Choose between Killed or Injured",
            choices = c("Killed", "Injured")
          ),
          
          # Analysis
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
          # Image of guns to fill up space
          img(
            src = 'guns.png',
            width = "550px",
            height = "300px",
            alt = "different gun types",
            align = "left"
          )
        ),
        # Bar graph and Data Table of Gun Types and Injuries/Deaths
        mainPanel(plotOutput("distPlot"),
                  dataTableOutput("mytable"))
      )
    )
  )
)