.pkgenv <- new.env(parent=emptyenv())

.onAttach <- function(...) {

  ct <- v8()
  ct$source(system.file("js/curl-bundle.js", package="curlconverter"))
  assign("ct", ct, envir=.pkgenv)

}


#' Processes new cURL request
#'
#' Will eventually have an option to return a function, or function source
#' Right now it just returns daa
#'
#' @param curl a character vector of one or more cURL command lines. It will read from the
#'        clipboard (i.e. if you did a \emph{"Copy as cURL"} from browser developer tools).
#' @return list of data to use in `httr` requests
#' @export
straighten <- function(curl=read_clip()) {
  req <- .pkgenv$ct$call("curlconverter.toR", curl)
  req
}

