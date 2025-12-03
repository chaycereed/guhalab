clean_variables <- function(df) {
    message("Cleaning variables...")
    df_clean <- df |>
        dplyr::mutate(
            dplyr::across(
                tidyselect::starts_with("DPQ"),
                ~ dplyr::na_if(.x, 7) |> dplyr::na_if(9)
            )
        )
}
