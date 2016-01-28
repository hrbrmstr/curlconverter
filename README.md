<!-- README.md is generated from README.Rmd. Please edit that file -->
curlconverter - Generate `httr` functions or parameters for use with `httr` from `cURL` commands.

Based on the [`curlconverter`](https://github.com/NickCarneiro/curlconverter) Node module by Nick Carneiro

The following functions are implemented:

-   `straighten`: generate the data/function

### News

-   Version 0.1.0 released

### Installation

``` r
devtools::install_github("hrbrmstr/curlconverter")
```

### Usage

``` r
library(curlconverter)

# current verison
packageVersion("curlconverter")
#> [1] '0.1.0.9000'

(curl_line <- readLines(system.file("extdata/curl5.txt", package="curlconverter"), warn=FALSE))
#> [1] "curl -i -X POST http://1.2.3.4/endpoint -H \"Content-Type:application/json\" -H 'key:abcdefg'"

straighten(curl_line)
#> $url
#> [1] "http://1.2.3.4/endpoint"
#> 
#> $method
#> [1] "post"
#> 
#> $headers
#> $headers$`Content-Type`
#> [1] "application/json"
#> 
#> $headers$key
#> [1] "abcdefg"
```

### Test Results

``` r
library(curlconverter)
library(testthat)

date()
#> [1] "Thu Jan 28 10:18:59 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 1 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
