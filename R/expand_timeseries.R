# =============================================================================
#' Expand interval data to a continuous time-series format
#'
#' Converts a data frame with onset/offset columns into a row-per-timestep
#' format, filling gaps between events with zeros.
#'
#' Handles two event-column layouts automatically:
#'   • **String-coded** – a single column whose values are event names
#'     (e.g. "A", "B").  Output contains one binary column per unique name,
#'     prefixed with the original column name (e.g. `Event_A`, `Event_B`).
#'   • **Binary wide** – one or more numeric 0/1 columns, one per event type.
#'     Passed as a character vector to `event_vars`.
#'
#' For each interval the number of timestep bins is
#'   `ceiling((end - start) / time_unit)`,
#' so the bin at `t` represents `[t, t + time_unit)`.
#' Overlapping intervals are resolved with OR logic (max per bin).
#' Gaps inside the per-ID time range are filled with 0.
#'
#' @param data          Data frame containing interval data.
#' @param id_var        Name of the participant / ID column (string).
#' @param start_time_var Name of the onset column (string).
#'   May be numeric (seconds) or a date-time string/POSIXct.
#' @param end_time_var  Name of the offset column (string).
#'   Same type as `start_time_var`.
#' @param event_vars    Character vector of event column name(s).
#'   Supply a single name for a string-coded column, or one or more names
#'   for binary (0/1) columns.
#' @param time_unit     Timestep size in seconds (numeric, default 1).
#' @return A data frame with columns `[id_var, time, <event cols>]`,
#'   one row per timestep, values 0 or 1.
#' @export
# =============================================================================

expand_timeseries <- function(data,
                              id_var,
                              start_time_var,
                              end_time_var,
                              event_vars,
                              time_unit = 1) {

  # ── 0. Input validation ────────────────────────────────────────────────────
  if (!is.data.frame(data)) stop("`data` must be a data frame.")
  required_cols <- c(id_var, start_time_var, end_time_var, event_vars)
  missing_cols  <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0)
    stop("Column(s) not found in data: ", paste(missing_cols, collapse = ", "))
  if (!is.numeric(time_unit) || length(time_unit) != 1 || time_unit <= 0)
    stop("`time_unit` must be a single positive number.")

  # ── 1. Parse date-time columns if supplied as character strings ────────────
  parse_time_col <- function(x) {
    if (is.character(x)) {
      parsed <- lubridate::parse_date_time(
        x,
        orders = c("ymd HMS", "ymd HM", "HMS", "HM", "ymd"),
        quiet  = TRUE
      )
      # Fall back to original if parsing failed entirely
      if (!all(is.na(parsed))) return(parsed)
    }
    x
  }
  data[[start_time_var]] <- parse_time_col(data[[start_time_var]])
  data[[end_time_var]]   <- parse_time_col(data[[end_time_var]])

  # ── 2. Detect event layout and normalise to binary wide columns ────────────
  is_string_coded <- (length(event_vars) == 1 &&
                        is.character(data[[event_vars]]) &&
                        !inherits(data[[event_vars]], c("POSIXct", "POSIXt", "Date")))

  if (is_string_coded) {
    source_col   <- event_vars
    lvls         <- sort(unique(na.omit(data[[source_col]])))
    binary_cols  <- paste0(source_col, "_", lvls)
    for (i in seq_along(lvls))
      data[[binary_cols[i]]] <- as.integer(data[[source_col]] == lvls[i])
  } else {
    for (col in event_vars) data[[col]] <- as.numeric(data[[col]])
    binary_cols <- event_vars
  }

  # ── 3. Filter out rows with NA or invalid intervals ─────────────────────────
  ok <- !is.na(data[[start_time_var]]) &
    !is.na(data[[end_time_var]])   &
    data[[end_time_var]] >= data[[start_time_var]]
  data <- data[ok, , drop = FALSE]
  if (nrow(data) == 0) stop("No valid rows remain after filtering.")

  # ── 4. Determine whether we are working with date-time or numeric times ─────
  is_datetime <- inherits(data[[start_time_var]], c("POSIXct", "POSIXt"))

  # Helper: duration in seconds between two values
  dur_secs <- function(start, end) {
    if (is_datetime) as.numeric(difftime(end, start, units = "secs"))
    else             as.numeric(end - start)
  }

  # ── 5. Expand each interval to individual timestep rows ─────────────────────
  # Number of bins = ceiling(duration / time_unit):  bin at t covers [t, t+Δ)
  expanded_list <- lapply(seq_len(nrow(data)), function(i) {
    s   <- data[[start_time_var]][i]
    e   <- data[[end_time_var]][i]
    dur <- dur_secs(s, e)
    n   <- max(1L, ceiling(dur / time_unit))

    times <- if (is_datetime) {
      s + seq(0, by = time_unit, length.out = n)
    } else {
      seq(from = s, by = time_unit, length.out = n)
    }

    row_df           <- data.frame(time = times, stringsAsFactors = FALSE)
    row_df[[id_var]] <- data[[id_var]][i]
    for (col in binary_cols) row_df[[col]] <- data[[col]][i]
    row_df
  })

  expanded <- do.call(rbind, expanded_list)

  # ── 6. Nudge times to absorb tiny floating-point drift ───────────────────────
  # We round to 10 significant decimal places — enough to collapse genuine FP
  # jitter (e.g. 1.9999999999 → 2) while preserving legitimate non-integer
  # onset labels (e.g. 1556.554 stays 1556.554).
  if (is_datetime) {
    origin     <- min(expanded$time)
    offset_sec <- as.numeric(difftime(expanded$time, origin, units = "secs"))
    offset_sec <- round(offset_sec, 10)
    expanded$time <- origin + offset_sec
  } else {
    expanded$time <- round(expanded$time, 10)
  }

  # ── 7. Resolve overlapping intervals: OR logic (max) per ID × timestep ──────
  expanded <- expanded |>
    dplyr::group_by(dplyr::across(dplyr::all_of(c(id_var, "time")))) |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(binary_cols), \(x) max(x, na.rm = TRUE)),
      .groups = "drop"
    )

  # ── 8. Fill within-ID gaps with zeros ────────────────────────────────────────
  fill_zeros <- setNames(rep(list(0L), length(binary_cols)), binary_cols)

  if (is_datetime) {
    # complete() cannot handle POSIXct sequences directly; work in numeric secs
    origin_dt         <- min(expanded$time)
    expanded$time_num <- as.numeric(difftime(expanded$time, origin_dt, units = "secs"))

    expanded <- expanded |>
      dplyr::group_by(dplyr::across(dplyr::all_of(id_var))) |>
      tidyr::complete(
        time_num = seq(min(time_num), max(time_num), by = time_unit),
        fill = fill_zeros
      ) |>
      dplyr::ungroup()

    expanded$time     <- origin_dt + expanded$time_num
    expanded$time_num <- NULL

  } else {
    expanded <- expanded |>
      dplyr::group_by(dplyr::across(dplyr::all_of(id_var))) |>
      tidyr::complete(
        time = seq(min(time), max(time), by = time_unit),
        fill = fill_zeros
      ) |>
      dplyr::ungroup()
  }

  # ── 9. Return in tidy column order ───────────────────────────────────────────
  expanded <- expanded[, c(id_var, "time", binary_cols), drop = FALSE]
  return(as.data.frame(expanded))
}

