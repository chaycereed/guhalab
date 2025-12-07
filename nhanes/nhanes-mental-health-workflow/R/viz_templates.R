viz_theme <- function() {
  ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(face = "bold")
    )
}