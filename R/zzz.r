.pkgenv <- new.env(parent=emptyenv())

.onAttach <- function(...) {

  ct <- v8()
  ct$source(system.file("js/curl-bundle.js", package="curlconverter"))
  assign("ct", ct, envir=.pkgenv)

}
