#' Extract onset times for one event value
#' Description...
#'
#' @param event_times Event value to analyze. Defaults to `1`.
#' @param method `"finite"` for the finite-size-adjusted measure or
#'   `"original"` for the Goh-Barabási measure.
#'
#' @return
#' @export

.as_numeric_event_time <- function(x) {
  if (is.numeric(x)) {
    return(as.numeric(x))
  }

  if (inherits(x, c("POSIXct", "POSIXlt", "Date", "difftime"))) {
    return(as.numeric(x))
  }

  out <- suppressWarnings(as.numeric(as.character(x)))

  if (any(!is.na(x) & is.na(out))) {
    stop(
      "`time` must be numeric, Date, POSIXct/POSIXlt, difftime, ",
      "or coercible to numeric."
    )
  }

  out
}


#' Extract onset times for one event value
#' Description...
#'
#' @param event_times Event value to analyze. Defaults to `1`.
#' @param method `"finite"` for the finite-size-adjusted measure or
#'   `"original"` for the Goh-Barabási measure.
#'
#' @return
#' @export
.extract_event_times <- function(
    vector,
    event,
    event_format = c("continuous", "interval"),
    time = NULL
) {
  event_format <- match.arg(event_format)

  if (length(event) != 1L) {
    stop("`event` must contain exactly one event value.")
  }

  if (!is.null(time) && length(time) != length(vector)) {
    stop("`time` and `vector` must have the same length.")
  }

  event_chr <- as.character(event)[1]
  vector_chr <- as.character(vector)

  if (event_format == "interval") {
    if (is.null(time)) {
      stop("`time` is required when `event_format = 'interval'`.")
    }

    time_num <- .as_numeric_event_time(time)

    keep <- !is.na(vector) &
      !is.na(time_num) &
      vector_chr == event_chr

    return(sort(time_num[keep]))
  }

  if (is.null(time)) {
    time_num <- seq_along(vector)
  } else {
    time_num <- .as_numeric_event_time(time)

    ord <- order(time_num, na.last = TRUE)
    vector <- vector[ord]
    vector_chr <- vector_chr[ord]
    time_num <- time_num[ord]
  }

  active <- !is.na(vector) &
    !is.na(time_num) &
    vector_chr == event_chr

  previous_active <- c(FALSE, head(active, -1L))
  onset <- active & !previous_active

  time_num[onset]
}


#' Calculate burstiness from already identified event times
#'
#' Description...
#'
#' @param event_times Event value to analyze. Defaults to `1`.
#' @param method `"finite"` for the finite-size-adjusted measure or
#'   `"original"` for the Goh-Barabási measure.
#'
#' @return
#' @export
.burstiness_from_times <- function(
    event_times,
    method = c("finite", "original")
) {
  method <- match.arg(method)

  event_times <- .as_numeric_event_time(event_times)
  event_times <- sort(event_times[is.finite(event_times)])

  if (length(event_times) < 3L) {
    return(NA_real_)
  }

  iois <- diff(event_times)

  if (
    length(iois) < 2L ||
    any(!is.finite(iois)) ||
    any(iois < 0)
  ) {
    return(NA_real_)
  }

  m <- mean(iois)
  s <- stats::sd(iois)

  if (
    !is.finite(m) ||
    !is.finite(s) ||
    m <= 0
  ) {
    return(NA_real_)
  }

  r <- s / m

  if (method == "original") {
    return((r - 1) / (r + 1))
  }

  n_iois <- length(iois)

  sqrt_np <- sqrt(n_iois + 1)
  sqrt_nm <- sqrt(n_iois - 1)

  denominator <- ((sqrt_np - 2) * r) + sqrt_nm

  if (
    !is.finite(denominator) ||
    abs(denominator) < .Machine$double.eps
  ) {
    return(NA_real_)
  }

  ((sqrt_np * r) - sqrt_nm) / denominator
}

#' Compute burstiness for one event type
#'
#' For continuous/state-format data, each contiguous run of `event`
#' is treated as one event episode. For interval data, each matching
#' row is treated as one episode and `time` supplies its onset.
#'
#' @param vector Event/state vector.
#' @param event_format Either `"continuous"` or `"interval"`.
#' @param time Optional timestamp vector for continuous data; required
#'   for interval data.
#' @param event Event value to analyze. Defaults to `1`.
#' @param method `"finite"` for the finite-size-adjusted measure or
#'   `"original"` for the Goh-Barabási measure.
#'
#' @return Numeric burstiness value or `NA_real_`.
#' @export
get_burstiness <- function(
    vector,
    event_format = c("continuous", "interval"),
    time = NULL,
    event = 1,
    method = c("finite", "original")
) {
  event_format <- match.arg(event_format)
  method <- match.arg(method)

  event_times <- .extract_event_times(
    vector = vector,
    event = event,
    event_format = event_format,
    time = time
  )

  .burstiness_from_times(
    event_times = event_times,
    method = method
  )
}

#' Compute burstiness separately for each event type
#'
#' @param vector Event/state vector.
#' @param event_format Either `"continuous"` or `"interval"`.
#' @param time Optional timestamp vector for continuous data; required
#'   for interval data.
#' @param events Optional event values to analyze. When omitted, binary
#'   vectors analyze event `1`; categorical vectors analyze all observed
#'   values except those listed in `exclude`.
#' @param exclude Values interpreted as non-events in categorical data.
#' @param method `"finite"` or `"original"`.
#'
#' @return A data frame with one row per event type.
#' @export
get_burstiness_by_event <- function(
    vector,
    event_format = c("continuous", "interval"),
    time = NULL,
    events = NULL,
    exclude = c("0", ""),
    method = c("finite", "original")
) {
  event_format <- match.arg(event_format)
  method <- match.arg(method)

  observed <- unique(as.character(vector[!is.na(vector)]))

  is_binary <- length(observed) == 0L ||
    all(observed %in% c("0", "1"))

  if (is.null(events)) {
    if (is_binary) {
      events <- "1"
    } else {
      events <- observed[
        !observed %in% as.character(exclude)
      ]
    }
  } else {
    events <- as.character(events)
  }

  if (length(events) == 0L) {
    return(
      data.frame(
        event = character(0),
        n_events = integer(0),
        n_interevent_times = integer(0),
        burstiness = numeric(0),
        stringsAsFactors = FALSE
      )
    )
  }

  results <- lapply(events, function(event_value) {
    event_times <- .extract_event_times(
      vector = vector,
      event = event_value,
      event_format = event_format,
      time = time
    )

    data.frame(
      event = event_value,
      n_events = length(event_times),
      n_interevent_times = max(length(event_times) - 1L, 0L),
      burstiness = .burstiness_from_times(
        event_times,
        method = method
      ),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, results)
}
