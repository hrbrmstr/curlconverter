#' Create `httr` requests from _"Copy to cURL"_ command-line calls
#'
#' Tools to Transform 'cURL' Command-line Calls to 'httr' Requests
#'
#' Deciphering web/'REST' 'API' and 'XHR' calls can be tricky, which is one reason why
#' internet browsers provide "Copy as cURL" functionality within their "Developer Tools"
#' pane(s). These 'cURL' command-lines can be difficult to wrangle into an 'httr' 'GET' or
#' 'POST' request, but you can now "straighten" these 'cURLs' either from data copies to
#' the system clipboard or by passing in a vector of 'cURL' command-lines and getting back
#' a list of parameter elements which can be used to form 'httr' requests. Enhancements
#' are planned to auto-generate 'httr' 'GET' and 'POST' requests or function bodies from
#' the parsed 'cURL' command-lines.
#'
#' @name curlconverter
#' @docType package
#' @author Bob Rudis (@@hrbrmstr)
#' @import V8 purrr httr formatR
#' @importFrom clipr read_clip
#' @importFrom curl curl_unescape
#' @importFrom stringi stri_split_regex stri_split_fixed stri_detect_regex
NULL
