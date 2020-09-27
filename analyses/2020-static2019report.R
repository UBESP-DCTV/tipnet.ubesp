#' ---
#' title: "TIP-Net"
#' subtitle: "Report dati `r params$year`"
#' author: "Unità di Biostatistica, Epidemiologia, e Sanità Pubblica<br>Dipartimento di Scienze Cardio-Toraco-Vascolari e Sanità Pubblica<br>University of Padova"
#' date: "Data di creazione del report: `r Sys.Date()` (ver. 0.2.0)"
#' output:
#'   bookdown::html_document2:
#'     toc: true
#'     toc_float: true
#'     keep_md: true
#'     fig_width: 10
#'     fig_height: 5
#'     fig_caption: true
#'
#' params:
#'   year: 2019
#' ---
#'
#'
#' ```{r setup, include=FALSE}
#' knitr::opts_chunk$set(
#'
#'     echo = FALSE,
#'     comment = "",
#'     collapse = TRUE,
#'     warning = FALSE,
#'     message = FALSE,
#'
#'     out.width  = "100%",  # part of output covered
#'     dpi = 192              # set output resolution (impact weight)
#' )
#'
#' options(width = 150)
#' set.seed(1)
#' ```
#'

#+ echo=FALSE
htmltools::img(
  src = knitr::image_uri("img/ubep_logo.jpg"),
  alt = 'logo',
  style = 'position:absolute; top:0; right:0; padding:10px',
  width = '15%')




if (interactive()) {
  params <- list(year = 2019)
}
#+ pkg, include = FALSE

suppressPackageStartupMessages({

  # load project functions
  if (
    fs::file_exists(here::here("tipnet.ubesp.Rproj")) &&
    fs::file_exists(here::here("DESCRIPTION"))
  ) {
    devtools::load_all(quiet = FALSE)
  } else {
    # remotes::install_github("UBESP-DCTV/tipnet.ubesp")
    library(tipnet.ubesp)
  }

  # data management
  library(tidyverse)
  library(lubridate)
  library(janitor)

  # utilities
  library(depigner)
  library(glue)
  library(here)

  # rendering
  library(pander)
  panderOptions("round", 2)
  panderOptions("knitr.auto.asis", FALSE)
  panderOptions("table.split.table", Inf)
  panderOptions("table.alignment.default",
                function(df) c("left", rep("center", length(df) - 1L))
  )

  # data analyses
  library(rms)
  options(datadist = "dd")

})


#+ data-load
data_dir <- "../tipnet-data"
# db_update_from_server(data_dir)


tip_data <- read_rds(here(data_dir, "2020-09-24-tipnet.rds"))

#'
#' # Preambolo
#'
#' Il seguente report riporta misure di sintesi dei dati della rete
#' TIP-Net per l'anno `r params$year`. Nel capitolo \@ref(general) sono
#' riportate le sintesi per l'intera rete TIP-Net, mentre nel capitolo
#' \@ref(centers) sono riportate le sintesi divise, in ciascuna
#' sezione, per centro.
#'
#' Per ogni sezione (sia generale che per i centri) sono disponibili tre
#' tab (accessibili facendo _click_ sul loro nome):
#'
#'  - **Accettazione**: distribuzioni e caratteristiche per `genere` ed
#'    `etnia`
#'  - **Descrittive**: per ciascuna caratteristica di interesse si
#'    riportano la numerosità (N = dati non mancanti), la distribuzione
#'    (I, II, e III quartile) con media e deviazione standard per le
#'    variabili continue, mentre frequenza e numerosità assoluta per le
#'    variabili discrete. Tutte le metriche sono riportate sia
#'    stratificate per sesso (_maschio_ o _femmina_), che globali
#'    (_combined_)
#'  - **SMR**: _Standardized Mortality Rate_ riportate sia relativamente
#'    allo score `PIM2` che `PIM3`.
#'

#'
#' # Report generale {#general}
#' ## TIP-Net {.tabset .tabset-fade .tabset-pills}
#'
anagrafica <- tip_data[[3]][[1]] %>%
  select(codpat, gender, etnia, center)

label(anagrafica, self = FALSE) <- c(
  "Codice paziente", "Sesso", "Etnia", "Centro")




accettazione <- tip_data[[3]][[3]] %>%
  filter(year(ingresso_dt) == params$year) %>%
  select(
    codpat, eta_giorni, priorita, ricovero_progr, tipologia,
    motivo_ricovero, redcap_repeat_instance, mal_cronica, center) %>%
  mutate(
    age_class = case_when(
      is.na(eta_giorni) ~ "missing",
      eta_giorni < 0 ~ "giorni negativi",
      eta_giorni <= 30 ~ "neonati",
      eta_giorni <= 365.25 ~ "lattanti",
      eta_giorni <= 365.25 * 5 ~ "prescolare",
      eta_giorni <= 365.25 * 12 ~ "scolare",
      eta_giorni <= 365.25 * 18 ~ "adolescente",
      eta_giorni > 365.25 * 18 ~ "adulto",
      TRUE ~ as.character(eta_giorni)
    )
  )

