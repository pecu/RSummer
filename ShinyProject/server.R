library(shiny)

shinyServer(function(input, output) {

  output$PlotFiles <- renderPlot({
    filename = paste('text', input$select, '.csv', sep="")
    print(filename)
    x = read.csv(filename)
    plot(x)
  })
  
  output$text1 <- renderText({
    paste('your text is ', input$text, sep="")
  })
  
  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
