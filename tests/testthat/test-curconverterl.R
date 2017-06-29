context("cURL processing")
test_that("straighten works", {

  curl_vec <-
    sapply(
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
    )
  names(curl_vec) <- basename(names(curl_vec))
  test_vec <- structure(c(8L, 6L, 6L, 6L, 4L, 5L, 6L, 5L, 6L, 6L),
                        .Names = c("curl10.txt", "curl1.txt", "curl2.txt",
                                   "curl3.txt", "curl4.txt", "curl5.txt",
                                   "curl6.txt", "curl7.txt", "curl8.txt",
                                   "curl9.txt")
  )
  chk <- vapply(names(test_vec), function(x){
    test_vec[x] == curl_vec[x]
  }, logical(1))
  expect_that(all(chk), is_true())

  skip_if_not(clipr::clipr_available())
  expect_that(all(c(6L, 8L, 6L, 6L, 4L, 5L, 6L, 5L, 6L, 6L) ==
                    sapply(
                      sapply(
                        sapply(list.files(system.file("extdata",
                                                      package="curlconverter"),
                                          full.names=TRUE),
                               readLines, warn=FALSE),
                        straighten), length)),
              is_true())

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
