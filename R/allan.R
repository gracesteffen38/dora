#' Compute Allan Factor
#' @param fin Binary event vector
#' @param numint Number of intervals
#' @return List with allan value and af vector
#' @export

allan_factor <- function(fin, numint) {
  af <- numeric(numint)
  mean_count <- sum(fin) / numint
  int_len <- floor(length(fin) / numint)

  if (int_len < 1 || mean_count == 0) return(list(allan = NA, af = rep(NA, max(1, numint - 1))))

  tot <- 0
  for (i in 1:(numint - 1)) {
    idx_next_start <- (i * int_len) + 1
    idx_next_end <- min((i + 1) * int_len, length(fin))
    idx_prev_start <- ((i - 1) * int_len) + 1
    idx_prev_end <- i * int_len

    if (idx_next_end > length(fin)) break

    sum_next <- sum(fin[idx_next_start:idx_next_end])
    sum_prev <- sum(fin[idx_prev_start:idx_prev_end])
    tot <- tot + (sum_next - sum_prev)^2
    af[i] <- (tot / i) / (2 * mean_count)
  }

  allan <- af[numint - 1]
  list(allan = allan, af = af[1:(numint - 1)])
}

#' Compute Allan Factor curve
#' @param fin Binary event vector
#' @param binwidth Bin width in seconds
#' @param base Logarithm base
#' @param powers Maximum power
#' @param start Starting power
#' @param include_shuffled Whether to include shuffled comparison
#' @return List with actual, abcis, shuffled, slope
#' @export
compute_allan_factor_curve <- function(fin, binwidth, base = 2, powers = 10, start = 2, include_shuffled = TRUE) {
  num_points <- powers - start + 1
  if (num_points < 1) return(NULL)

  allan_actual <- numeric(num_points)
  allan_shuffled <- numeric(num_points)
  abcissa <- numeric(num_points)

  count <- 1
  for (i in start:powers) {
    interval <- base^i
    if (interval >= length(fin)) {
      allan_actual[count] <- NA
      allan_shuffled[count] <- NA
      abcissa[count] <- interval
      count <- count + 1
      next
    }

    abcissa[count] <- interval
    allan_actual[count] <- allan_factor(fin, interval)$allan

    if (include_shuffled) {
      fin_shuffled <- sample(fin)
      allan_shuffled[count] <- allan_factor(fin_shuffled, interval)$allan
    }

    count <- count + 1
  }

  actual <- rev(allan_actual)
  shuffled <- rev(allan_shuffled)
  abcis <- rev((length(fin) * binwidth) / abcissa)

  # Remove NAs
  valid <- !is.na(actual) & !is.na(abcis) & abcis > 0 & actual > 0

  result <- list(
    actual = actual[valid],
    abcis = abcis[valid]
  )

  if (include_shuffled) {
    valid_s <- valid & !is.na(shuffled) & shuffled > 0
    result$shuffled <- shuffled[valid_s]
    result$abcis_shuffled <- abcis[valid_s]
  }

  # Compute slope
  if (sum(valid) >= 2) {
    result$slope <- lm(log(result$actual) ~ log(result$abcis))$coefficients[2]
  }

  result
}

#' Compute Allan Deviation
#' @param data Numeric vector
#' @param rate Sampling rate in Hz
#' @param type One of "frequency" or "phase"
#' @return Data frame with tau and adev columns
#' @export
compute_allan_deviation <- function(data, rate = 1, type = c("frequency", "phase")) {
  type <- match.arg(type)
  N <- length(data)
  taus <- 2^(0:floor(log2((N - 1) / 2)))
  adev <- numeric(length(taus))

  for (i in seq_along(taus)) {
    tau <- taus[i]
    m <- N - 2 * tau
    if (m <= 0) {
      adev[i] <- NA
      next
    }

    if (type == "frequency") {
      y1 <- stats::filter(data, rep(1/tau, tau), sides = 1)
      y1 <- y1[!is.na(y1)]

      if (length(y1) < (2 * tau + 1)) {
        adev[i] <- NA
        next
      }

      diffs <- y1[(2 * tau + 1):length(y1)] -
        2 * y1[(tau + 1):(length(y1) - tau)] +
        y1[1:(length(y1) - 2 * tau)]

      adev[i] <- sqrt(0.5 * mean(diffs^2, na.rm = TRUE))
    } else if (type == "phase") {
      if (N < (1 + 2 * tau)) {
        adev[i] <- NA
        next
      }

      diffs <- data[(1 + 2 * tau):N] -
        2 * data[(1 + tau):(N - tau)] +
        data[1:(N - 2 * tau)]

      adev[i] <- sqrt(mean(diffs^2, na.rm = TRUE) / 2)
    }
  }

  df <- data.frame(tau = taus / rate, adev = adev)
  df <- df[!is.na(df$adev) & df$adev > 0, ]
  df
}
