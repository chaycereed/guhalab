clean_variables <- function(df) {
  message("Cleaning variables...")

  recode_dpq <- function(x) {
    # Handle factors / characters / whatever nhanesA gives us
    x_chr <- as.character(x)
    x_chr <- trimws(x_chr)

    dplyr::case_when(
      x_chr == "Not at all"               ~ 0,
      x_chr == "Several days"             ~ 1,
      x_chr == "More than half the days"  ~ 2,
      x_chr == "Nearly every day"         ~ 3,
      x_chr %in% c("Refused", "Don't know") ~ NA_real_,
      x_chr == ""                         ~ NA_real_,
      TRUE                                ~ NA_real_  # unexpected value → NA
    )
  }

  df |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::starts_with("DPQ"),
        recode_dpq
      )
    )
}