#' Extract field from REDCap db
#'
#' @param data (list) the output of [read_redcap]
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
          sheets_to_var(exept = "codpat") %>%
          tidyr::nest(tables = -.data$sheets) %>%
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


sheets_to_var <- function(data, name = "sheets", exept = NULL) {

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


tidy_data_extraction <- function(data) {
  tibble::as_tibble(data[["data"]][["data"]]) %>%
    janitor::clean_names() %>%
    dplyr::mutate_if(is.character, tolower) %>%
    dplyr::rename(fields = .data$redcap_event_name)
}
