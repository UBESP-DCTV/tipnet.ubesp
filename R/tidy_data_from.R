#' Tidy data from full REDcap extraction
#'
#'
#' @param x (lst) result of a call to \code{\link{read_redcap}}
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#'
tidy_data_from <- function(x) {

  tipnet <- x[["data"]][["data"]] %>%
    as_tibble() %>%
    janitor::clean_names() %>%
    janitor::remove_empty("cols") %>%
    mutate_all(parse_guess, guess_integer = TRUE)

  glimpse(tipnet)

  tipnet_meta <- x[["meta_data"]][["data"]] %>%
    as_tibble() %>%
    janitor::clean_names() %>%
    janitor::remove_empty("cols")

  tipnet_meta[["select_choices_or_calculations"]] %>%
    is.na()

  glimpse(tipnet_meta)

}
