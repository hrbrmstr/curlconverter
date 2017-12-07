# process a single cURL request (V8 call)
process_curl <- function(x) {
  req <- to_r(x)
  req$url_parts <- unclass(parse_url(req$url))
  if (length(req$username) > 0) req$url_parts$username <- req$username
  if (length(req$password) > 0) req$url_parts$password <- req$password
  class(req$url_parts) <- c("url", class(req$url_parts))
  req[["orig_curl"]] <- x
  class(req) <- c("cc_obj", class(req))
  req
}


# create one httr function from one cURL request processed with process_curl()
create_httr_function <- function(req, use_parts=FALSE, quiet=TRUE, add_clip=TRUE) {

  ml <- getOption("deparse.max.lines")
  options(deparse.max.lines=10000)

  template <- "httr::VERB(verb = '%s', url = '%s' %s%s%s%s%s%s)"

  hdrs <- enc <- bdy <- ckies <- auth <- verbos <- cfg <- ""

  if (length(req$headers) > 0) {

    # try to determine encoding
    ct_idx <- which(grepl("content-type", names(req$headers), ignore.case=TRUE))
    if (length(ct_idx) > 0) {
      # retrieve & delete the content type
      ct <- req$headers[[ct_idx]]
      req$headers[[ct_idx]] <- NULL

      if (stringi::stri_detect_regex(ct, "multipart")) {
        enc <- ", encode = 'multipart'"
      } else if (stringi::stri_detect_regex(ct, "form")) {
        enc <- ", encode = 'form'"
      } else if (stringi::stri_detect_regex(ct, "json")) {
        enc <- ", encode = 'json'"
      } else {
        enc <- ""
      }
    }

    hdrs <- paste0(capture.output(dput(req$headers,  control=NULL)),
                   collapse="")
    hdrs <- sub("^list", ", httr::add_headers", hdrs)

  }

  if (length(req$data) > 0) {
    bdy_bits <- paste0(capture.output(dput(parse_query(req$data), control=NULL)),
                       collapse="")
    bdy <- sprintf(", body = %s", bdy_bits)
  }

  if (length(req$url_parts$username) > 0) {
    auth <- sprintf(", httr::authenticate(user='%s', password='%s')",
                    req$url_parts$username, req$url_parts$password)
  }

  if (req$verbose) {
    verbos <- ", httr::verbose()"
  }

  if (length(req$cookies) > 0) {
    ckies <- paste0(capture.output(dput(req$cookies, control=NULL)),
                    collapse="")
    ckies <- sub("^list", ", httr::set_cookies", ckies)
  }

  REQ_URL <- req$url
  if (use_parts) REQ_URL <- httr::build_url(req$url_parts)

  out <- sprintf(template, toupper(req$method), REQ_URL, auth, verbos, hdrs, ckies, bdy, enc)

  # this does a half-decent job formatting the R function text
  fil <- tempfile(fileext=".R")
  on.exit(unlink(fil))
  formatR::tidy_source(text=out, width.cutoff=30, indent=4, file=fil)
  tmp <- paste0(readLines(fil), collapse="\n")

  if (add_clip) try(clipr::write_clip(tmp))

  if (!quiet) cat(tmp, "\n")

  # make a bona fide R function
  f <- function() {}
  formals(f) <- NULL
  environment(f) <- parent.frame()
  body(f) <- as.expression(parse(text=tmp))

  options(deparse.max.lines=ml)

  return(f)

}

# filter the entries in a HAR based on response content-type
filter_entries <- function(entries, filter){
  entries
}
