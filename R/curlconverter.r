#' Processes new cURL request
#'
#' Will eventually have an option to return a function, or function source
#' Right now it just returns daa
#'
#' @param curls a character vector of one or more cURL command lines. It will read from the
#'        clipboard (i.e. if you did a \emph{"Copy as cURL"} from browser developer tools).
#' @return list of data to use in `httr` requests
#' @export
straighten <- function(curls=read_clip()) {
  req <- map(curls, process_curl)
  req
}

process_curl <- function(x) {
  req <- .pkgenv$ct$call("curlconverter.toR", x)
  req$url_parts <- unclass(parse_url(req$url))
  req
}
