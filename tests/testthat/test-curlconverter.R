context("cURL processing")
test_that("straighten works", {

  curl_vec <-
    suppressMessages(sapply(
      sapply(
        vapply(list.files(
          system.file("extdata",package="curlconverter"),
          full.names=TRUE, pattern = "curl"
        ),
        readLines, character(1), warn=FALSE
        ),
        straighten
      ),
      length
    ))
  names(curl_vec) <- basename(names(curl_vec))

  test_vec <-
  structure(c(12L, 12L, 12L, 12L, 12L, 12L, 12L, 12L, 12L, 12L),
    .Names = c("curl1.txt", "curl10.txt", "curl2.txt", "curl3.txt", "curl4.txt",
               "curl5.txt", "curl6.txt", "curl7.txt", "curl8.txt", "curl9.txt"))


  chk <- sapply(names(test_vec), function(x){
    test_vec[x] == curl_vec[x]
  })

  expect_that(all(chk), is_true())

  skip_if_not(clipr::clipr_available())

  suppressMessages(expect_that(all(c(12L, 12L, 12L, 12L, 12L, 12L, 12L, 12L, 12L, 12L) ==
                    sapply(
                      sapply(
                        sapply(list.files(system.file("extdata",
                                                      package="curlconverter"),
                                          pattern = "txt$",
                                          full.names=TRUE),
                               readLines, warn=FALSE, USE.NAMES=FALSE),
                        straighten, USE.NAMES=FALSE), length, USE.NAMES = FALSE)),
              is_true()))

})

test_that("make_req works", {
  skip_if_not(clipr::clipr_available())
  lapply(sapply(list.files(system.file("extdata",
                                       package="curlconverter"),
                           full.names=TRUE, pattern = "curl"),
                readLines, warn=FALSE), straighten) -> combed

  for (i in seq_along(combed)) {
    cat(".")
    make_req(combed[[i]])
  }

})
