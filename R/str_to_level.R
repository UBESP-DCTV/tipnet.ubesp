#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
#' coded <- "1, maschio | 2, femmina | 3, ambiguo"
#' levels <- str_to_level(coded)
str_to_level <- function(x) {

  if (is.na(x)) return(character())

  stringr::str_split(x, " \\| ")[[1]] %>%
    stringr::str_remove(pattern = "^.*, ") %>%
    unique()
}
