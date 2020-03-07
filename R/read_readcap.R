#' Import the data from REDCap
#'
#' Import the data from REDCap repository into two
#' [tibble][tibble::tibble-package], one for the content and one
#' for the main metadata.
#'
#' @param url (chr) the url for the REDCap database
#'   (e.g.: "https://redcap.dctv.unipd.it/api/").
#' @param token (chr) Personal Access Token to the REDCap project
#'
#' @note For `read_redcap()` to function properly, the user must have
#'   Export permissions for the 'Full Data Set'.
#'
#'
#' @return (list) a list with 2 [tibble][tibble::tibble-package]. The
#'   first ("data") contains the data of the study, whereas the other
#'   contains three columns with the names of the variables in `data`,
#'   the names of the form associated to each field and the labels
#'   associated to each field
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   url   <- "https://bbmc.ouhsc.edu/redcap/api/"
#'   token <- "9A81268476645C4E5F03428B8AC3AA7B"
#'   rc <- read_redcap(token = token, url = url)
#' }
#'
read_redcap <- function(url, token = tipnet_token()) {

  assertive::assert_is_a_string(token)
  assertive::assert_is_a_string(url)

  max_n <- 2000

  # Import all the field of ROLEX db
  df <- REDCapR::redcap_read(
    redcap_uri = url,
    token = token,
    batch_size = max_n,
    raw_or_label = "label",
    export_checkbox_label = TRUE,
    export_survey_fields = TRUE,
    guess_type = TRUE,
    guess_max = max_n,
    verbose = FALSE
  )

  meta_data <- REDCapR::redcap_metadata_read(
    redcap_uri = url, token = token,
    verbose = FALSE
  )

  list("data" = df, "meta_data" = meta_data)

}

