#' Take cURL from clipboard and do magic
#'
#' @export
convertAddin <- function() {

  clip_txt <- trimws(clipr::read_clip())[1]

  if (grepl("^curl", clip_txt)) {

    st_name <- temp_name()
    mr_name <- temp_name()


    sprintf("%s <- curlconverter::straighten()", st_name) -> st
    sprintf("%s <- curlconverter::make_req(%s)", mr_name, st_name) -> mr
    sprintf("%s", mr_name) -> fout

    code_to_exec <-  sprintf("%s\n%s\n%s\n", st, mr, fout)

    rstudioapi::sendToConsole(code_to_exec, execute = TRUE)

  }

}
