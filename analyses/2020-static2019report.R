#' ---
#' title: "TIP-Net static report"
#' subtitle: "2019"
#' author: "Corrado Lanera -- UBEP/UniPD"
#' date: "Padova, `r Sys.Date()`"
#' output:
#'   bookdown::html_document2:
#'     toc: true
#'     toc_float: true
#'     keep_md: true
#'     fig_width: 10
#'     fig_height: 5
#'     fig_caption: true
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

#' # Overall TIP-Net
anagrafica <- tip_data[[3]][[1]] %>%
  select(codpat, gender, etnia)

accettazione <- tip_data[[3]][[3]] %>%
  filter(year(ingresso_dt) == 2019) %>%
  select(
    codpat, eta_giorni, priorita, ricovero_progr, tipologia,
    motivo_ricovero, redcap_repeat_instance) %>%
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


# presenza comorbidità ??

pim <- tip_data[[3]][[5]] %>%
  select(codpat, pim2, pim3, redcap_repeat_instance)


ventilazione <- tip_data[[3]][[9]] %>%
  select(codpat, tecnica_1, redcap_repeat_instance)


infezione <- tip_data[[3]][[10]] %>%
  select(codpat, tipo_inf, redcap_repeat_instance)

dimissione <- tip_data[[3]][[13]] %>%
  select(codpat, durata_degenza, esito_osp, mod_decesso, esito_tip,
         diagnosi, redcap_repeat_instance)


data_to_describe <- left_join(accettazione, pim) %>%
  left_join(ventilazione) %>%
  left_join(infezione) %>%
  left_join(dimissione) %>%
  left_join(anagrafica) %>%
  select(-etnia)

#' ## Anagrafica
#'
#' > n = pazienti
#'
html(describe(
  anagrafica %>%
    inner_join(accettazione) %>%
    select(gender, etnia)
))


#' ## Descrittive principali
#'
#' > n = ingressi
#'
dd <- rms::datadist(data_to_describe)
desc_tip <- summary(
    formula =  gender ~ .,
    data = select(data_to_describe, -codpat, -redcap_repeat_instance),
    method = "reverse",
    overall = TRUE,
    continue = 4
  ) %>%
  tidy_summary(digits = 3, exclude1 = FALSE, long = TRUE, prmsd = TRUE)

pander(desc_tip)
