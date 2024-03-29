utils::globalVariables("where")



#' Global / extensive data setup
#'
#' Here put data that should be cached at the server startup, and
#' computed only there once.
#'
#' @export
generate_main_data <- function() {

  tipnet <- fetch_tipnet()
  sheets <- extract_sheets(tipnet)
  full_records <- join_all_sheets(sheets)
  outliers <- extract_outliers(full_records)

  c(sheets, list(full_records = full_records, outliers = outliers))

}








fetch_tipnet <- function() {
  readr::read_rds(file.path(data_path(), "tipnet.rds"))
}








extract_sheets <- function(tipnet) {
  c(
    anagrafica = list(
      get_sheet(tipnet, "anagrafica", field = "anagrafica")
    ),

    purrr::set_names(c(
      "accettazione", "ingresso", "degenza", "infezione", "dimissione",
      "punteggio_di_aristotle", "pelod_scheda_facoltativa", "pim",
      "procedure_di_ventilazione"
    )) %>%
      purrr::map(get_sheet, x = tipnet)
  )
}








join_all_sheets <- function(sheets) {

  sheets[["accettazione"]] %>%
    dplyr::full_join(sheets[["anagrafica"]],
                     by = c("codpat", "center"),
                     suffix = c(".accettazione", ".anagrafica")
    ) %>%

    dplyr::full_join(sheets[["ingresso"]],
                     by = c("codpat", "center", "redcap_repeat_instance")
    ) %>%
    dplyr::full_join(sheets[["pim"]],
                     by = c("codpat", "center", "redcap_repeat_instance"),
                     suffix = c(".ingresso", ".pim")
    ) %>%

    dplyr::full_join(sheets[["pelod_scheda_facoltativa"]],
                     by = c("codpat", "center", "redcap_repeat_instance")
    ) %>%
    dplyr::full_join(sheets[["punteggio_di_aristotle"]],
                     by = c("codpat", "center", "redcap_repeat_instance"),
                     suffix = c(".pelod", ".aristotle")
    ) %>%

    dplyr::full_join(sheets[["degenza"]],
                     by = c("codpat", "center", "redcap_repeat_instance")
    ) %>%
    dplyr::full_join(sheets[["procedure_di_ventilazione"]],
                     by = c("codpat", "center", "redcap_repeat_instance"),
                     suffix = c(".degenza", ".ventilazione")
    ) %>%

    dplyr::full_join(sheets[["infezione"]],
                     by = c("codpat", "center", "redcap_repeat_instance")
    ) %>%
    dplyr::full_join(sheets[["dimissione"]],
                     by = c("codpat", "center", "redcap_repeat_instance"),
                     suffix = c(".infezione", ".dimissione")
    ) %>%

    dplyr::mutate_at(
      dplyr::vars(dplyr::starts_with("complete")), ~{
        . == "complete"
      }
    ) %>%
    dplyr::mutate(
      codpat = as.factor(.data$codpat),
      eta = as.integer(.data[["eta"]]),
      age_class = factor(
        dplyr::case_when(
          .data[["eta"]] >  18 ~ "eta > 18",
          .data[["eta"]] >  16 ~ "16 < eta <= 18",
          .data[["eta"]] >=  0 ~ "0 <= eta <= 16",
          TRUE ~ "[wrong/missing age]"
        )
      ),
      complete =
        .data[["complete.anagrafica"]] &
        .data[["complete.accettazione"]] &
        .data[["complete.pim"]] &
        .data[["complete.dimissione"]]
    )
}








extract_outliers <- function(full_records) {

  full_records[["codpat"]] <- as.character(full_records[["codpat"]])
  full_records[["center"]] <- as.character(full_records[["center"]])

  aux_out <- full_records %>%
    dplyr::select(
      .data$center, .data$codpat, .data$redcap_repeat_instance,
      where(is.numeric)
    ) %>%
    dplyr::mutate_at(
      dplyr::vars(
        -.data$center, -.data$codpat, -.data$redcap_repeat_instance
      ),
      ~ abs(. - median(., na.rm = TRUE)) >
        1.5 * diff(quantile(., probs = c(0.25, 0.75), na.rm = TRUE))
    ) %>%
    janitor::remove_empty("cols") %>%
    dplyr::select(
      .data$center, .data$codpat, .data$redcap_repeat_instance,
      where(~any(. == TRUE, na.rm = TRUE))
    ) %>%
    tidyr::pivot_longer(
      -c(.data$center, .data$codpat, .data$redcap_repeat_instance),
      names_to = "variable"
    ) %>%
    dplyr::group_by(.data$center) %>%
    dplyr::mutate(
      n = dplyr::n()
    ) %>%
    dplyr::ungroup() %>%
    dplyr::filter(.data$value) %>%
    dplyr::select(-.data$value)



  data_lst <- unclass(full_records)


  aux_out %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      value = extract_value(data_lst,
        .data[["codpat"]],
        .data[["redcap_repeat_instance"]],
        .data[["variable"]]
      )
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      dplyr::across(c("center", "codpat", "variable"), as.factor)
    ) %>%
    dplyr::nest_by(.data$center) %>%
    dplyr::mutate(
      n_outliers = nrow(.data$data),
      prop_outliers = .data$n_outliers / .data$data[["n"]][[1L]],
      data = list(dplyr::select(.data$data, -.data$n))
    ) %>%
    dplyr::ungroup()
}








extract_value <- function(data_lst, codpat, instance, variable) {

  cod <- data_lst[["codpat"]] == codpat

  if (sum(cod) == 1L) {
    data_lst[[variable]][cod]
  } else {
    rep <- data_lst[["redcap_repeat_instance"]] == instance
    data_lst[[variable]][cod & rep]
  }
}
