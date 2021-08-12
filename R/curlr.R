#' curlr
#'
#' @param curl_statement A character string curl statement as you would enter it in the command line
#' @param as.received TRUE for minimal data transformation of the response
#' @param as.json TRUE to transform the response into JSON
#' @param quietly TRUE to avoid printing the curl statement to console
#'
#' @return
#' @export
#'
#' @examples
curlr = function(curl_statement, as.received = F, as.json = F, quietly = T){
  if(quietly){mycurl = straighten(curl_statement) %>% suppressMessages()
  } else {mycurl = straighten(curl_statement) }
  my_req = make_req(mycurl)
  result = content(my_req[[1]](), as="parsed")
  if(!as.received){
    result = toJSON(result, auto_unbox = TRUE, pretty=TRUE)
    if(!as.json){result = fromJSON(result) }
  }
  result
}