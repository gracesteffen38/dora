#' Launch the Time Series Explorer Shiny app
#'
#' @param port Port to run the app on. Defaults to Shiny's default.
#' @param host Host address. Defaults to 127.0.0.1.
#' @export
run_app <- function(port = getOption("shiny.port"),
                    host = getOption("shiny.host", "127.0.0.1")) {
  app_dir <- system.file("app", package = "yourpackagename")
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, port = port, host = host, display.mode = "normal")
}
