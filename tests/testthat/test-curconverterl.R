context("basic functionality")
test_that("we can do something", {

  expect_that(all(c(5L, 5L, 5L, 3L, 4L, 5L, 4L) ==
                    sapply(sapply(
                      sapply(list.files(system.file("extdata/", package="curlconverter"), full.names=TRUE), readLines, warn=FALSE), straighten), length)),
              is_true())

})
