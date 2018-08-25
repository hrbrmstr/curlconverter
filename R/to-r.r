  "Usage: curl [<url>] [-H LINE ...] [-X COMMAND <url>] [-X COMMAND] [--request COMMAND] [--request COMMAND <url>] [options] [<url>]

               --compressed
             -k, --insecure
              -v, --verbose
             -L, --location
                    --basic
                 -I, --head
                   --digest
              -i, --include
          -H, --header LINE
            -d, --data DATA HTTP POST data
            --data-raw DATA HTTP POST data, '@' allowed
          --data-ascii DATA HTTP POST ASCII data
         --data-binary DATA HTTP POST binary data
      --data-urlencode DATA HTTP POST data url encoded
         -F, --form CONTENT Specify HTTP multipart POST data
       --form-string STRING Specify HTTP multipart POST data
    -A, --user-agent STRING Send User-Agent STRING to server
      -e, --referer REFERER Referer URL
     -m, --max-time SECONDS Maximum time allowed for the transfer
 -u, --user USER[:PASSWORD] Server user and password
      -X, --request COMMAND Specify request command to use
                  -G, --get Send the 'minus d' data with a HTTP GET
                  --url URL URL to work with
         -#, --progress-bar Display transfer progress as a progress bar
" -> .curl_opts

to_r <- function(x) {

  # strip off leading `curl ` (if any)
  x <- gsub("^[[:space:]]*curl[[:space:]]+", "", x)

  m <- docopt::docopt(.curl_opts, x)

  url <- m[["<url>"]]

  headers <-  NULL
  if (length(m[["header"]]) > 0) {
    hdrs <- stri_split_regex(m[["header"]], pattern = ":[[:space:]]*",n = 2, simplify=TRUE)
    headers <- as.list(setNames(hdrs[,2], hdrs[,1]))
  }

  cookies <- NULL
  cookie_idx <- which(grepl("cookie", names(headers), ignore.case=TRUE))
  if (length(cookie_idx) > 0) {
    cookies <- headers[[cookie_idx]]
    headers <- headers[-cookie_idx]
    cookies <- gsub("^Cookies:[[:space:]]+", "", cookies, ignore.case=TRUE)
    cookies <- stri_split_regex(cookies, pattern = ";[[:space:]]*")[[1]]
    cookies <- stri_split_fixed(cookies, "=", 2, simplify = TRUE)
    cookies <- as.list(setNames(cookies[,2], cookies[,1]))
  }

  credentials <- list(username=NULL, password=NULL)
  if (length(m[["user"]] > 0)) {
    credentials <- stri_split_fixed(m[["user"]], ":", 2)[[1]]
    credentials <- as.list(setNames(credentials, c("username", "password")))
  }

  user_agent <- NULL
  user_agent_idx <- which(grepl("User-Agent", names(headers), ignore.case=TRUE))
  if (length(user_agent_idx) > 0) {
    user_agent <- headers[[user_agent_idx]]
    user_agent <- headers[-user_agent_idx]
  }

  verb <- unlist(c(m[["get"]], m[["head"]], m[["request"]]), use.names = FALSE)
  verb <- verb[!(verb == "FALSE")]
  verb <- if (length(verb) == 0) "GET" else verb[1]
  verb <- if (length(m[["data-binary"]]) > 0) "POST" else verb

  curl_dat <- NULL
  if (length(m[["data"]]) > 0) curl_dat <- m[["data"]]
  if (length(m[["data-raw"]]) > 0) curl_dat <- m[["data-raw"]]
  if (length(m[["data-ascii"]]) > 0) curl_dat <- m[["data-ascii"]]
  if (length(m[["data-binary"]]) > 0) curl_dat <- m[["data-binary"]]

  referer <- NULL
  if (length(m[["referer"]] > 0)) referer <- m[["referer"]]

  verbose <- m[["verbose"]]
  verbose <- if (length(verbose) == 0) FALSE else verbose

  list(
    url = url[1],
    method = verb,
    cookies = cookies,
    username = credentials[["username"]],
    password = credentials[["password"]],
    user_agent = user_agent,
    referer = referer,
    data = curl_dat,
    headers = headers,
    verbose = verbose
  )

}
