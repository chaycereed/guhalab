#' Load NHANES data for selected variables and cycles
#'
#' @param variables Character vector of variable names (e.g., DPQ010–DPQ090).
#' @param cycles Character vector of cycles, e.g. "2011-2012", "2013-2014", "2015-2016", "2017-2018".
#' @param component NHANES component prefix (default "DPQ" for depression screener).
#' @param data_dir Directory containing .XPT files when use_nhanesA = FALSE.
#' @param use_nhanesA Logical; if TRUE, load via nhanesA::nhanes() instead of local XPT files.
#'
#' @return A tibble with SEQN, requested variables, and a `cycle` column.
#'

load_nhanes <- function(
    variables, 
    cycles = c("2017-2018"), 
    component = "DPQ",
    data_dir = "data", 
    use_nhanesA = FALSE
) {

    # convert cycles into file prefixes
    cycle_map <- list(
    "1999-2000" = "D",
    "2001-2002" = "E",
    "2003-2004" = "F",
    "2005-2006" = "G",
    "2007-2008" = "H",
    "2009-2010" = "I",
    "2011-2012" = "J",
    "2013-2014" = "K",
    "2015-2016" = "N",
    "2017-2018" = "P",
    "2019-2020" = "Q"
    )

    unknown_cycles <- setdiff(cycles, names(cycle_map))
    if (length(unknown_cycles) > 0) {
        stop(
            "Unsupported cycle(s): ",
            paste(unknown_cycles, collapse = ", "),
            ". Update cycle_map in load_nhanes if needed."
        )
    }

    if (use_nhanesA && !requireNamespace("nhanesA", quietly = TRUE)) {
        stop("Package 'nhanesA' is required when use_nhanesA = TRUE. Please install it.")
    }
    if (!requireNamespace("haven", quietly = TRUE)) {
        stop("Package 'haven' is required to read XPT files. Please install it.")
    }
    if (!requireNamespace("dplyr", quietly = TRUE)) {
        stop("Package 'dplyr' is required. Please install it.")
    }

    load_one_cycle <- function(cycle_label) {
    suffix <- cycle_map[[cycle_label]]

    if (use_nhanesA) {
      # e.g. "DPQ_J"
      table_name <- paste0(component, "_", suffix)
      message("Loading data...")
      df <- nhanesA::nhanes(table_name)
    } else {
      # e.g. "data/DPQ_J.XPT"
      file_path <- file.path(data_dir, paste0(component, "_", suffix, ".XPT"))
      if (!file.exists(file_path)) {
        stop("File not found: ", file_path)
      }
      message("Loading data...")
      df <- haven::read_xpt(file_path)
    }

    # keep SEQN + requested variables (if present)
    cols_available <- intersect(variables, names(df))
    cols_to_keep   <- union("SEQN", cols_available)

    if (!"SEQN" %in% names(df)) {
      warning("SEQN not found in file for cycle ", cycle_label, ". Returning all columns.")
      df_out <- df
    } else {
      df_out <- df[, cols_to_keep, drop = FALSE]
    }

    df_out$cycle <- cycle_label
    df_out
  }

  dfs <- lapply(cycles, load_one_cycle)
  dplyr::bind_rows(dfs)
}