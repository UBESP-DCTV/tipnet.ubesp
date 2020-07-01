tipnet_token <- function() {
  val <- Sys.getenv("REDCAP_TIPNET_PAT")
  if (identical(val, "")) {
    stop("`REDCAP_TIPNET_PAT` env var has not been set")
  }
  val
}


`%||%` <- function(x, y) if (is.null(x)) y else x


skip_if_no_auth <- function() {
  if (identical(Sys.getenv("REDCAP_TIPNET_PAT"), "")) {
    testthat::skip("No authentication available")
  }
}



#' Path to the data folder
#'
#' @return Path to the data folder
#' @export
#'
#' @examples
#' data_path()
data_path <- function() {
  current_folder <- basename(here::here())
  path_to_data <- switch(current_folder,
    "tipnet.ubesp" = here::here("../data"),
    "report"       = here::here("../../data"),
    current_folder
  )

  if (path_to_data == current_folder) stop(current_folder)

  fs::dir_create(path_to_data)
}
