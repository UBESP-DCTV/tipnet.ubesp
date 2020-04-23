generate_main_data <- function() {

  tipnet <- if (fs::dir_exists(file.path(tipnet.ubesp:::data_path(), "..", "report"))) {
    readr::read_rds(file.path(tipnet.ubesp:::data_path(), "..", "report", "data", "tipnet.rds"))
  } else {
    readr::read_rds(file.path(tipnet.ubesp:::data_path(), "tipnet.rds"))
  }

  anagrafica   <- get_sheet(tipnet, "anagrafica")
  accettazione <- get_sheet(tipnet, "accettazione")
  ingresso     <- get_sheet(tipnet, "ingresso")
  pim          <- get_sheet(tipnet, "pim")
  pelod        <- get_sheet(tipnet, "pelod")
  aristotle    <- get_sheet(tipnet, "punteggio_di_aristotle")
  degenza      <- get_sheet(tipnet, "degenza")
  ventilazione <- get_sheet(tipnet, "procedure_di_ventilazione")
  infezione    <- get_sheet(tipnet, "infezione")
  dimissione   <- get_sheet(tipnet, "dimissione")


  full_records <- accettazione %>%
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
      eta = as.integer(.data$eta),
      age_class = factor(
        dplyr::case_when(
          eta > 18 ~ "eta > 18",
          eta > 16 ~ "16 < eta <= 18",
          eta >= 0 ~ "0 <= eta <= 16",
          TRUE ~ "[wrong/missing age]"
        )
      ),
      complete = .data$complete.anagrafica &
        .data$complete.accettazione &
        .data$complete.pim &
        .data$complete.dimissione
    )

  outliers <- full_records %>%
    dplyr::group_by(.data$center, .data$codpat, .data$redcap_repeat_instance) %>%
    dplyr::select_if(is.numeric) %>%
    dplyr::ungroup() %>%
    dplyr::mutate_at(
      dplyr::vars(-.data$center, -.data$codpat, -.data$redcap_repeat_instance),
      ~ abs(. - median(., na.rm = TRUE)) >
        1.5 * diff(stats::quantile(., probs = c(0.25, 0.75), na.rm = TRUE))
    ) %>%
    janitor::remove_empty("cols") %>%
    dplyr::group_by(.data$center, .data$codpat, .data$redcap_repeat_instance) %>%
    dplyr::select_if(~any(. == TRUE, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    tidyr::pivot_longer(-c(.data$center, .data$codpat, .data$redcap_repeat_instance)) %>%
    dplyr::group_by(.data$center) %>%
    dplyr::mutate(n = dplyr::n()) %>%
    dplyr::filter(.data$value) %>%
    dplyr::summarize(
      n_outliers = dplyr::n(),
      prop_outliers = round(.data$n_outliers / unique(.data$n), 2),
      codpats = list(tibble::tibble(
        codpat = codpat,
        var = name,
        rep_instance = redcap_repeat_instance,
        value = purrr::pmap_dbl(
          list(x = codpat, y = var, z = rep_instance, c = center),
          function(x, y, z, c) {
            res <- full_records %>%
              dplyr::filter(
                codpat == x,
                redcap_repeat_instance == z,
                center == c
              )
            res[[y]]
          }
        )
      ))
    )


  list(
    anagrafica   = anagrafica  ,
    accettazione = accettazione,
    ingresso     = ingresso    ,
    pim          = pim         ,
    pelod        = pelod       ,
    aristotle    = aristotle   ,
    degenza      = degenza     ,
    ventilazione = ventilazione,
    infezione    = infezione   ,
    dimissione   = dimissione  ,
    full_records = full_records,
    outliers     = outliers
  )

}
