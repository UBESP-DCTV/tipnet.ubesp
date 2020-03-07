#' Extract field from REDCap db
#'
#' @param data (list) the output of [tidy_extract] to extract the
#'   data (not the meta-data).
#'
#' @return [tibble][tibble::tibble-package]
#' @export
#'
#' @examples
#' \dontrun{
#'  tipnet_full <- read_redcap(url = tipnet_redcap_url())
#'  nest_tables(tipnet_full)
#' }
nest_tables <- function(data) {

  global_redcap_info <- c("codpat", "redcap_repeat_instance")

  data %>%
    add_sheets_prefix(exept = c(global_redcap_info, "fields")) %>%
    tidyr::nest(tables = -.data$fields) %>%
    dplyr::mutate(
      tables = purrr::map(.data$tables, ~{
        janitor::remove_empty(.x, c("rows", "cols")) %>%
          sheets_to_var("sheet", exept = global_redcap_info) %>%
          tidyr::nest(tables = -.data$sheet) %>%
          dplyr::mutate(
            tables = purrr::map(.data$tables,
              janitor::remove_empty,
              which = c("rows", "cols")
            )
          )
      })
    ) %>%
    tidyr::unnest(.data$tables)

}


sheets_to_var <- function(data, name = "sheet", exept = NULL) {

  names_pattern <- paste0(
    "(", paste(attr(data, 'sheet_names'), collapse = '|'), ")",
    "_(.*)"
  )

  unused <- setdiff(exept, names(data))
  cols_to_exclude <- setdiff(exept, unused)

  tidyr::pivot_longer(
    data = data,
    cols = -tidyselect::all_of(cols_to_exclude),
    names_to = c(name, ".value"),
    names_pattern = names_pattern
  )
}


