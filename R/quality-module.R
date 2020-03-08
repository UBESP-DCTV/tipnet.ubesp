#' Quality module
#'
#' General description
#'
#' @param id numeric vectors.
#' @param data database to use
#'
#' @importFrom shiny NS callModule reactive req
#' @importFrom shiny fluidRow selectInput textOutput plotOutput
#' @importFrom shiny renderText renderPlot
#' @importFrom plotly renderPlotly plotlyOutput ggplotly
#' @importFrom ggplot2 aes element_text ggplot xlab ylab coord_flip
#' @importFrom ggplot2 geom_bar facet_wrap theme
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

  fluidRow(
    textOutput(ns("stat_global")),
    textOutput(ns("out_of_age")),
    selectInput(ns("type"), "Summary type", c("Total", "Proportion")),
    plotOutput(ns("plot_global")),
    plotlyOutput(ns("plot_center"))
  )
}

#' @describeIn qualityReport server function
#'
#' Server description
#'
#' @export
qualityReport <- function(id, data) {

  out_of_age <- dplyr::filter(data, !.data$age_upto_18)
  used_data <- dplyr::filter(data, .data$age_upto_18) %>%
    dplyr::mutate(
      name = "TIPNet",
      complete_int = as.integer(.data$complete)
    )

  callModule(id = id, function(input, output, session) {

    type <- reactive({
      req(input$type)
    })

    fun_y <- reactive({
      switch(type(),
        Total      = "sum",
        Proportion = "mean"
      )
    })

    output$out_of_age <- renderText(glue::glue(
      "There are {nrow(out_of_age)} people with more than 18 years, i.e. {ui_value(out_of_age[['years']])}"
    ))

    output$stat_global <- renderText(glue::glue(
      "There where {sum(used_data[['complete']], na.rm = TRUE)} completed data recorded (out of {nrow(used_data)}; proportion of complete data = {round(mean(used_data[['complete']], na.rm = TRUE), 2)})."
    ))




    output$plot_global <- renderPlot({
      used_data %>%
        ggplot(
          aes(x = .data$name, y = .data$complete_int)
        ) +
        geom_bar(
          stat = "summary",
          fun.y = fun_y(), na.rm = TRUE,
          position = "dodge",
          fill = "green"
        ) +
        facet_wrap(~age_upto_16) +
        theme(legend.position = "none") +
        xlab("") +
        ylab("")
    })




    output$plot_center <- renderPlotly({
      gg <- used_data %>%
        ggplot(
          aes(x = .data$center, y = .data$complete_int, fill = .data$center)
        ) +
        geom_bar(stat = "summary",
            fun.y = fun_y(), na.rm = TRUE,
            position = "dodge"
        ) +
        facet_wrap(~age_upto_16) +
        theme(
          axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
          legend.position = "none"
        ) +
        xlab("") +
        ylab("") +
        coord_flip()

        ggplotly(gg)
    })

  })
}
