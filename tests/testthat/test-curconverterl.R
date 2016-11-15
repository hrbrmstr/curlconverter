context("cURL processing")
test_that("straighten works", {
  skip_if_not(clipr_available())
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
  skip_if_not(clipr_available())
  lapply(sapply(list.files(system.file("extdata",
                                       package="curlconverter"),
                        full.names=TRUE),
                readLines, warn=FALSE), straighten) -> combed

  for (i in seq_along(combed)) {
    cat(".")
    make_req(combed[[i]])
  }

})
