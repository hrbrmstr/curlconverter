#' Create `httr` requests from _"Copy as cURL"_ command-line calls
#'
#' Tools to Transform 'cURL' Command-line Calls to 'httr' Requests
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
#' @author Bob Rudis (@@hrbrmstr)
#' @import V8
#' @import httr
#' @importFrom formatR tidy_source
#' @importFrom purrr map map_df flatten flatten_chr set_names
#' @importFrom clipr read_clip
#' @importFrom curl curl_unescape
#' @importFrom jsonlite toJSON
#' @importFrom stringi stri_split_regex stri_split_fixed stri_detect_regex
#' @importFrom utils capture.output
NULL


#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @export
#' @importFrom magrittr %>%
NULL
