#' Processes new cURL request
#'
#' Takes in a \emph{"Copy as cURL"} command line and returns a \code{list} of
#' components that can be used to build \code{httr} requests.
#'
#' @param curls a character vector of one or more cURL command lines. It will
#'        read from the clipboard (i.e. if you did a \emph{"Copy as cURL"} from
#'        browser developer tools).
#' @param quiet if \code{FALSE}, a \code{message} with the original \code{cURL}
#'        command line will be output. (Default: \code{FALSE})
#' @return \code{list} of \code{length(curls)} containing parsed data (i.e. to be used
#'          in `httr` requests)
#' @export
straighten <- function(curls=read_clip(), quiet=FALSE) {
  if (!quiet) message(curls)
  map(curls, process_curl)
}

#' Split a query string into component parts
#'
#' While \link{straighten} will returns parsed \code{GET} query string
#' parameters there are times (i.e. in HTML \code{<form>} processing) when
#' the body of the request contains a URL encoded query string as well.
#'
#' This function will take any query string and return a named list of
#' the paremters. Both the names and values will be URL decoded.
#'
#' @param query query string to decode
#' @export
parse_query <- function(query) {
  params <- vapply(stri_split_regex(query, "&", omit_empty=TRUE)[[1]],
                   stri_split_fixed, "=", 2, simplify=TRUE,
                   FUN.VALUE=character(2))
  set_names(as.list(curl::curl_unescape(params[2,])),
                    curl::curl_unescape(params[1,]))
}

process_curl <- function(x) {
  req <- .pkgenv$ct$call("curlconverter.toR", x)
  req$url_parts <- unclass(parse_url(req$url))
  req
}
