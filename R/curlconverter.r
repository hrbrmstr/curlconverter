#' Processes cURL command-line requests
#'
#' Takes in a \emph{"Copy as cURL"} command line and returns a \code{list} of
#' components that can be used to build \code{httr} requests or passed to
#' \code{\link{make_req}()} to automagically make an \code{httr}
#' \code{\link[httr]{VERB}()} function.
#'
#' @param curls a character vector of one or more cURL command lines. It will
#'        read from the clipboard (i.e. if you did a \emph{"Copy as cURL"} from
#'        browser developer tools).
#' @param quiet if \code{FALSE}, a \code{message} with the original \code{cURL}
#'        command line will be output. (Default: \code{FALSE})
#' @return \code{list} of \code{length(curls)} containing parsed data (i.e. to be used
#'          in `httr` requests)
#' @seealso \code{\link{make_req}()}, \code{httr} \code{\link[httr]{VERB}()}
#' @references \href{https://developer.chrome.com/devtools/docs/network}{Evaluating Network Performance},
#'             \href{https://developer.mozilla.org/en-US/docs/Tools/Network_Monitor}{Network Monitor}
#' @export
#' @examples
#' library(httr)
#'
#' my_ip <- straighten("curl 'https://httpbin.org/ip'") %>% make_req()
#'
#' \dontrun{
#' # external test which captures live data
#' content(my_ip[[1]](), as="parsed")
#' }
straighten <- function(curls=read_clip(), quiet=FALSE) {
  if (!quiet) message(curls)
  obj <- purrr::map(curls, process_curl)
  class(obj) <- c("cc_container", class(obj))
  obj
}
