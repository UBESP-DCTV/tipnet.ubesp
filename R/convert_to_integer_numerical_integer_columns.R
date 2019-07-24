convert_to_integer_numerical_integer_columns <- function(db) {
    dplyr::mutate_if(db, is.numeric, ~{
        if (all(
            assertive::is_whole_number(.,
                tol = 200 * .Machine$double.eps
            ),
            na.rm = TRUE
        )) {
            convert_to_integer(.)
        } else .
    })
}

convert_to_integer <- function(x) {
    nm <- names(x)

    assertive::coerce_to(x, "numeric") %>%
        # round is needed to correctly parse below approximation, e.g.,
        # without `round()`, `as.integer()` will trunc, e.g.,
        # 1/(1 - 0.98) become 49
        round() %>%
        as.integer() %>%
        purrr::set_names(nm)
}
