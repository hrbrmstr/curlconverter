#' Tools to Transform 'cURL' Command-Line Calls to 'httr' Requests
#'
#' Deciphering web/'REST' 'API' and 'XHR' calls can be tricky, which is one reason why
#' internet browsers provide "Copy as cURL" functionality within their "Developer Tools"
#' pane(s). These 'cURL' command-lines can be difficult to wrangle into an 'httr' 'GET' or
#' 'POST' request, but you can now "straighten" these 'cURLs' either from data copied to
#' the system clipboard or by passing in a vector of 'cURL' command-lines and getting back
#' a list of parameter elements which can be used to form 'httr' requests. These lists can
#' be passed to another function to automagically make 'httr' functions.
#'
#' @name curlconverter
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import httr docopt
#' @importFrom formatR tidy_source
#' @importFrom clipr read_clip write_clip
#' @importFrom curl curl_unescape
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom stringi stri_split_regex stri_split_fixed stri_detect_regex
#' @importFrom utils capture.output
#' @importFrom methods is
#' @importFrom stats setNames
#' @importFrom styler style_file
# @import shiny miniUI stringi
# @import rstudioapi
NULL

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @export
#' @importFrom magrittr %>%
NULL
