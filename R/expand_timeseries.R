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
  end_col   <- data[[end_time_var]]

  if (is.character(start_col))
    start_col <- lubridate::parse_date_time(start_col, orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd"), quiet = TRUE)
  if (is.character(end_col))
    end_col <- lubridate::parse_date_time(end_col, orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd"), quiet = TRUE)

  data[[start_time_var]] <- start_col
  data[[end_time_var]]   <- end_col

  working_df <- data %>%
    dplyr::rename(
      internal_id       = dplyr::all_of(id_var),
      internal_activity = dplyr::all_of(var_name),
      internal_start    = dplyr::all_of(start_time_var),
      internal_end      = dplyr::all_of(end_time_var)
    ) %>%
    dplyr::filter(!is.na(internal_start), !is.na(internal_end))

  if (nrow(working_df) == 0) stop("No valid rows found after date parsing.")

  # Filter first
  working_df <- working_df %>%
    dplyr::filter(internal_end >= internal_start)

  if (nrow(working_df) == 0) stop("No valid rows after filtering.")

  # Build sequences outside of dplyr to preserve POSIXct class
  time_seqs <- lapply(seq_len(nrow(working_df)), function(i) {
    seq(from = working_df$internal_start[[i]],
        to   = working_df$internal_end[[i]],
        by   = time_unit)
  })

  working_df$time_seq <- time_seqs

  expanded <- working_df %>%
    tidyr::unnest(time_seq) %>%
    dplyr::select(internal_id, time_seq, internal_activity) %>%
    dplyr::ungroup()

  unique_time_df <- expanded %>%
    dplyr::group_by(internal_id, time_seq) %>%
    dplyr::summarise(internal_activity = max(internal_activity, na.rm = TRUE), .groups = "drop")

  fill_val <- if (is.numeric(unique_time_df$internal_activity)) 0 else "0"

  final_df <- unique_time_df %>%
    dplyr::group_by(internal_id) %>%
    tidyr::complete(
      time_seq = seq(from = min(time_seq, na.rm = TRUE),
                     to   = max(time_seq, na.rm = TRUE),
                     by   = time_unit),
      fill = list(internal_activity = fill_val)
    ) %>%
    dplyr::ungroup()

  final_df <- final_df %>%
    dplyr::rename(
      !!id_var   := internal_id,
      !!var_name := internal_activity,
      time       := time_seq
    )

  return(final_df)
}
