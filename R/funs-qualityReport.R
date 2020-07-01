#' @export
dataToUse <- function(data, completed) {
  if (completed == "Completed") {
    data
  } else {
    dplyr::mutate(data, complete = !.data$complete)
  }
}


#' @export
summaryFun <- function(type) {
  switch(type, Total = "sum", Proportion = "mean")
}


#' @export
areOutAge <- function(data) {
  data[["age_class"]] %in% c("[wrong/missing age]", "eta > 18")
}


#' @export
statGlobal <- function(data, type_complete) {
  are_out_age <- areOutAge(data)

  glue::glue("Out of {sum(!are_out_age)}, there are ",
    "{sum(data[['complete']][!are_out_age], na.rm = TRUE)} records ",
    "with {type_complete} data (proportion of {type_complete} data = ",
    "{round(mean(data[['complete']][!are_out_age], na.rm = TRUE), 2)})."
  )
}


#' @export
outOfAge <- function(are_out_age) {
  glue::glue("There are {sum(are_out_age)} people to exclude because ",
  "of their age is missing or more than 18 (strictly)")
}




#' Quality plot for completed data
#'
#' @param data data to use
#' @param summary_fun summary funciton (eg, `sum` or `mean`)
#' @param type_completed (chr) what is represented (i.e. "Completed", or
#'   "Non-Completed")
#'
#' @return ggplot2 plot
#' @export
#'
#' @examples
#' purrr::iwalk(
#'   tipnet.ubesp:::generate_main_data(),
#'   ~ assign(.y, .x, pos = 1)
#' )
#'
#' completeDataPlot(full_records, "sum", "Completed")
completeDataPlot <- function(data, summary_fun, type_completed) {
  data %>%
    ggplot(aes(x = center, y = as.integer(.data$complete))) +
    stat_summary(
      fun = summary_fun,
      na.rm = TRUE,
      geom = "bar",
      position = "dodge",
      fill = "darkgreen"
    ) +
    stat_summary(aes(x = "TIPNet"),
                 fun = summary_fun,
                 na.rm = TRUE,
                 geom = "bar",
                 position = "dodge",
                 fill = "darkred",
                 alpha = 30
    ) +
    facet_wrap(~.data$age_class) +
    theme(
      axis.text.x = element_text(angle = 66, hjust = 1, vjust = 1),
      legend.position = "none"
    ) +
    xlab("") +
    ylab("") +
    ggtitle(paste(type_completed, "cases.")) +
    coord_flip()
}
