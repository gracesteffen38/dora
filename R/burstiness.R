#' Compute burstiness of a binary event vector
#'
#' @param vector A binary (0/1) numeric vector
#' @return Numeric burstiness value, or NA if not computable
#' @export
get_burstiness <- function(vector){
  clean_vec <- na.omit(vector)
  if (!is.numeric(clean_vec) || !all(unique(clean_vec) %in% c(0, 1))) {
    return(NA)
  }
  onsets <- which(clean_vec == 1)
  if (length(onsets) < 2) return(NA)

  IOIs <- diff(onsets)
  l <- length(IOIs)
  m <- mean(IOIs)
  s <- sd(IOIs)
  if (m == 0) return(NA)

  r <- s / m
  sqrt.np <- sqrt(l + 1)
  sqrt.nn <- sqrt(l - 1)

  burstiness <- ((sqrt.np * r) - sqrt.nn) / (((sqrt.np - 2) * r) + sqrt.nn)
  return(burstiness)
}
