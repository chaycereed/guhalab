score_scales <- function(df) {
  # PHQ-9 items in NHANES (DPQ module)
  phq9_items <- c(
    "DPQ010", "DPQ020", "DPQ030",
    "DPQ040", "DPQ050", "DPQ060",
    "DPQ070", "DPQ080", "DPQ090"
  )

  missing_items <- setdiff(phq9_items, names(df))
  if (length(missing_items) > 0) {
    warning(
      "The following PHQ-9 items are missing from the data: ",
      paste(missing_items, collapse = ", ")
    )
  }

  present_items <- intersect(phq9_items, names(df))

  # If none of the PHQ-9 items are present, just return df with NA columns
  if (length(present_items) == 0) {
    df$phq9_valid_items <- NA_integer_
    df$phq9_score       <- NA_real_
    df$phq9_severity    <- NA_character_
    return(df)
  }

  df |>
    dplyr::mutate(
      # how many PHQ-9 items are non-missing?
      phq9_valid_items = rowSums(
        !is.na(dplyr::across(dplyr::all_of(present_items)))
      ),

      # total PHQ-9 score (only if at least 7 valid items)
      phq9_score = dplyr::if_else(
        phq9_valid_items >= 7,
        rowSums(
          dplyr::across(dplyr::all_of(present_items)),
          na.rm = TRUE
        ),
        NA_real_
      ),

      # severity categories based on standard PHQ-9 cutpoints
      phq9_severity = dplyr::case_when(
        is.na(phq9_score)              ~ NA_character_,
        phq9_score <= 4                ~ "Minimal",
        phq9_score <= 9                ~ "Mild",
        phq9_score <= 14               ~ "Moderate",
        phq9_score <= 19               ~ "Moderately severe",
        phq9_score <= 27               ~ "Severe",
        TRUE                           ~ NA_character_
      )
    )
}