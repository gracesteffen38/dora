#' Expand interval data to continuous time series format
#'
#' Converts a dataframe with start/end time or start time and duration columns into a row-per-timepoint
#' format, filling gaps with zeros.
#'
#' @param data A data frame containing interval data
#' @param id_var Name of the participant ID column
#' @param var_name Name of the event/activity column
#' @param start_time_var Name of the start time column
#' @param end_time_var Name of the end time column
#' @param time_unit Numeric time step in seconds
#' @return A data frame in continuous time series format
#' @export

expand_timeseries <- function(data, id_var, var_name, start_time_var, end_time_var, time_unit) {

  start_col <- data[[start_time_var]]
  end_col <- data[[end_time_var]]

  # Parse Start Time
  if (is.character(start_col)) {
    start_col <- parse_date_time(start_col, orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd"), quiet = TRUE)
  }
  # Parse End Time
  if (is.character(end_col)) {
    end_col <- parse_date_time(end_col, orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd"), quiet = TRUE)
  }

  # Update data frame
  data[[start_time_var]] <- start_col
  data[[end_time_var]] <- end_col

  # Renaming
  working_df <- data %>%
    rename(
      internal_id = all_of(id_var),
      internal_activity = all_of(var_name),
      internal_start = all_of(start_time_var),
      internal_end = all_of(end_time_var)
    ) %>%
    filter(!is.na(internal_start), !is.na(internal_end))

  if(nrow(working_df) == 0) stop("No valid rows found after date parsing.")

  # Expand
  expanded <- working_df %>%
    rowwise() %>%
    filter(internal_end >= internal_start) %>%
    mutate(time_seq = list(seq(from = internal_start, to = internal_end, by = time_unit))) %>%
    unnest(time_seq) %>%
    select(internal_id, time_seq, internal_activity) %>%
    ungroup()

  # Aggregate duplicates (max wins for binary/categorical)
  unique_time_df <- expanded %>%
    group_by(internal_id, time_seq) %>%
    summarise(internal_activity = max(internal_activity, na.rm = TRUE), .groups = "drop")

  # Fill with 0s
  fill_val <- if(is.numeric(unique_time_df$internal_activity)) 0 else "0"

  final_df <- unique_time_df %>%
    group_by(internal_id) %>%
    complete(
      time_seq = seq(from = min(time_seq), to = max(time_seq), by = time_unit),
      fill = list(internal_activity = fill_val)
    ) %>%
    ungroup()

  # Renaming
  final_df <- final_df %>%
    rename(
      !!id_var := internal_id,
      !!var_name := internal_activity,
      time = time_seq
    )

  return(final_df)
}
