
<!-- README.md is generated from README.Rmd. Please edit that file -->
curlconverter - Generate `httr` functions or parameters for use with `httr` from `cURL` commands.

Based on the [`curlconverter`](https://github.com/NickCarneiro/curlconverter) Node module by Nick Carneiro

The following functions are implemented:

-   `straighten`: convert one or more *"Copy as cURL"* command lines into useful data
-   `parse_query`: parse URL query parameters into a named list

### News

-   Version 0.3.0 : Added `parse_query`
-   Version 0.2.0 : Added parsed URL to return value of `straighten()`
-   Version 0.1.0 released

### Installation

``` r
devtools::install_github("hrbrmstr/curlconverter")
```

### Usage

``` r
library(curlconverter)
library(jsonlite)

# current verison
packageVersion("curlconverter")
# [1] '0.3.0.9000'

toJSON(straighten("curl 'http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337' -H 'Cookie: JSESSIONID=5E43C98903E865D72AA3C2DCEF317848; sfhabit=asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14; ScrollY=0' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Accept: text/javascript, application/javascript, */*' -H 'Referer: http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed"), pretty=TRUE)
# curl 'http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337' -H 'Cookie: JSESSIONID=5E43C98903E865D72AA3C2DCEF317848; sfhabit=asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14; ScrollY=0' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Accept: text/javascript, application/javascript, */*' -H 'Referer: http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed
# [
#   {
#     "url": ["http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337"],
#     "method": ["get"],
#     "headers": {
#       "DNT": ["1"],
#       "Accept-Encoding": ["gzip, deflate, sdch"],
#       "Accept-Language": ["en-US,en;q=0.8"],
#       "User-Agent": ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"],
#       "Accept": ["text/javascript, application/javascript, */*"],
#       "Referer": ["http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US"],
#       "X-Requested-With": ["XMLHttpRequest"],
#       "Connection": ["keep-alive"],
#       "Cache-Control": ["max-age=0"]
#     },
#     "cookies": {
#       "JSESSIONID": ["5E43C98903E865D72AA3C2DCEF317848"],
#       "sfhabit": ["asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14"],
#       "ScrollY": ["0"]
#     },
#     "url_parts": {
#       "scheme": ["http"],
#       "hostname": ["financials.morningstar.com"],
#       "port": {},
#       "path": ["ajax/ReportProcess4HtmlAjax.html"],
#       "query": {
#         "1": [""],
#         "t": ["XNAS:MSFT"],
#         "region": ["usa"],
#         "culture": ["en-US"],
#         "cur": [""],
#         "reportType": ["is"],
#         "period": ["12"],
#         "dataType": ["A"],
#         "order": ["asc"],
#         "columnYear": ["5"],
#         "curYearPart": ["1st5year"],
#         "rounding": ["3"],
#         "view": ["raw"],
#         "r": ["973302"],
#         "callback": ["jsonp1454021128757"],
#         "_": ["1454021129337"]
#       },
#       "params": {},
#       "fragment": {},
#       "username": {},
#       "password": {}
#     }
#   }
# ]

(curl_line <- readLines(system.file("extdata/curl5.txt", package="curlconverter"), warn=FALSE))
# [1] "curl -i -X POST http://1.2.3.4/endpoint -H \"Content-Type:application/json\" -H 'key:abcdefg'"

toJSON(straighten(curl_line, quiet=TRUE), pretty=TRUE)
# [
#   {
#     "url": ["http://1.2.3.4/endpoint"],
#     "method": ["post"],
#     "headers": {
#       "Content-Type": ["application/json"],
#       "key": ["abcdefg"]
#     },
#     "url_parts": {
#       "scheme": ["http"],
#       "hostname": ["1.2.3.4"],
#       "port": {},
#       "path": ["endpoint"],
#       "query": {},
#       "params": {},
#       "fragment": {},
#       "username": {},
#       "password": {}
#     }
#   }
# ]

(curl_line <- readLines(system.file("extdata/curl8.txt", package="curlconverter"), warn=FALSE))
# [1] "curl 'https://research.stlouisfed.org/fred2/series/MKTGDPSAA646NWDB/downloaddata' -H 'Pragma: no-cache' -H 'Origin: https://research.stlouisfed.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.39 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: https://research.stlouisfed.org/fred2/series/MKTGDPSAA646NWDB/downloaddata' -H 'Connection: keep-alive' -H 'DNT: 1' --data 'form%5Bnative_frequency%5D=Annual&form%5Bunits%5D=lin&form%5Bfrequency%5D=Annual&form%5Baggregation%5D=Average&form%5Bobs_start_date%5D=1968-01-01&form%5Bobs_end_date%5D=2014-01-01&form%5Bfile_format%5D=csv&form%5Bdownload_data_2%5D=' --compressed"

# example with query parameters in the body
req <- straighten(curl_line, quiet=FALSE)
# curl 'https://research.stlouisfed.org/fred2/series/MKTGDPSAA646NWDB/downloaddata' -H 'Pragma: no-cache' -H 'Origin: https://research.stlouisfed.org' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.39 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: https://research.stlouisfed.org/fred2/series/MKTGDPSAA646NWDB/downloaddata' -H 'Connection: keep-alive' -H 'DNT: 1' --data 'form%5Bnative_frequency%5D=Annual&form%5Bunits%5D=lin&form%5Bfrequency%5D=Annual&form%5Baggregation%5D=Average&form%5Bobs_start_date%5D=1968-01-01&form%5Bobs_end_date%5D=2014-01-01&form%5Bfile_format%5D=csv&form%5Bdownload_data_2%5D=' --compressed

# ugh
(req[[1]]$data)
# [1] "form%5Bnative_frequency%5D=Annual&form%5Bunits%5D=lin&form%5Bfrequency%5D=Annual&form%5Baggregation%5D=Average&form%5Bobs_start_date%5D=1968-01-01&form%5Bobs_end_date%5D=2014-01-01&form%5Bfile_format%5D=csv&form%5Bdownload_data_2%5D="

#yay!
toJSON(parse_query(req[[1]]$data), pretty=TRUE)
# {
#   "form[native_frequency]": ["Annual"],
#   "form[units]": ["lin"],
#   "form[frequency]": ["Annual"],
#   "form[aggregation]": ["Average"],
#   "form[obs_start_date]": ["1968-01-01"],
#   "form[obs_end_date]": ["2014-01-01"],
#   "form[file_format]": ["csv"],
#   "form[download_data_2]": [""]
# }
```

### Test Results

``` r
library(curlconverter)
library(testthat)

date()
# [1] "Sun Feb  7 08:20:12 2016"

test_dir("tests/")
# Warning in c(5L, 5L, 5L, 3L, 4L, 5L, 4L) == sapply(sapply(sapply(list.files(system.file("extdata/", : longer object
# length is not a multiple of shorter object length
# testthat results ========================================================================================================
# OK: 1 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
