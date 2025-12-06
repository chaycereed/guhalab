load_nhanes <- function(
  variables,
  cycles      = c("2017-2018"),
  component   = "DPQ",
  data_dir    = "data",
  use_nhanesA = FALSE
) {
  # Dependencies
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required.")
  }
  if (use_nhanesA) {
    if (!requireNamespace("nhanesA", quietly = TRUE)) {
      stop("Package 'nhanesA' is required when use_nhanesA = TRUE.")
    }
  } else {
    if (!requireNamespace("haven", quietly = TRUE)) {
      stop("Package 'haven' is required to read XPT files.")
    }
  }

  # Map cycle labels to file suffixes / NHANES table suffixes
  # Adjust these if your filenames or table names differ.
  cycle_map <- c(
    "2015-2016" = "I",
    "2017-2018" = "J"
  )

  unknown_cycles <- setdiff(cycles, names(cycle_map))
  if (length(unknown_cycles) > 0) {
    stop(
      "Unsupported cycle(s): ",
      paste(unknown_cycles, collapse = ", "),
      "\nSupported cycles are: ",
      paste(names(cycle_map), collapse = ", ")
    )
  }

  # Helper: load one cycle either via nhanesA or local XPT
  load_one_cycle <- function(cycle_label) {
    suffix <- cycle_map[[cycle_label]]

    if (use_nhanesA) {
      table_name <- paste0(component, "_", suffix)
      message("Loading via nhanesA: ", table_name)

      df <- nhanesA::nhanes(table_name)

      # Catch the "0-length download" case more explicitly
      if (is.null(df) || nrow(df) == 0L) {
        stop(
          "nhanesA::nhanes('", table_name, "') returned no rows.\n",
          "Check that the table exists and that nhanesA can download it."
        )
      }

    } else {
      file_path <- file.path(data_dir, paste0(component, "_", suffix, ".XPT"))
      message("Loading local XPT: ", file_path)

      if (!file.exists(file_path)) {
        stop("File not found: ", file_path)
      }

      df <- haven::read_xpt(file_path)
    }

    # Keep SEQN + requested variables where possible
    cols_available <- intersect(variables, names(df))
    cols_to_keep   <- union("SEQN", cols_available)

    if (!"SEQN" %in% names(df)) {
      warning("SEQN not found for cycle ", cycle_label, ". Returning only requested variables.")
      df_out <- df[, cols_available, drop = FALSE]
    } else {
      df_out <- df[, cols_to_keep, drop = FALSE]
    }

    df_out$cycle <- cycle_label
    df_out
  }

  dfs <- lapply(cycles, load_one_cycle)
  dplyr::bind_rows(dfs)
}