label(accettazione, self = FALSE) <- c(
  "Codice paziente", "Età (giorni)", "Priorità", "Ricovero programmato",
  "Tipologia di ricovero", "Motivo del ricovero", "Redcap rep-id",
  "Comorbidità", "Centro", "Classe di età")




pim <- tip_data[[3]][[5]] %>%
  select(codpat, pim2, pim3, redcap_repeat_instance)


label(pim, self = FALSE) <- c(
  "Codice paziente", "PIM 2", "PIM 3", "Redcap rep-id")




ventilazione <- tip_data[[3]][[9]] %>%
  select(codpat, tecnica_1, redcap_repeat_instance)

label(ventilazione, self = FALSE) <- c(
  "Codice paziente", "Tecnica di ventilazione", "Redcap rep-id")




infezione <- tip_data[[3]][[10]] %>%
  select(codpat, tipo_inf, redcap_repeat_instance)

label(infezione, self = FALSE) <- c(
  "Codice paziente", "Tipologia di infezione", "Redcap rep-id")




dimissione <- tip_data[[3]][[13]] %>%
  select(codpat, durata_degenza, mod_decesso, esito_tip,
         diagnosi, redcap_repeat_instance)

label(dimissione, self = FALSE) <- c(
  "Codice paziente", "Durata della degenza", "Modalità di decesso",
  "Esito TIP", "Diagnosi", "Redcap rep-id")




data_to_describe <- left_join(accettazione, pim) %>%
  left_join(ventilazione) %>%
  left_join(infezione) %>%
  left_join(dimissione) %>%
  left_join(anagrafica) %>%
  select(-etnia)


eval_summaries <- function(tip_data, current_center = NULL) {

  if (!is_null(current_center)) {
    tip_data <- tip_data %>%
      dplyr::filter(center == current_center)
  }

  if (!nrow(tip_data)) return(NULL)

  tip_data <- select(tip_data, -center)

  Accettazione <- anagrafica %>%
    inner_join(accettazione) %>%
    select(gender, etnia)

  names(Accettazione) <- label(Accettazione)
  label(Accettazione, self = FALSE) <- c("", "")

  desc_base <- describe(Accettazione)

  desc_tip <- summary(
      formula =  gender ~ .,
      data = select(tip_data, -codpat, -redcap_repeat_instance) %>%
        remove_empty(),
      method = "reverse",
      overall = TRUE,
      continue = 3
    ) %>%
    tidy_summary(digits = 3, exclude1 = FALSE, long = TRUE, prmsd = TRUE)


  smr <- data_to_describe %>%
    summarise(
      SMR_pim2 = sum(esito_tip == "morto", na.rm = TRUE) /
        (sum(pim2, na.rm = TRUE)/100),
      SMR_pim3 = sum(esito_tip == "morto", na.rm = TRUE) /
        (sum(pim3, na.rm = TRUE)/100)
    )

  list(desc_base = desc_base, desc_tip = desc_tip, smr = smr)

}

safe_eval <- safely(eval_summaries)

overall <- safe_eval(data_to_describe)

#'
#' ### Accettazione
#'
html(overall[["result"]][[1]], header = c("a", "b"))

#'
#' ### Descrittive
#'
#+ results='asis'
pander(overall[["result"]][[2]])

#'
#' ### SMR
#'
#+ results='asis'
cat(
  " \nSMR PIM2 (overall): ", round(overall[['result']][[3]][[1]], 2), "\n",
  " \nSMR PIM3 (overall): ", round(overall[['result']][[3]][[2]], 2), "\n\n"
)


centers <- sort(levels(data_to_describe$center)) %>%
  set_names()

center_summaries <- centers %>%
  purrr::map(safe_eval, tip_data = data_to_describe)


# aa <- transpose(center_summaries)

#'
#' # Report centri {#centers}
#'

#+ results='asis'
iwalk(center_summaries, ~{

  cat(" \n## ", .y, " {.tabset .tabset-fade .tabset-pills} \n")

  if (is.null(.x[['result']])) {
    cat(" \n > no data for this center \n\n")
  } else {

    cat(" \n### Accettazione \n")
    cat(" \n", html(.x[["result"]][[1]]), " \n")

    cat(" \n### Descrittive \n")
    cat(
      " \n",
      pander(.x[["result"]][[2]]),
      " \n"
    )

    cat(" \n### SMR \n")
    cat(
      " \nSMR PIM2 (overall): ", round(.x[['result']][[3]][[1]], 2), "\n",
      " \nSMR PIM3 (overall): ", round(.x[['result']][[3]][[2]], 2), "\n\n"
    )
  }
})
