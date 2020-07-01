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
#' complete_data_plot(full_records, "sum", "Completed")
complete_data_plot <- function(data, summary_fun, type_completed) {
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
