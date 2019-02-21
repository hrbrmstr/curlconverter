can_use_nicenames <- function() {
  return("niceNames" %in% eval(formals(dput)$control))
}

#' Turn parsed cURL command lines into \code{httr} request functions
#'
#' Takes the output of \code{\link{straighten}()} and turns the parsed cURL command lines
#' into working \code{httr} \code{\link[httr]{VERB}()} functions, optionally \code{cat}'ing the text of each function
#' to the console and/or replacing the system clipboard with the source code for the function.
#'
#' @section Quiet! (pls):
#'
#' You can use `option(curlconverter.quiet = TRUE)` to silence all stdout output.
#'
#' @param x a vector of \code{curlcoverter} objects
#' @param quiet if \code{FALSE}, will cause \code{make_req()} to write complete function
#'        source code to the console.
#' @param add_clip if \code{TRUE}, will overwrite the system clipboard with the
#'        character string contents of the last newly made `httr::VERB` function (i.e.
#'        this is intended to be used in a workflow where only one cURL command line
#'        is being processed). Defaults to \code{TRUE} if \code{length(x)} is \code{1}
#' @param use_parts logical. If \code{TRUE}, the request function will be generated
#'        from the "URL parts" that are created as a result of the call to
#'        \code{\link{straighten}}. This is useful if you want to modify the
#'        URL parts before calling \code{make_req}. Default: \code{FALSE}.
#' @param use_nicenames will default to `FALSE` on R <= 3.5; can be forced `FALSE``
#' @return a \code{list} of working R \code{function}s.
#' @seealso \code{\link{straighten}()}, \code{httr} \code{\link[httr]{VERB}()}
#' @references \href{https://developer.chrome.com/devtools/docs/network}{Evaluating Network Performance},
#'             \href{https://developer.mozilla.org/en-US/docs/Tools/Network_Monitor}{Network Monitor}
#' @export
#' @examples \dontrun{
#' library(httr)
#'
#' my_ip <- straighten("curl 'https://httpbin.org/ip'") %>% make_req()
#'
#' # external test which captures live data
#' content(my_ip[[1]](), as="parsed")
#' }
#'
#' curl_line <- readLines(system.file("extdata/curl8.txt", package="curlconverter"),
#'                        warn=FALSE)
#' st <- straighten(curl_line, quiet=FALSE)
#' req <- make_req(st)
make_req <- function(x, use_parts=FALSE, quiet, add_clip=(length(x)==1),
                     use_nicenames=can_use_nicenames()) {
  if (missing(quiet)) quiet <- quiet_option()
  lapply(
    x,
    create_httr_function,
    use_parts = use_parts,
    quiet = quiet,
    add_clip = add_clip,
    use_nicenames = use_nicenames
  ) -> req
}

#' Shortcut to convert a single cURL command-line into a single R function
#'
#' @note The cURL command-line should be on the clipboard.
#' @param curls a character vector of one or more cURL command lines. It will
#'        read from the clipboard (i.e. if you did a \emph{"Copy as cURL"} from
#'        browser developer tools).
#' @param quiet if \code{FALSE}, a \code{message} with the original \code{cURL}
#'        command line will be output. (Default: \code{FALSE})
#' @return an R function and a version of the function on the clipboard
#' @export
curl_convert <- function(curls=read_clip(), quiet) {

  if (missing(quiet)) quiet <- quiet_option()

  tmp <- straighten(curls, quiet)
  tmp <- make_req(tmp)
  tmp[[1]]

}
