score_scales <- function(df) {
    message("Scoring...")
    df |> 
    dplyr::mutate(
        phq9_score = rowSums(
        dplyr::across(dplyr::starts_with("DPQ")),
        na.rm = TRUE
        )
    )
}