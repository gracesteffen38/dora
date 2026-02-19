#' Extract event window indices from a binary vector
#' @param event Binary numeric vector
#' @return Data frame with start and end columns
#' @export
extract_event_windows_idx <- function(event){
  r <- rle(event)
  ends <- cumsum(r$lengths)
  starts <- ends - r$lengths + 1
  idx <- which(r$values == 1)
  data.frame(start = starts[idx], end = ends[idx])
}
#' Validate an ID variable in a dataframe
#' @param df A data frame
#' @param col_name Name of the column to validate
#' @return NULL if valid, error string if not
#' @export
validate_id_variable <- function(df, col_name) {
  # Robust check for empty/null selections or length 0 vectors
  if (is.null(col_name) || length(col_name) == 0 || is.na(col_name) || col_name == "") {
    return("No ID variable selected.")
  }

  # Check if column exists
  if (!col_name %in% names(df)) {
    return("Selected ID variable not found in dataset.")
  }

  vals <- na.omit(df[[col_name]])
  n_unique <- length(unique(vals))
  n_rows <- nrow(df)

  # 1. Check if it's a constant (only 1 ID for the whole file)
  if (n_unique <= 1) {
    return(paste0("Error: The variable '", col_name, "' has only one unique value. Please select a variable that distinguishes between participants."))
  }

  # 2. Check if it's a row index (unique value for every single row), but allow for the case where n_rows is small (e.g. 2 rows, 2 participants)
  if (n_unique == n_rows && n_rows > 10) {
    return(paste0("Error: The variable '", col_name, "' has a unique value for every row. This looks like a row index, not a Participant ID."))
  }

  return(NULL)
}
