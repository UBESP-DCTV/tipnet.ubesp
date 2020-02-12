tipnet_token <- function() {
  val <- Sys.getenv("REDCAP_TIPNET_PAT")
  if (identical(val, "")) {
    stop("`REDCAP_TIPNET_PAT` env var has not been set")
  }
  val
}


`%||%` <- function(x, y) if (is.null(x)) y else x


skip_if_no_auth <- function() {
  if (identical(Sys.getenv("REDCAP_TIPNET_PAT"), "")) {
    skip("No authentication available")
  }
}

