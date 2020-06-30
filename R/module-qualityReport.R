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
        choices = c("Completed", "Not completed")
      )),
      column(5, selectInput(ns("type"),
        label   = "Summary type",
        choices = c("Total", "Proportion")))
    ),


    fluidRow(plotOutput(ns("plot_global"))),
    fluidRow(plotlyOutput(ns("plot_center")))
  )
}

#' @describeIn qualityReport server function
#'
#' Server description
#'
#' @export
qualityReport <- function(id, data) {

  are_out_age <- data[["age_class"]] %in% c("[wrong/missing age]", "eta > 18")

  callModule(id = id, function(input, output, session) {

    type <- reactive({
      req(input$type)
    })

    completed <- reactive({
      req(input$completed)
    })

    data_to_use <- reactive({
      if (completed() == "Completed") {
        data
      } else {
        dplyr::mutate(data, complete = !.data$complete)
      }
    })

    fun_y <- reactive({
      switch(type(),
        Total      = "sum",
        Proportion = "mean"
      )
    })

    output$stat_global <- renderText(glue::glue("
      Out of {sum(!are_out_age)}, there are
      {sum(data_to_use()[['complete']][!are_out_age], na.rm = TRUE)}
      records with {completed()} data
      (proportion of {completed()} data =
       {round(mean(data_to_use()[['complete']][!are_out_age], na.rm = TRUE), 2)}
      )."
    ))

    output$out_of_age <- renderText(glue::glue(
      "There are {sum(are_out_age)} people to exclude because of their
       age is missing or more than 18 (strictly)
      "
    ))

    output$plot_global <- renderPlot({
      data_to_use() %>%
        ggplot(aes(x = "TIPNet", y = as.integer(.data$complete))) +
        stat_summary(
          fun = fun_y(),
          na.rm = TRUE,
          geom = "bar",
          position = "dodge",
          fill = "darkgreen"
        ) +
        facet_wrap(~.data$age_class) +
        theme(legend.position = "none") +
        xlab("") +
        ylab("") +
        ggtitle(paste(completed(), "cases."))
    })

    output$plot_center <- renderPlotly({
      gg <- data_to_use() %>%
        ggplot(aes(
          x = .data$center,
          y = as.integer(.data$complete),
          fill = .data$center
        )) +
        geom_bar(stat = "summary",
            fun.y = fun_y(), na.rm = TRUE,
            position = "dodge"
        ) +
        facet_wrap(~.data$age_class) +
        theme(
          axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
          legend.position = "none"
        ) +
        xlab("") +
        ylab("") +
        ggtitle(paste(input$completed, "cases.")) +
        coord_flip()

        ggplotly(gg)
    })

  })
}
