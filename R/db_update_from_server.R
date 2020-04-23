#' Pull REDCap data from the server
#'
#' @param path_data (chr) path for data folder (default is `data/`
#'   under the current project or the [here][here::here] path, if it not
#'   exists it will be created)
#' @param file_name (chr) name for the file to store the data
#'
#' @return (lgl) `TRUE` if success, `FALSE` otherwise
#' @export
#'
#' @examples
#' \dontrun{
#'   db_update_from_server()
#' }
db_update_from_server <- function(path_data = NULL,
                                  file_name = "tipnet.rds"
) {

  path_data <- path_data %||% data_path()

  file_path <- file.path(path_data, file_name)

  tipnet_raw <- read_redcap(tipnet_redcap_url())
  all_ok <- tipnet_raw$data$success && tipnet_raw$meta_data$success

  if (!all_ok) {
    ui_warn("Connection error to REDCap (in server-start chunk).")
    return(invisible(file_path))
  }

  tipnet <- tipnet_raw %>%
    tidy_extract("data") %>%
    nest_tables() %>%
    dplyr::mutate(
      tables = purrr::map2(
        .x = .data$sheet,
        .y = .data$tables,
        .f = factorize_sheet,
        meta = tidy_extract(tipnet_raw, "meta")
      )
    )

  readr::write_rds(tipnet, path = file_path)

  invisible(file_path)

}

