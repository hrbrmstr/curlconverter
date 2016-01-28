<!-- README.md is generated from README.Rmd. Please edit that file -->
curlconverter - Generate `httr` functions or parameters for use with `httr` from `cURL` commands.

Based on the [`curlconverter`](https://github.com/NickCarneiro/curlconverter) Node module by Nick Carneiro

The following functions are implemented:

-   `straighten`: generate the data/function

### News

-   Version 0.2.0 : Added parsed URL to return value of `straighten()`
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
#> [1] '0.2.0.9000'

straighten("curl 'http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337' -H 'Cookie: JSESSIONID=5E43C98903E865D72AA3C2DCEF317848; sfhabit=asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14; ScrollY=0' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Accept: text/javascript, application/javascript, */*' -H 'Referer: http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed")
#> [[1]]
#> [[1]]$url
#> [1] "http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337"
#> 
#> [[1]]$method
#> [1] "get"
#> 
#> [[1]]$headers
#> [[1]]$headers$DNT
#> [1] "1"
#> 
#> [[1]]$headers$`Accept-Encoding`
#> [1] "gzip, deflate, sdch"
#> 
#> [[1]]$headers$`Accept-Language`
#> [1] "en-US,en;q=0.8"
#> 
#> [[1]]$headers$`User-Agent`
#> [1] "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"
#> 
#> [[1]]$headers$Accept
#> [1] "text/javascript, application/javascript, */*"
#> 
#> [[1]]$headers$Referer
#> [1] "http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US"
#> 
#> [[1]]$headers$`X-Requested-With`
#> [1] "XMLHttpRequest"
#> 
#> [[1]]$headers$Connection
#> [1] "keep-alive"
#> 
#> [[1]]$headers$`Cache-Control`
#> [1] "max-age=0"
#> 
#> 
#> [[1]]$cookies
#> [[1]]$cookies$JSESSIONID
#> [1] "5E43C98903E865D72AA3C2DCEF317848"
#> 
#> [[1]]$cookies$sfhabit
#> [1] "asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14"
#> 
#> [[1]]$cookies$ScrollY
#> [1] "0"
#> 
#> 
#> [[1]]$url_parts
#> [[1]]$url_parts$scheme
#> [1] "http"
#> 
#> [[1]]$url_parts$hostname
#> [1] "financials.morningstar.com"
#> 
#> [[1]]$url_parts$port
#> NULL
#> 
#> [[1]]$url_parts$path
#> [1] "ajax/ReportProcess4HtmlAjax.html"
#> 
#> [[1]]$url_parts$query
#> [[1]]$url_parts$query[[1]]
#> [1] ""
#> 
#> [[1]]$url_parts$query$t
#> [1] "XNAS:MSFT"
#> 
#> [[1]]$url_parts$query$region
#> [1] "usa"
#> 
#> [[1]]$url_parts$query$culture
#> [1] "en-US"
#> 
#> [[1]]$url_parts$query$cur
#> [1] ""
#> 
#> [[1]]$url_parts$query$reportType
#> [1] "is"
#> 
#> [[1]]$url_parts$query$period
#> [1] "12"
#> 
#> [[1]]$url_parts$query$dataType
#> [1] "A"
#> 
#> [[1]]$url_parts$query$order
#> [1] "asc"
#> 
#> [[1]]$url_parts$query$columnYear
#> [1] "5"
#> 
#> [[1]]$url_parts$query$curYearPart
#> [1] "1st5year"
#> 
#> [[1]]$url_parts$query$rounding
#> [1] "3"
#> 
#> [[1]]$url_parts$query$view
#> [1] "raw"
#> 
#> [[1]]$url_parts$query$r
#> [1] "973302"
#> 
#> [[1]]$url_parts$query$callback
#> [1] "jsonp1454021128757"
#> 
#> [[1]]$url_parts$query$`_`
#> [1] "1454021129337"
#> 
#> 
#> [[1]]$url_parts$params
#> NULL
#> 
#> [[1]]$url_parts$fragment
#> NULL
#> 
#> [[1]]$url_parts$username
#> NULL
#> 
#> [[1]]$url_parts$password
#> NULL

(curl_line <- readLines(system.file("extdata/curl5.txt", package="curlconverter"), warn=FALSE))
#> [1] "curl -i -X POST http://1.2.3.4/endpoint -H \"Content-Type:application/json\" -H 'key:abcdefg'"

straighten(curl_line)
#> [[1]]
#> [[1]]$url
#> [1] "http://1.2.3.4/endpoint"
#> 
#> [[1]]$method
#> [1] "post"
#> 
#> [[1]]$headers
#> [[1]]$headers$`Content-Type`
#> [1] "application/json"
#> 
#> [[1]]$headers$key
#> [1] "abcdefg"
#> 
#> 
#> [[1]]$url_parts
#> [[1]]$url_parts$scheme
#> [1] "http"
#> 
#> [[1]]$url_parts$hostname
#> [1] "1.2.3.4"
#> 
#> [[1]]$url_parts$port
#> NULL
#> 
#> [[1]]$url_parts$path
#> [1] "endpoint"
#> 
#> [[1]]$url_parts$query
#> NULL
#> 
#> [[1]]$url_parts$params
#> NULL
#> 
#> [[1]]$url_parts$fragment
#> NULL
#> 
#> [[1]]$url_parts$username
#> NULL
#> 
#> [[1]]$url_parts$password
#> NULL
```

### Test Results

``` r
library(curlconverter)
library(testthat)

date()
#> [1] "Thu Jan 28 17:55:10 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 1 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
