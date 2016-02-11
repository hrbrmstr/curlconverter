#' Turn a cURL request into an \code{httr} request
#'
#' Takes in a \emph{"Copy as cURL"} command line and returns a "working"
#' R \code{function} (i.e. a comple, valid \code{VERB()} call that will work
#' provided the server it's requesting the resource from thinks the call is
#' valid).
#'
#' It also has a side-effect of overwriting the clipboard with the character
#' contents of the function and will (optionally) \code{cat}ted to the console.
#'
#' @param curls a character vector of one cURL command line. It will
#'        read from the clipboard (i.e. if you did a \emph{"Copy as cURL"} from
#'        browser developer tools).
#' @param quiet if \code{FALSE}, a \code{message} with the original \code{cURL}
#'        command line will be output and the created \code{httr} function will
#'        be \code{cat}ted to the console.. (Default: \code{FALSE})
#' @return a working R \code{function}
#' @examples
#' \dontrun{
#'  my_ip <- make_req("curl 'https://httpbin.org/ip'")
#'  content(my_ip(), as="parsed")
#' }
#' @export
make_req <- function(curls=read_clip(), quiet=FALSE) {

  if (!quiet) message(curls)

  req <- map(curls, process_curl)[[1]]

  template <- "httr::VERB(verb = '%s', url = '%s' %s%s%s)"

  hdrs <- enc <- ""
  if (length(req$headers) > 0) {

    ct_idx <- which(grepl("content-type", names(req$headers), ignore.case=TRUE))
    if (length(ct_idx) > 0) {
      ct <- req$headers[[ct_idx]]
      req$headers[[ct_idx]] <- NULL
      if (stri_detect_regex(ct, "multipart")) enc <- ", encode = 'multipart'"
      if (stri_detect_regex(ct, "form")) enc <- ", encode = 'form'"
      if (stri_detect_regex(ct, "json")) enc <- ", encode = 'json'"
    }

    hdrs <- paste0(capture.output(dput(req$headers,  control=NULL)),
                   collapse="")
    hdrs <- sub("^list", ", add_headers", hdrs)

  }

  bdy <- ""
  if (length(req$data) > 0) {
    bdy_bits <- paste0(capture.output(dput(parse_query(req$data), control=NULL)),
                       collapse="")
    bdy <- sprintf(", body = %s", bdy_bits)
  }

  out <- sprintf(template, toupper(req$method), req$url, hdrs, bdy, enc)

  fil <- tempfile(fileext=".R")
  tidy_source(text=out, width.cutoff=30, indent=4, file=fil)
  tmp <- paste0(readLines(fil), collapse="\n")
  unlink(fil)

  clipr::write_clip(tmp)

  if (!quiet) cat(tmp, "\n")

  f <- function() {}
  formals(f) <- NULL
  environment(f) <- parent.frame()
  body(f) <- as.expression(parse(text=tmp))

  return(f)

}
