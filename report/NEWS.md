# tipnet.ubesp/report (development version)

## Dashboard
* Added dashboard prototype powered by:
  - R Markdown
  - flexdashboard (`flexdashboard::flex_dashboard`)
  - Shiny (`runtime: shiny_prerendered`)

## Long-term report  
* Added report prototype powered by:
  - R Markdown
  - Bookdown (by `output: bookdown::html_document2`)
  - Shiny (`runtime: shiny_prerendered`)

* Title parametrized by the year (for future development)
* Add the **Colphon** (filled with the original one modified including
  UBESP attribution), and the **Reference** (empty at the time) sections

* Allowed support to cross-reference (thanks to
  `bookdown::html_document2`). With this feature enabled you must use
  numbered section.

* Add the same toc of the original document (`toc_dep` limited to 2
  because of `.tabset`, click on tab-index like works only if the
  cliccked entry is currently displayed, this can confuse and I
  preferred to remove third-index navigation)

* Add support for cached created/imported data both for the render- and
  server-sides
  
* Add dynamical plots as examples in the long-term report

* Add support for downloadable report
