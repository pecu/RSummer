library(shiny)
source("data.R")

shinyUI(fluidPage(
  
  
  checkboxGroupInput("checkGroup", 
                     label = h3("Checkbox group"), 
                     choices = checkboxList,
                     selected = 1),
  
  actionButton("SelectAll", label = "SelectAll"),
  actionButton("DelAll", label = "DelAll"),
  
  plotOutput("checkBoxPlot")

  ))