
library(shiny)
library(bslib)
library(thematic)
library(shinylive)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "lux"),
  titlePanel("Recette de Cookies"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("nb_cookies", "Nombre de cookies :", min = 7, max = 49, value = 14, step = 7),
      downloadButton("download_recette", "Télécharger la recette")
    ),
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
