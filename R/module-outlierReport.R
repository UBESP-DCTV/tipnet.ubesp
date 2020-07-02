#' Outlier module
#'
#' General description
#'
#' @param id numeric vectors.
#' @param data data frame
#'
#' @importFrom shiny NS callModule reactive req
#' @importFrom shiny fluidRow selectInput textOutput plotOutput
#' @importFrom shiny renderText renderPlot
#' @importFrom plotly renderPlotly plotlyOutput ggplotly
#' @importFrom ggplot2 ggplot aes geom_boxplot facet_wrap coord_flip
#' @importFrom ggplot2 theme ggtitle xlab ylab element_text
#'
#' @name outlierReport
NULL


#' @describeIn outlierReport user interface
#'
#' User Interface description
#'
#' @export
outlierReportUI <- function(id, data) {
  ns <- NS(id)

  fluidPage(
    fluidRow(
      column(12, selectInput(ns("center"),
        label   = "Choose a center to display its possible outliers",
        choices = unique(data[["center"]]),
        multiple = TRUE
      ))
    ),
    fluidRow(
      column(12, DT::DTOutput(ns("out_plot")))
    )
  )
}

#' @describeIn outlierReport server function
#'
#' Server description
#'
#' @export
outlierReport <- function(id, data) {
  callModule(id = id, function(input, output, session) {

    center <- reactive({
      req(input$center)
    })

    db_to_use <- reactive({
      dplyr::filter(data, center == center())[["data"]] %>%
        .[[1]] %>%
          select(
            `patient's code` = codpat,
            `instance id` = redcap_repeat_instance,
            variable = variable,
            value = value
          )
    })

    output$out_plot <- DT::renderDT(db_to_use(),
      filter = list(position = 'top', clear = TRUE)
    )
  })
}
