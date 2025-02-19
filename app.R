
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
      img(src = "https://www.shutterstock.com/image-photo/two-chocolate-chips-cookies-isolated-600nw-2490826377.jpg", 
          height = "200px"),
      
      tableOutput("recette"),
      
      h3("Instructions"),
      wellPanel(
        tags$ol(
          tags$li("Préchauffer le four à 180°C."),
          tags$li("Mélanger dans un bol, la farine, le sucre blanc et roux et la levure."),
          tags$li("Ajouter le sucre vanillé, les œufs et le beurre pommade, bien mélanger."),
          tags$li("Incorporer le chocolat préalablement coupé."),
          tags$li("Former des boules (environ 75-80g) de pâte et les déposer sur une plaque."),
          tags$li("Cuire pendant 5 minutes, puis les sortir 2 minutes avant de les remettre au four pendant 4 minutes.")
        )
      )
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
