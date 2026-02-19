#' Detect variable types in a dataframe
#'
#' Identifies numeric, binary, and time variables automatically.
#'
#' @param df A data frame
#' @return A list with elements: numeric, binary, time, n_rows, n_cols
#' @export
detect_dataset <- function(df) {
  numeric_vars <- names(df)[sapply(df, is.numeric)]

  binary_vars <- numeric_vars[sapply(df[numeric_vars], function(x)
    all(na.omit(unique(x)) %in% c(0, 1))
  )]

  time_vars <- names(df)[
    sapply(seq_along(df), function(i) {
      inherits(df[[i]], c("POSIXct", "POSIXt", "Date", "POSIXlt", "hms", "difftime")) ||
        (is.numeric(df[[i]]) &&
           grepl("time|sec|sample|min|hour", tolower(names(df)[i]))) ||
        (is.character(df[[i]]) &&
           any(grepl("\\d{2}:\\d{2}", df[[i]][1:min(10, nrow(df))]), na.rm = TRUE))
    })
  ]

  list(
    numeric = numeric_vars,
    binary  = binary_vars,
    time    = time_vars,
    n_rows  = nrow(df),
    n_cols  = ncol(df)
  )
}
