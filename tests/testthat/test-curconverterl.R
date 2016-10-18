context("cURL processing")
test_that("straighten works", {

  expect_that(all(c(8L, 6L, 6L, 6L, 4L, 5L, 6L, 5L, 6L, 6L) ==
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
                      length)
  ),
  is_true())

})

test_that("make_req works", {

  lapply(sapply(list.files(system.file("extdata",
                                       package="curlconverter"),
                           full.names=TRUE, pattern = "curl"),
                readLines, warn=FALSE), straighten) -> combed

  for (i in seq_along(combed)) {
    cat(".")
    make_req(combed[[i]])
  }

})
