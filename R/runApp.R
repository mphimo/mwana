#'
#' 
#' Helper function to locate app directory
#' 
#' @keywords internal
#' 
get_app_dir <- function(package = "mwana") {
  app_dir <- system.file("app", package = package)
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing `mwana`.", call. = FALSE)
  }
  app_dir
}

#'
#' 
#' 
#' Initialise built-in Shiny application
#' 
#' @param package package name (`mwana`).
#' 
#' @return NULL
#' 
#' @examples
#' if (interactive()) mw_run_app()
#' 
#' @export
#' 
#' 
# nocov start
mw_run_app <- function(package = "mwana") {
  shiny::runApp(appDir = get_app_dir(package), display.mode = "normal")
}
# nocov end