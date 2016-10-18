context("HAR processing")
test_that("from_har works", {
  hardir <- system.file("extdata", package = "curlconverter")
  harfile <- file.path(hardir, "har1.har")
  curl_vec <- harfile %>% from_har
  expect_true(inherits(curl_vec, "character"))
}
)
