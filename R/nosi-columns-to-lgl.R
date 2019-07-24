nosi_columns_to_lgl <- function(db) {
    dplyr::mutate_if(db, is.character, ~{
        if (all(
            stringr::str_detect(.,
                "^[sSnN][iI\\u00ec\\u00cc\\u00ed\\u00cdoO]$"
            ),
            na.rm = TRUE
        )) {
            stringr::str_detect(., "^[sS]")
        } else {
            .
        }
    })
}
