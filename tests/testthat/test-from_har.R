context("HAR processing")
test_that("from_har works", {
  hardir <- system.file("extdata", package = "curlconverter")
  harfile <- file.path(hardir, "har1.har")
  curl_vec <- harfile %>% from_har
  expect_true(inherits(curl_vec, "character"))
}
)

# test_that("from_har can be straightened", {
#   hardir <- system.file("extdata", package = "curlconverter")
#   harfile <- file.path(hardir, "har1.har")
#   curl_vec <- harfile %>%
#     from_har %>%
#     straighten(quiet = TRUE)
#   chk <- vapply(curl_vec, is, logical(1), class2 = "cc_obj")
#   expect_true(all(chk))
# }
# )

# test_that("from_har can make_req", {
#   hardir <- system.file("extdata", package = "curlconverter")
#   harfile <- file.path(hardir, "har1.har")
#   curl_vec <- harfile %>%
#     from_har %>%
#     straighten(quiet = TRUE) %>%
#     make_req
#   chk <- vapply(curl_vec, is, logical(1), class2 = "function")
#   expect_true(all(chk))
# }
# )
