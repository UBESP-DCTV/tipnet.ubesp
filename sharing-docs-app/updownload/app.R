library(shiny)


ui_upload <- sidebarLayout(
  sidebarPanel(
    fileInput("file",
        label       = "Data",
        multiple    = TRUE,
        accept      = c(".txt", ".md"),
        buttonLabel = "Upload..."),
  ),
  mainPanel(
    h3("Preview data to upload"),
    tableOutput("previewUpload"),
    actionButton("confirm", label = "Push to confirm!")
  )
)


ui <- fluidPage(
  ui_upload

    # downloadButton("downloadData", "Download selected files"),
    #
    # verbatimTextOutput("head")
)




server <- function(input, output) {

    file <- reactive({
        req(input$file)
    })

    output$previewUpload <- renderTable(
        dplyr::rename(file()[1:2], `Size (byte)` = .data$size)
    )

    ext <- reactive({
        req(input$file)
        tools::file_ext(input$file$name)
    })



    # output$downloadData <- downloadHandler(
    #     filename <- function() {
    #         paste("output", "zip", sep=".")
    #     },
    #
    #     content <- function(file) {
    #         file.copy("out.zip", file)
    #     },
    #     contentType = "application/zip"
    # )



}


# Run the application
shinyApp(ui = ui, server = server)
