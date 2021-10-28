# tipnet.ubesp (development version)

* Fixed (locally) automated report generator
* Used DAG instead of Hospital's name in the static report.
* Fix a bug that prevent variables with levels that incorporate commas
  (e.g., `levels(x) #> [1] "a", "b, c", "d"`) to be parsed correctly.
* Updated version of the script "import-dataset.R"

# tipnet.ubesp 0.0.0.9000
* Added basic development support:
  - git + GitHub;
  - appVeyor + Travis + codecov;
  - gpl3 license;
  - testthat + roxygen2 + spellcheck;
  - `` magrittr::`%>%` `` + `tibble::tibble` + `usethis::ui_*` + 
    `rlang::`;
  - `README.Rmd` + `README.md`.

* Added a `NEWS.md` file to track changes to the package.
