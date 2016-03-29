#' Turn parsed cURL command lines into \code{httr} request functions
#'
#' Takes the output of \code{\link{straighten}()} and turns the parsed cURL command lines
#' into working \code{httr} \code{\link[httr]{VERB}()} functions, optionally \code{cat}'ing the text of each function
#' to the console and/or replacing the system clipboard with the source code for the function.
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
#' @return a \code{list} of working R \code{function}s.
#' @seealso \code{\link{straighten}()}, \code{httr} \code{\link[httr]{VERB}()}
#' @references \href{https://developer.chrome.com/devtools/docs/network}{Evaluating Network Performance},
#'             \href{https://developer.mozilla.org/en-US/docs/Tools/Network_Monitor}{Network Monitor}
#' @examples
#' library(httr)
#'
#' my_ip <- straighten("curl 'https://httpbin.org/ip'") %>% make_req()
#'
#' \dontrun{
#' # external test which captures live data
#' content(my_ip[[1]](), as="parsed")
#' }
#' @export
make_req <- function(x, use_parts=FALSE, quiet=TRUE, add_clip=(length(x)==1)) {
  req <- purrr::map(x,
                    create_httr_function,
                    use_parts=use_parts,
                    quiet=quiet,
                    add_clip=add_clip)
}
