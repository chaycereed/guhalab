viz_theme <- function() {
  ggplot2::theme_minimal(base_size = 14, base_family = "Helvetica") +
    ggplot2::theme(
      # Title and subtitle
      plot.title = ggplot2::element_text(
        face = "bold",
        size = 18,
        hjust = 0.5,
        margin = ggplot2::margin(b = 8)
      ),
      plot.subtitle = ggplot2::element_text(
        size = 14,
        hjust = 0.5,
        margin = ggplot2::margin(b = 12)
      ),

      # Axis text + titles
      axis.title = ggplot2::element_text(
        size = 14,
        face = "bold"
      ),
      axis.text = ggplot2::element_text(
        size = 12,
        color = "#4A4A4A"
      ),

      # Panel styling
      panel.grid.major = ggplot2::element_line(color = "#E0E0E0"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),

      # Legend
      legend.title = ggplot2::element_text(face = "bold"),
      legend.background = ggplot2::element_blank(),

      # Margins
      plot.margin = ggplot2::margin(12, 12, 12, 12)
    )
}