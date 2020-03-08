put_main_data_in_ws <- function() {

  tipnet <- if (fs::dir_exists(file.path(data_path(), "..", "report"))) {
    readr::read_rds(file.path(data_path(), "..", "report", "data", "tipnet.rds"))
  } else {
    readr::read_rds(file.path(data_path(), "tipnet.rds"))
  }

  anagrafica   <<- get_sheet(tipnet, "anagrafica")
  accettazione <<- get_sheet(tipnet, "accettazione")
  ingresso     <<- get_sheet(tipnet, "ingresso")
  pim          <<- get_sheet(tipnet, "pim")
  pelod        <<- get_sheet(tipnet, "pelod")
  aristotle    <<- get_sheet(tipnet, "punteggio_di_aristotle")
  degenza      <<- get_sheet(tipnet, "degenza")
  ventilazione <<- get_sheet(tipnet, "procedure_di_ventilazione")
  infezione    <<- get_sheet(tipnet, "infezione")
  dimissione   <<- get_sheet(tipnet, "dimissione")


  full_records <<- accettazione %>%
    dplyr::full_join(anagrafica,
              by = c("codpat", "center"),
              suffix = c(".accettazione", ".anagrafica")
    ) %>%

    dplyr::full_join(ingresso, by = c("codpat", "center", "redcap_repeat_instance")) %>%
    dplyr::full_join(pim,
              by = c("codpat", "center", "redcap_repeat_instance"),
              suffix = c(".ingresso", ".pim")
    ) %>%

    dplyr::full_join(pelod, by = c("codpat", "center", "redcap_repeat_instance")) %>%
    dplyr::full_join(aristotle,
              by = c("codpat", "center", "redcap_repeat_instance"),
              suffix = c(".pelod", ".aristotle")
    ) %>%

    dplyr::full_join(degenza, by = c("codpat", "center", "redcap_repeat_instance")) %>%
    dplyr::full_join(ventilazione,
              by = c("codpat", "center", "redcap_repeat_instance"),
              suffix = c(".degenza", ".ventilazione")
    ) %>%

    dplyr::full_join(infezione, by = c("codpat", "center", "redcap_repeat_instance")) %>%
    dplyr::full_join(dimissione,
              by = c("codpat", "center", "redcap_repeat_instance"),
              suffix = c(".infezione", ".dimissione")
    ) %>%

    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("complete")), ~{. == "complete"}) %>%
    dplyr::mutate(
      eta = as.integer(eta),
      age_class = factor(
        dplyr::case_when(
          eta > 18 ~ "eta > 18",
          eta > 16 ~ "16 < eta <= 18",
          eta >= 0 ~ "0 <= eta <= 16",
          TRUE ~ "[wrong/missing age]"
        )
      ),
      complete = complete.anagrafica &
        complete.accettazione &
        complete.pim &
        complete.dimissione
    )
}
