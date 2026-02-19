#' Gets tick marks and plot labels for dora_app() plots
#'
#' Calculates tick intervals that are adapted to the length of a timeseries to avoid clustered tick marks and outputs them with other formatting for the dora_app
#'
#' @param time_vec a vector containing a time variable
#' @param title_text the desired title for the time (x) axis
#' @param fonts a vector containing font sizes for different plot features
#' @return A list of plotting labels for tickmarks, titles, and fonts
#' @export

get_datetime_axis <- function(time_vec, title_text, fonts) {
  if (!inherits(time_vec, c("POSIXct", "POSIXt", "Date"))) {
    return(list(
      title = list(text = title_text, font = list(size = fonts$axis_title_size)),
      tickfont = list(size = fonts$axis_text_size)
    ))
  }

  time_range_secs <- as.numeric(difftime(max(time_vec, na.rm = TRUE),
                                         min(time_vec, na.rm = TRUE),
                                         units = "secs"))

  if (time_range_secs < 60) {
    tick_format <- "%H:%M:%S"
  } else if (time_range_secs < 3600) {
    tick_format <- "%H:%M:%S"
  } else if (time_range_secs < 86400) {
    tick_format <- "%H:%M"
  } else {
    tick_format <- "%m-%d %H:%M"
  }

  list(
    title = list(text = title_text, font = list(size = fonts$axis_title_size)),
    tickfont = list(size = fonts$axis_text_size),
    tickformat = tick_format,
    nticks = 10,
    tickangle = -45
  )
}
