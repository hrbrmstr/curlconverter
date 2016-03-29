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
#' @references \href{https://en.wikipedia.org/wiki/Query_string}{Query Strings}
#' @export
#' @examples
#' parse_query("a=1&b=test")
parse_query <- function(query) {
  params <- vapply(stri_split_regex(query, "&", omit_empty=TRUE)[[1]],
                   stri_split_fixed, "=", 2, simplify=TRUE,
                   FUN.VALUE=character(2))
  purrr::set_names(as.list(curl::curl_unescape(params[2,])),
                   curl::curl_unescape(params[1,]))
}
