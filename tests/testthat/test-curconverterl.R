context("cURL processing")
test_that("we can do something", {

  expect_that(all(c(6L, 6L, 6L, 4L, 5L, 6L, 5L, 6L, 5L) ==
                    sapply(
                      sapply(
                        sapply(list.files(system.file("extdata/",
                                                      package="curlconverter"),
                                          full.names=TRUE),
                               readLines, warn=FALSE),
                        straighten), length)),
              is_true())

})
