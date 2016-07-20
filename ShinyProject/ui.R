library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("select", label = h3("Select box"), 
                  choices = list("Choice 1" = 1, "Choice 2" = 2,
                                 "Choice 3" = 3), selected = 1),
      
      textInput("text", label = h3("Text input"), 
                value = "Enter text..."),
    
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("PlotFiles"),
      textOutput("text1"),
      plotOutput("distPlot")
    )
  )
))
