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
  qu <- getOption("useFancyQuotes")

  options(deparse.max.lines = 10000)
  options(useFancyQuotes = FALSE)

  template <- "httr::VERB(verb = '%s', url = '%s' %s%s%s%s%s%s%s)"

  hdrs <- enc <- bdy <- ckies <- auth <- verbos <- cfg <- data_enc <- qry <- ""

  if (length(req$headers) > 0) {

    # try to determine encoding
    ct_idx <- which(grepl("content-type", names(req$headers), ignore.case=TRUE))
    if (length(ct_idx) > 0) {

      # retrieve & delete the content type
      ct <- req$headers[[ct_idx]]
      req$headers[[ct_idx]] <- NULL

      if (stringi::stri_detect_regex(ct, "multipart")) {
        enc <- ", encode = 'multipart'"
        data_enc <- "multipart"
      } else if (stringi::stri_detect_regex(ct, "form")) {
        enc <- ", encode = 'form'"
        data_enc <- "form"
      } else if (stringi::stri_detect_regex(ct, "json")) {
        enc <- ", encode = 'json'"
        data_enc <- "json"
      } else {
        enc <- ""
      }
    }

    hdrs <- paste0(capture.output(dput(req$headers, control="niceNames")), collapse="")
    hdrs <- sub("^list", ", httr::add_headers", hdrs)

  }

  if (length(req$data) > 0) {
    if (data_enc == "json") {
      bdy <- sprintf(", body = %s", sQuote(req$data))
      message(
        paste0(
          "NOTE: 'json' encoding found in cURL request. docopt is known to",
          "strip quotes from cURL parameterss. The httr 'body' parameter may need",
          "manual intervention. You can review the 'orig_curl' list member of the",
          "`straighten()`ed object to compare the input to the parsed output.",
          collapse=" "
        )
      )
    } else {
      bdy_bits <- paste0(capture.output(dput(parse_query(req$data), control="niceNames")),
                         collapse="")
      bdy <- sprintf(", body = %s", bdy_bits)
    }
  }

  if (length(req$url_parts$username) > 0) {
    auth <- sprintf(", httr::authenticate(user='%s', password='%s')",
                    req$url_parts$username, req$url_parts$password)
  }

  if (req$verbose) verbose <- ", httr::verbose()"

  if (length(req$cookies) > 0) {
    ckies <- paste0(capture.output(dput(req$cookies, control="niceNames")),
                    collapse="")
    ckies <- sub("^list", ", httr::set_cookies", ckies)
  }

  REQ_URL <- req$url
  if (use_parts) REQ_URL <- httr::build_url(req$url_parts)

  # if there are query params, split them out, add them to the function
  # then subtract them from the original URL
  if (length(req$url_parts$query) > 0) {
    qry <- paste0(capture.output(dput(req$url_parts$query, control="niceNames")),
                    collapse="")
    qry <- sub("", ", query = ", qry)

    bits <- httr::parse_url(REQ_URL)
    bits$query <- NULL
    REQ_URL <- httr::build_url(bits)
  }

  sprintf(
    template,
    toupper(req$method), REQ_URL, auth, verbos, hdrs, ckies, bdy, enc, qry
  ) -> out

  # this does a half-decent job formatting the R function text
  fil <- tempfile(fileext=".R")
  on.exit(unlink(fil))
  formatR::tidy_source(text=out, width.cutoff=30, indent=4, file=fil)
  junk <- capture.output(styler::style_file(fil))
  tmp <- paste0(readLines(fil), collapse="\n")

  if (add_clip) try(clipr::write_clip(tmp))

  if (!quiet) cat(tmp, "\n")

  # make a bona fide R function
  f <- function() {}
  formals(f) <- NULL
  environment(f) <- parent.frame()
  body(f) <- as.expression(parse(text=tmp))

  options(deparse.max.lines = ml)
  options(useFancyQuotes = qu)

  return(f)

}

# filter the entries in a HAR based on response content-type
filter_entries <- function(entries, filter){
  entries
}


temp_name = function(n = 4, avoid = ls()) {

  tn = paste(sample(letters, n), collapse="")

  while (tn %in% avoid) {
    tn = paste(sample(letters, n), collapse="")
  }

  tn
}
