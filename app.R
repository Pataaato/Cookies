library(shiny)
library(usethis)
library(dplyr)
library(ggplot2)
library(glue)
library(DT)
library(bslib)
library(thematic)
library(shinylive)
library(rsconnect)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "lux"),
  titlePanel("Recette de Cookies"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("nb_cookies", "Nombre de cookies :", min = 8, max = 56, value = 16, step = 8),
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

  recette_base <- data.frame(
    Ingredient = c("Farine", "Sucre blanc", "Sucre roux", "Levure", "Sucre vanillé", "Beurre", "Oeufs", "Chocolat"),
    Unité = c("g", "g", "g", "sachet", "sachet", "g", "", "g"),
    Pour_8_cookies = c(220, 50, 50, 0.5, 1, 125, 1, 100))
  
  output$recette <- renderTable({
    recette <- recette_base
    recette$Quantité <- recette$Pour_8_cookies * (input$nb_cookies / 8)
    recette$Quantité <- paste0(recette$Quantité, " ", recette$Unité)
    recette[, c("Ingredient", "Quantité")]
  })
  output$download_recette <- downloadHandler(
    filename = function() { "recette_cookies.txt" },
    content = function(file) {
      lignes <- c(
        "Recette de Cookies",
        paste("Nombre de cookies :", input$nb_cookies),
        "\nIngrédients :"
      )
      
      quantites <- recette_base$Pour_8_cookies * (input$nb_cookies / 8)
      for (i in seq_along(recette_base$Ingredient)) {
        lignes <- c(lignes, paste("-", recette_base$Ingredient[i], ":", quantites[i], recette_base$Unité[i]))
      }
      
      lignes <- c(lignes, "\nInstructions :",
                  "1. Préchauffer le four à 180°C.",
                  "2. Mélanger dans un bol, la farine, le sucre blanc et roux et la levure.",
                  "3. Ajouter le sucre vanillé, les œufs et le beurre pommade, bien mélanger.",
                  "4. Incorporer le chocolat préalablement coupé.",
                  "5. Former des boules (environ 75-80g) de pâte et les déposer sur une plaque.",
                  "6. Cuire pendant 5 minutes, puis les sortir 2 minutes avant de les remettre au four pendant 4 minutes."
      )
      
      writeLines(lignes, file)
    }
  )
}


# Run the application 
shinyApp(ui = ui, server = server)
