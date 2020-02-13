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

  data %>%
    tidyr::nest(tables = -.data$fields) %>%
    dplyr::mutate(
      tables = purrr::map(.data$tables, ~{
        janitor::remove_empty(.x, c("rows", "cols")) %>%
          add_sheets_prefix(exept = "codpat") %>%
          sheets_to_var("sheet", exept = "codpat") %>%
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

  tidyr::pivot_longer(
    data = data,
    cols = -exept,
    names_to = c(name, ".value"),
    names_pattern = names_pattern
  )
}


