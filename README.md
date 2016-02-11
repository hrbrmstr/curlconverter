
<!-- README.md is generated from README.Rmd. Please edit that file -->
curlconverter - Generate `httr` functions or parameters for use with `httr` from `cURL` commands.

Based on the [`curlconverter`](https://github.com/NickCarneiro/curlconverter) Node module by Nick Carneiro

The following functions are implemented:

-   `straighten`: convert one or more *"Copy as cURL"* command lines into useful data
-   `parse_query`: parse URL query parameters into a named list
-   `make_req`: turn a cURL command line into an `httr` request (i.e. returns a working function)

### News

-   Version 0.5.0 : `make_req` now actually *returns a working/callable R function*
-   Version 0.4.0 : `make_req` turns the cURLs into `httr` requests
-   Version 0.3.1 : handles `--header` now (fixes \#1)
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
library(httr)

# current verison
packageVersion("curlconverter")
# [1] '0.5.0.9000'
```

Simple example using a call to <https://httpbin.org/headers>

``` r
httpbinrhcurl <- "curl 'https://httpbin.org/headers' -H 'pragma: no-cache' -H 'accept-encoding: gzip, deflate, sdch' -H 'accept-language: en-US,en;q=0.8' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.39 Safari/537.36' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'cache-control: no-cache' -H 'referer: https://httpbin.org/' --compressed"

show_req_headers <- make_req(httpbinrhcurl, quiet=TRUE)
res <- show_req_headers()
toJSON(content(res, as="parsed"), pretty=TRUE)
# {
#   "headers": {
#     "Accept": ["application/json, text/xml, application/xml, */*,text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"],
#     "Accept-Encoding": ["gzip, deflate, sdch"],
#     "Accept-Language": ["en-US,en;q=0.8"],
#     "Cache-Control": ["no-cache"],
#     "Content-Length": ["0"],
#     "Host": ["httpbin.org"],
#     "Pragma": ["no-cache"],
#     "Referer": ["https://httpbin.org/"],
#     "Upgrade-Insecure-Requests": ["1"],
#     "User-Agent": ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.39 Safari/537.36"]
#   }
# }
```

``` r
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

### Spinning straw into gold

``` r
curl_line <- c('curl "http://anasim.iet.unipi.it/moniqa/php/from_js.php" -H "Origin: http://anasim.iet.unipi.it" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: http://anasim.iet.unipi.it/moniqa/" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "deviceid=1&function_name=extract_measurements" --compressed')

get_data <- make_req(curl_line, quiet=TRUE)
toJSON(content(get_data(), as="parsed"), pretty=TRUE)
# {
#   "sensors": [
#     {
#       "fk_sensortype": ["1"]
#     },
#     {
#       "fk_sensortype": ["2"]
#     },
#     {
#       "fk_sensortype": ["3"]
#     },
#     {
#       "fk_sensortype": ["4"]
#     }
#   ],
#   "measures": [
#     {
#       "measure": ["5"],
#       "fk_sensortype": ["1"],
#       "date": ["1454976000000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454976000000"]
#     },
#     {
#       "measure": ["90"],
#       "fk_sensortype": ["3"],
#       "date": ["1454976000000"]
#     },
#     {
#       "measure": ["4"],
#       "fk_sensortype": ["1"],
#       "date": ["1454979600000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454979600000"]
#     },
#     {
#       "measure": ["89"],
#       "fk_sensortype": ["3"],
#       "date": ["1454979600000"]
#     },
#     {
#       "measure": ["7"],
#       "fk_sensortype": ["1"],
#       "date": ["1454983200000"]
#     },
#     {
#       "measure": ["1"],
#       "fk_sensortype": ["2"],
#       "date": ["1454983200000"]
#     },
#     {
#       "measure": ["76"],
#       "fk_sensortype": ["3"],
#       "date": ["1454983200000"]
#     },
#     {
#       "measure": ["74"],
#       "fk_sensortype": ["3"],
#       "date": ["1454986800000"]
#     },
#     {
#       "measure": ["18"],
#       "fk_sensortype": ["1"],
#       "date": ["1454990400000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454990400000"]
#     },
#     {
#       "measure": ["67"],
#       "fk_sensortype": ["3"],
#       "date": ["1454990400000"]
#     },
#     {
#       "measure": ["30"],
#       "fk_sensortype": ["1"],
#       "date": ["1454994000000"]
#     },
#     {
#       "measure": ["1"],
#       "fk_sensortype": ["2"],
#       "date": ["1454994000000"]
#     },
#     {
#       "measure": ["49"],
#       "fk_sensortype": ["3"],
#       "date": ["1454994000000"]
#     },
#     {
#       "measure": ["49"],
#       "fk_sensortype": ["1"],
#       "date": ["1454997600000"]
#     },
#     {
#       "measure": ["4"],
#       "fk_sensortype": ["2"],
#       "date": ["1454997600000"]
#     },
#     {
#       "measure": ["29"],
#       "fk_sensortype": ["3"],
#       "date": ["1454997600000"]
#     },
#     {
#       "measure": ["65"],
#       "fk_sensortype": ["1"],
#       "date": ["1455001200000"]
#     },
#     {
#       "measure": ["15"],
#       "fk_sensortype": ["2"],
#       "date": ["1455001200000"]
#     },
#     {
#       "measure": ["16"],
#       "fk_sensortype": ["3"],
#       "date": ["1455001200000"]
#     },
#     {
#       "measure": ["63"],
#       "fk_sensortype": ["1"],
#       "date": ["1455004800000"]
#     },
#     {
#       "measure": ["16"],
#       "fk_sensortype": ["2"],
#       "date": ["1455004800000"]
#     },
#     {
#       "measure": ["25"],
#       "fk_sensortype": ["3"],
#       "date": ["1455004800000"]
#     },
#     {
#       "measure": ["41"],
#       "fk_sensortype": ["1"],
#       "date": ["1455008400000"]
#     },
#     {
#       "measure": ["3"],
#       "fk_sensortype": ["2"],
#       "date": ["1455008400000"]
#     },
#     {
#       "measure": ["42"],
#       "fk_sensortype": ["3"],
#       "date": ["1455008400000"]
#     },
#     {
#       "measure": ["34"],
#       "fk_sensortype": ["1"],
#       "date": ["1455012000000"]
#     },
#     {
#       "measure": ["3"],
#       "fk_sensortype": ["2"],
#       "date": ["1455012000000"]
#     },
#     {
#       "measure": ["51"],
#       "fk_sensortype": ["3"],
#       "date": ["1455012000000"]
#     },
#     {
#       "measure": ["27"],
#       "fk_sensortype": ["1"],
#       "date": ["1455015600000"]
#     },
#     {
#       "measure": ["3"],
#       "fk_sensortype": ["2"],
#       "date": ["1455015600000"]
#     },
#     {
#       "measure": ["65"],
#       "fk_sensortype": ["3"],
#       "date": ["1455015600000"]
#     },
#     {
#       "measure": ["15"],
#       "fk_sensortype": ["1"],
#       "date": ["1455019200000"]
#     },
#     {
#       "measure": ["2"],
#       "fk_sensortype": ["2"],
#       "date": ["1455019200000"]
#     },
#     {
#       "measure": ["82"],
#       "fk_sensortype": ["3"],
#       "date": ["1455019200000"]
#     },
#     {
#       "measure": ["19"],
#       "fk_sensortype": ["1"],
#       "date": ["1455022800000"]
#     },
#     {
#       "measure": ["1"],
#       "fk_sensortype": ["2"],
#       "date": ["1455022800000"]
#     },
#     {
#       "measure": ["75"],
#       "fk_sensortype": ["3"],
#       "date": ["1455022800000"]
#     },
#     {
#       "measure": ["21"],
#       "fk_sensortype": ["1"],
#       "date": ["1455030000000"]
#     },
#     {
#       "measure": ["2"],
#       "fk_sensortype": ["2"],
#       "date": ["1455030000000"]
#     },
#     {
#       "measure": ["66"],
#       "fk_sensortype": ["3"],
#       "date": ["1455030000000"]
#     },
#     {
#       "measure": ["27"],
#       "fk_sensortype": ["1"],
#       "date": ["1455033600000"]
#     },
#     {
#       "measure": ["2"],
#       "fk_sensortype": ["2"],
#       "date": ["1455033600000"]
#     },
#     {
#       "measure": ["59"],
#       "fk_sensortype": ["3"],
#       "date": ["1455033600000"]
#     },
#     {
#       "measure": ["48"],
#       "fk_sensortype": ["1"],
#       "date": ["1455037200000"]
#     },
#     {
#       "measure": ["3"],
#       "fk_sensortype": ["2"],
#       "date": ["1455037200000"]
#     },
#     {
#       "measure": ["33"],
#       "fk_sensortype": ["3"],
#       "date": ["1455037200000"]
#     },
#     {
#       "measure": ["69"],
#       "fk_sensortype": ["1"],
#       "date": ["1455040800000"]
#     },
#     {
#       "measure": ["12"],
#       "fk_sensortype": ["2"],
#       "date": ["1455040800000"]
#     },
#     {
#       "measure": ["15"],
#       "fk_sensortype": ["3"],
#       "date": ["1455040800000"]
#     },
#     {
#       "measure": ["63"],
#       "fk_sensortype": ["1"],
#       "date": ["1455044400000"]
#     },
#     {
#       "measure": ["8"],
#       "fk_sensortype": ["2"],
#       "date": ["1455044400000"]
#     },
#     {
#       "measure": ["15"],
#       "fk_sensortype": ["3"],
#       "date": ["1455044400000"]
#     },
#     {
#       "measure": ["54"],
#       "fk_sensortype": ["1"],
#       "date": ["1455048000000"]
#     },
#     {
#       "measure": ["3"],
#       "fk_sensortype": ["2"],
#       "date": ["1455048000000"]
#     },
#     {
#       "measure": ["27"],
#       "fk_sensortype": ["3"],
#       "date": ["1455048000000"]
#     },
#     {
#       "measure": ["48"],
#       "fk_sensortype": ["1"],
#       "date": ["1455051600000"]
#     },
#     {
#       "measure": ["2"],
#       "fk_sensortype": ["2"],
#       "date": ["1455051600000"]
#     },
#     {
#       "measure": ["31"],
#       "fk_sensortype": ["3"],
#       "date": ["1455051600000"]
#     },
#     {
#       "measure": ["30"],
#       "fk_sensortype": ["1"],
#       "date": ["1455055200000"]
#     },
#     {
#       "measure": ["1"],
#       "fk_sensortype": ["2"],
#       "date": ["1455055200000"]
#     },
#     {
#       "measure": ["50"],
#       "fk_sensortype": ["3"],
#       "date": ["1455055200000"]
#     },
#     {
#       "measure": ["15"],
#       "fk_sensortype": ["1"],
#       "date": ["1455058800000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1455058800000"]
#     },
#     {
#       "measure": ["64"],
#       "fk_sensortype": ["3"],
#       "date": ["1455058800000"]
#     },
#     {
#       "measure": ["20"],
#       "fk_sensortype": ["4"],
#       "date": ["1455058800000"]
#     }
#   ]
# }
```

That also sends this to the console:

``` r
VERB(verb = "POST", 
     url = "http://anasim.iet.unipi.it/moniqa/php/from_js.php", 
     add_headers(Origin = "http://anasim.iet.unipi.it", 
                 `Accept-Encoding` = "gzip, deflate", 
                 `Accept-Language` = "it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4", 
                 `User-Agent` = "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36", 
                 Accept = "*/*", 
                 Referer = "http://anasim.iet.unipi.it/moniqa/", 
                 `X-Requested-With` = "XMLHttpRequest", 
                 Connection = "keep-alive"), 
     body = list(deviceid = "1", 
                 function_name = "extract_measurements"), 
     encode = "form") -> tmp

toJSON(content(tmp), pretty=TRUE)
```

### Test Results

``` r
library(curlconverter)
library(testthat)

date()
# [1] "Thu Feb 11 05:37:21 2016"

test_dir("tests/")
# Warning in c(5L, 5L, 5L, 3L, 4L, 5L, 4L) == sapply(sapply(sapply(list.files(system.file("extdata/", : longer object
# length is not a multiple of shorter object length
# testthat results ========================================================================================================
# OK: 1 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
