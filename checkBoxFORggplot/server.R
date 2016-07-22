library(shiny)
library(ggplot2)
source("data.R")

shinyServer(function(input, output, session) {

    selAll <- observeEvent(input$SelectAll, {
      campaigns_list = as.character(c(1:length(allType)))
      updateCheckboxGroupInput(session,"checkGroup", selected=campaigns_list)
    })
    
    delALL <- observeEvent(input$DelAll, {
      campaigns_list = rep(c(""), length(allType))
      updateCheckboxGroupInput(session,"checkGroup", selected=campaigns_list)
    })
    
    output$checkBoxPlot <- renderPlot({
      
      i = as.numeric(input$checkGroup)
      
      index = c()
      for( j in 1:length(i) )
      {
        compareString = paste0('category', i[j])
        print(compareString)
        index = rbind(index, which(as.character(df$variable) == compareString))
      }
      
      print(index)
      
      #ggplot(data = df, aes(x=x, y=val)) + geom_line(aes(colour=variable))
      ggplot(data = df[index,], aes(x=x, y=val)) + geom_line(aes(colour=variable))
      
    })
})
