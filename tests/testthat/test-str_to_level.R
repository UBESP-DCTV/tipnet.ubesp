test_that("str_to_level works", {
  coded_simple <- "1, maschio | 2, femmina | 3, ambiguo"
  coded_spaced <- "1, caucasica | 2, ispanica | 3, asiatica | 4, africana | 5, araba | 6, etnia mista"
  coded_na <- NA_character_
  coded_duplicate <- "1, a | 2, b | 3, a"

  expected_simple <- c("maschio", "femmina", "ambiguo")
  expected_spaced <- c("caucasica", "ispanica", "asiatica", "africana", "araba", "etnia mista")
  expected_na <- character()
  expected_duplicate <- c("a", "b")

  expect_equal(str_to_level(coded_simple), expected_simple)
  expect_equal(str_to_level(coded_spaced), expected_spaced)
  expect_equal(str_to_level(coded_na), expected_na)
  expect_equal(str_to_level(coded_duplicate), expected_duplicate)
})
