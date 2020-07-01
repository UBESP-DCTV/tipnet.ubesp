#' Quality module
#'
#' General description
#'
#' @param id name for the specific instance of the module.
#' @param data database to use
#'
#' @importFrom shiny NS callModule reactive req
#' @importFrom shiny fluidPage fluidRow selectInput textOutput plotOutput
#' @importFrom shiny renderText renderPlot column
#' @importFrom plotly renderPlotly plotlyOutput ggplotly
#' @importFrom ggplot2 ggplot aes stat_summary facet_wrap coord_flip
#' @importFrom ggplot2 theme ggtitle xlab ylab element_text
#'
#' @name qualityReport
NULL

#' @describeIn qualityReport user interface
#'
#' User Interface description
#'
#' @export
qualityReportUI <- function(id) {
  ns <- NS(id)

  fluidPage(
    fluidRow(textOutput(ns("stat_global"))),
    fluidRow(textOutput(ns("out_of_age"))),


    fluidRow(
      column(5, selectInput(ns("completed"),
        label   = "Records to show",
        choices = c("Completed", "Not completed"),
        selected = params$quality_completed
      )),
      column(5, selectInput(ns("type"),
        label   = "Summary type",
        choices = c("Proportion", "Total"),
        selected = params$quality_type
      ))
    ),


    fluidRow(plotOutput(ns("plot_global"), height = "800px"))
  )
}

#' @describeIn qualityReport server function
#'
#' Server description
#'
#' @export
qualityReport <- function(id, data) {

  are_out_age <- areOutAge(data)

  callModule(id = id, function(input, output, session) {

    data_to_use <- reactive({
      dataToUse(data, completed())
    })

    fun_y <- reactive({
      req(input$type)
      summaryFun(input$type)
    })

    completed <- reactive({
      req(input$completed)
    })


    output$stat_global <- renderText(
      statGlobal(data_to_use(), completed())
    )
    output$out_of_age <- renderText(outOfAge(are_out_age))

    output$plot_global <- renderPlot({
      completeDataPlot(data_to_use(), fun_y(), completed())
    })

  })
}
