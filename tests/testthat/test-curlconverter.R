context("cURL processing")
test_that("straighten works", {

  lapply(
    list.files(system.file("extdata", package="curlconverter"), "txt$", full.names=TRUE),
    function(x) {
      straighten(paste0(readLines(x, warn=FALSE), collapse=" "), quiet=TRUE)
    }
  ) -> st

  expect_equal(sum(sapply(st, function(x) length(unlist(x)))), 175)

})

test_that("make_req works", {

  lapply(
    list.files(system.file("extdata", package="curlconverter"), "txt$", full.names=TRUE),
    function(x) {
      st <- straighten(paste0(readLines(x, warn=FALSE), collapse=" "), quiet=TRUE)
      make_req(st, quiet=TRUE, add_clip=FALSE)
    }
  ) -> mr

  expect_equal(sum(grepl("GET", as.character(unlist(mr)))), 7)

})
