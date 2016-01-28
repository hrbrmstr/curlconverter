context("basic functionality")
test_that("we can do something", {

  expect_that(all(c(4L, 4L, 4L, 2L, 3L, 4L, 3L) ==
                    sapply(sapply(
                      sapply(list.files(system.file("extdata/", package="curlconverter"), full.names=TRUE), readLines, warn=FALSE), straighten), length)),
              is_true())

})
