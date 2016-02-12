#' Turn parsed cURL command lines into \code{httr} request functions
#'
#' Takes the output of \code{straighten()} and turns the parsed cURL command lines
#' into working \code{httr} functions, optionally \code{cat}'ing the text of each function
#' to the console.
#'
#' @param x a vector of \code{curlcoverter} objects
#' @param quiet if \code{FALSE}, will cause \code{make_req()} to write complete function
#'        source code to the console.
#' @return a \code{list} of working R \code{function}s.
#' @examples
#' \dontrun{
#' library(httr)
#' library(magrittr)
#'  my_ip <- straighten("curl 'https://httpbin.org/ip'") %>% make_req()
#'  content(my_ip[[1]](), as="parsed")
#' }
#' @export
make_req <- function(x, quiet=TRUE) {
  req <- map(x, create_httr_function, quiet=quiet)
}

create_httr_function <- function(req, quiet=TRUE) {

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
