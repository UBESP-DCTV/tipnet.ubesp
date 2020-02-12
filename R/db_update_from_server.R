#' Title
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
db_update_from_server <- function(path_data = data_path(),
                                  file_name = "tipnet.rds"
) {

  file_path <- file.path(path_data, file_name)

  tipnet_raw <- read_redcap(tipnet_redcap_url())
  all_ok <- tipnet_raw$data$success && tipnet_raw$meta_data$success

  if (all_ok) {
    tipnet_raw %>%
      nest_tables() %>%
      readr::write_rds(path = file_path)

    return(invisible(TRUE))

  } else {
    ui_warn("Connection error to REDCap (in server-start chunk).")
    return(invisible(FALSE))
  }

}

