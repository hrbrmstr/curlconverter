#' Convert HAR to cURL
#'
#' @param har a JSON string, URL or file
#' @param filter a filter working on content-type given by the HAR entry
#'    response
#'
#' @return A character vector of cURL calls
#' @export
#'
#' @examples
#' \dontrun{
#'    hardir <- system.file("extdata", package = "curlconverter")
#'    harfile <- file.path(hardir, "har1.har")
#'    harfile %>% from_har
#' }

from_har <- function(har, filter = c("All", "Doc", "JS", "CSS", "XHR",
                                     "Img", "XHR", "Media", "Font", "WS",
                                     "Manifest", "Other")){
  if (!is.character(har) && !is(har, "connection")) {
    stop("Argument 'har' must be a JSON string, URL or file.")
  }
  if (is.character(har) && length(har) == 1 && nchar(har, type = "bytes") <
      10000) {
    if (grepl("^https?://", har, useBytes = TRUE)) {
      h <- curl::new_handle(useragent = paste("curlconverter /",
                                              R.version.string))
      curl::handle_setheaders(h, Accept = "application/json, text/*, */*")
      har <- curl::curl(har, handle = h)
    }
    else if (file.exists(har)) {
      har <- file(har)
    }
  }
  har_json <- fromJSON(har, simplifyVector = FALSE)
  entries <- har_json[["log"]][["entries"]]
  entries <- filter_entries(entries, filter)
  requests <- lapply(entries, function(x){x[["request"]]})
  vapply(requests, from_request, character(1))
}


#' Convert HAR request to cURL
#'
#' @param request a parsed HAR entry  request as a list
#'
#' @return a cURL string
#' @export
#'
#' @examples
#' \dontrun{
#'    hardir <- system.file("extdata", package = "curlconverter")
#'    harfile <- file.path(hardir, "har1.har")
#'    entry <-
#'      fromJSON(harfile, simplifyVector = FALSE)[["log"]][["entries"]][[1]]
#'    req <- entry[["request"]]
#'    req %>% from_request
#' }

from_request <- function(request){
  command <- paste("curl -X ", request$method)
  hv <- if(identical(request$httpVersion, "HTTP/1.0")){
    paste(command, " -0")
  }
  cookies <- if(length(request$cookies) > 0){
    ck <- vapply(request$cookies, function(x){
      paste(curl::curl_escape(x$name), curl::curl_escape(x$value),
            sep = "=")
    }, character(1))
    paste0(" -b ", "\"", paste(ck, collapse = "&"), "\"")
  }
  headers <- if(length(request$headers) > 0){
    hds <- vapply(request$headers, function(x){
      paste0(" -H \"", x$name, ":", x$value, "\"")
    }, character(1))
    paste(hds, collapse = "")
  }
  post <- if(length(request$postData)){
    paste0(" -d ", toJSON(request$postData$text), "\"")
  }
  paste0(command, cookies, headers, post, " ", request$url)
}
