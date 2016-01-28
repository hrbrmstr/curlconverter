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
library(jsonlite)

# current verison
packageVersion("curlconverter")
#> [1] '0.2.0.9000'

toJSON(straighten("curl 'http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337' -H 'Cookie: JSESSIONID=5E43C98903E865D72AA3C2DCEF317848; sfhabit=asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14; ScrollY=0' -H 'DNT: 1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Accept: text/javascript, application/javascript, */*' -H 'Referer: http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed"), pretty=TRUE)
#> [
#>   {
#>     "url": ["http://financials.morningstar.com/ajax/ReportProcess4HtmlAjax.html?&t=XNAS:MSFT&region=usa&culture=en-US&cur=&reportType=is&period=12&dataType=A&order=asc&columnYear=5&curYearPart=1st5year&rounding=3&view=raw&r=973302&callback=jsonp1454021128757&_=1454021129337"],
#>     "method": ["get"],
#>     "headers": {
#>       "DNT": ["1"],
#>       "Accept-Encoding": ["gzip, deflate, sdch"],
#>       "Accept-Language": ["en-US,en;q=0.8"],
#>       "User-Agent": ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36"],
#>       "Accept": ["text/javascript, application/javascript, */*"],
#>       "Referer": ["http://financials.morningstar.com/income-statement/is.html?t=MSFT&region=usa&culture=en-US"],
#>       "X-Requested-With": ["XMLHttpRequest"],
#>       "Connection": ["keep-alive"],
#>       "Cache-Control": ["max-age=0"]
#>     },
#>     "cookies": {
#>       "JSESSIONID": ["5E43C98903E865D72AA3C2DCEF317848"],
#>       "sfhabit": ["asc%7Craw%7C3%7C12%7CA%7C5%7Cv0.14"],
#>       "ScrollY": ["0"]
#>     },
#>     "url_parts": {
#>       "scheme": ["http"],
#>       "hostname": ["financials.morningstar.com"],
#>       "port": {},
#>       "path": ["ajax/ReportProcess4HtmlAjax.html"],
#>       "query": {
#>         "1": [""],
#>         "t": ["XNAS:MSFT"],
#>         "region": ["usa"],
#>         "culture": ["en-US"],
#>         "cur": [""],
#>         "reportType": ["is"],
#>         "period": ["12"],
#>         "dataType": ["A"],
#>         "order": ["asc"],
#>         "columnYear": ["5"],
#>         "curYearPart": ["1st5year"],
#>         "rounding": ["3"],
#>         "view": ["raw"],
#>         "r": ["973302"],
#>         "callback": ["jsonp1454021128757"],
#>         "_": ["1454021129337"]
#>       },
#>       "params": {},
#>       "fragment": {},
#>       "username": {},
#>       "password": {}
#>     }
#>   }
#> ]

(curl_line <- readLines(system.file("extdata/curl5.txt", package="curlconverter"), warn=FALSE))
#> [1] "curl -i -X POST http://1.2.3.4/endpoint -H \"Content-Type:application/json\" -H 'key:abcdefg'"

toJSON(straighten(curl_line), pretty=TRUE)
#> [
#>   {
#>     "url": ["http://1.2.3.4/endpoint"],
#>     "method": ["post"],
#>     "headers": {
#>       "Content-Type": ["application/json"],
#>       "key": ["abcdefg"]
#>     },
#>     "url_parts": {
#>       "scheme": ["http"],
#>       "hostname": ["1.2.3.4"],
#>       "port": {},
#>       "path": ["endpoint"],
#>       "query": {},
#>       "params": {},
#>       "fragment": {},
#>       "username": {},
#>       "password": {}
#>     }
#>   }
#> ]
```

### Test Results

``` r
library(curlconverter)
library(testthat)

date()
#> [1] "Thu Jan 28 17:58:26 2016"

test_dir("tests/")
#> testthat results ========================================================================================================
#> OK: 1 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
