# print.url <- function (x, ...)  {
#   jsonlite::toJSON(x, pretty=TRUE)
# }

.pkgenv <- new.env(parent=emptyenv())

.onAttach <- function(...) {

  ct <- v8()
  ct$source(system.file("js/curl-bundle.js", package="curlconverter"))
  assign("ct", ct, envir=.pkgenv)

  # if (!interactive()) return()
  #
  # packageStartupMessage(paste0("curlconverter is under *active* development. ",
  #                              "See https://github.com/hrbrmstr/curlconverter for changes"))

}
