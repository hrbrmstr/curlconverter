
<!-- README.md is generated from README.Rmd. Please edit that file -->
curlconverter - Generate `httr` functions or parameters for use with `httr` from `cURL` commands.

Based on the [`curlconverter`](https://github.com/NickCarneiro/curlconverter) Node module by Nick Carneiro

The following functions are implemented:

-   `straighten`: convert one or more *"Copy as cURL"* command lines into useful data
-   `parse_query`: parse URL query parameters into a named list
-   `make_req`: turn a cURL command line into an `httr` request

### News

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
# [1] '0.4.0.9000'

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

make_req(curl_line)
# curl "http://anasim.iet.unipi.it/moniqa/php/from_js.php" -H "Origin: http://anasim.iet.unipi.it" -H "Accept-Encoding: gzip, deflate" -H "Accept-Language: it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4" -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: http://anasim.iet.unipi.it/moniqa/" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "deviceid=1&function_name=extract_measurements" --compressed
# VERB(verb = "POST", url = "http://anasim.iet.unipi.it/moniqa/php/from_js.php", 
#     add_headers(Origin = "http://anasim.iet.unipi.it", 
#         `Accept-Encoding` = "gzip, deflate", 
#         `Accept-Language` = "it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4", 
#         `User-Agent` = "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36", 
#         Accept = "*/*", Referer = "http://anasim.iet.unipi.it/moniqa/", 
#         `X-Requested-With` = "XMLHttpRequest", 
#         Connection = "keep-alive"), 
#     body = list(deviceid = "1", 
#         function_name = "extract_measurements"), 
#     encode = "form")
# [1] "VERB(verb = \"POST\", url = \"http://anasim.iet.unipi.it/moniqa/php/from_js.php\", \n    add_headers(Origin = \"http://anasim.iet.unipi.it\", \n        `Accept-Encoding` = \"gzip, deflate\", \n        `Accept-Language` = \"it-IT,it;q=0.8,en-US;q=0.6,en;q=0.4\", \n        `User-Agent` = \"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36\", \n        Accept = \"*/*\", Referer = \"http://anasim.iet.unipi.it/moniqa/\", \n        `X-Requested-With` = \"XMLHttpRequest\", \n        Connection = \"keep-alive\"), \n    body = list(deviceid = \"1\", \n        function_name = \"extract_measurements\"), \n    encode = \"form\") "

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
#       "measure": ["87"],
#       "fk_sensortype": ["1"],
#       "date": ["1454889600000"]
#     },
#     {
#       "measure": ["87"],
#       "fk_sensortype": ["2"],
#       "date": ["1454889600000"]
#     },
#     {
#       "measure": ["8"],
#       "fk_sensortype": ["3"],
#       "date": ["1454889600000"]
#     },
#     {
#       "measure": ["56"],
#       "fk_sensortype": ["1"],
#       "date": ["1454893200000"]
#     },
#     {
#       "measure": ["6"],
#       "fk_sensortype": ["2"],
#       "date": ["1454893200000"]
#     },
#     {
#       "measure": ["21"],
#       "fk_sensortype": ["3"],
#       "date": ["1454893200000"]
#     },
#     {
#       "measure": ["22"],
#       "fk_sensortype": ["1"],
#       "date": ["1454896800000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454896800000"]
#     },
#     {
#       "measure": ["59"],
#       "fk_sensortype": ["3"],
#       "date": ["1454896800000"]
#     },
#     {
#       "measure": ["60"],
#       "fk_sensortype": ["3"],
#       "date": ["1454900400000"]
#     },
#     {
#       "measure": ["25"],
#       "fk_sensortype": ["1"],
#       "date": ["1454904000000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454904000000"]
#     },
#     {
#       "measure": ["60"],
#       "fk_sensortype": ["3"],
#       "date": ["1454904000000"]
#     },
#     {
#       "measure": ["22"],
#       "fk_sensortype": ["1"],
#       "date": ["1454907600000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454907600000"]
#     },
#     {
#       "measure": ["62"],
#       "fk_sensortype": ["3"],
#       "date": ["1454907600000"]
#     },
#     {
#       "measure": ["19"],
#       "fk_sensortype": ["1"],
#       "date": ["1454911200000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454911200000"]
#     },
#     {
#       "measure": ["67"],
#       "fk_sensortype": ["3"],
#       "date": ["1454911200000"]
#     },
#     {
#       "measure": ["19"],
#       "fk_sensortype": ["1"],
#       "date": ["1454914800000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454914800000"]
#     },
#     {
#       "measure": ["69"],
#       "fk_sensortype": ["3"],
#       "date": ["1454914800000"]
#     },
#     {
#       "measure": ["24"],
#       "fk_sensortype": ["1"],
#       "date": ["1454918400000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454918400000"]
#     },
#     {
#       "measure": ["68"],
#       "fk_sensortype": ["3"],
#       "date": ["1454918400000"]
#     },
#     {
#       "measure": ["18"],
#       "fk_sensortype": ["1"],
#       "date": ["1454922000000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454922000000"]
#     },
#     {
#       "measure": ["80"],
#       "fk_sensortype": ["3"],
#       "date": ["1454922000000"]
#     },
#     {
#       "measure": ["13"],
#       "fk_sensortype": ["1"],
#       "date": ["1454925600000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454925600000"]
#     },
#     {
#       "measure": ["84"],
#       "fk_sensortype": ["3"],
#       "date": ["1454925600000"]
#     },
#     {
#       "measure": ["11"],
#       "fk_sensortype": ["1"],
#       "date": ["1454929200000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454929200000"]
#     },
#     {
#       "measure": ["84"],
#       "fk_sensortype": ["3"],
#       "date": ["1454929200000"]
#     },
#     {
#       "measure": ["14"],
#       "fk_sensortype": ["1"],
#       "date": ["1454932800000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454932800000"]
#     },
#     {
#       "measure": ["82"],
#       "fk_sensortype": ["3"],
#       "date": ["1454932800000"]
#     },
#     {
#       "measure": ["15"],
#       "fk_sensortype": ["1"],
#       "date": ["1454936400000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454936400000"]
#     },
#     {
#       "measure": ["80"],
#       "fk_sensortype": ["3"],
#       "date": ["1454936400000"]
#     },
#     {
#       "measure": ["13"],
#       "fk_sensortype": ["1"],
#       "date": ["1454940000000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454940000000"]
#     },
#     {
#       "measure": ["80"],
#       "fk_sensortype": ["3"],
#       "date": ["1454940000000"]
#     },
#     {
#       "measure": ["12"],
#       "fk_sensortype": ["1"],
#       "date": ["1454943600000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454943600000"]
#     },
#     {
#       "measure": ["82"],
#       "fk_sensortype": ["3"],
#       "date": ["1454943600000"]
#     },
#     {
#       "measure": ["22"],
#       "fk_sensortype": ["1"],
#       "date": ["1454947200000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454947200000"]
#     },
#     {
#       "measure": ["68"],
#       "fk_sensortype": ["3"],
#       "date": ["1454947200000"]
#     },
#     {
#       "measure": ["19"],
#       "fk_sensortype": ["1"],
#       "date": ["1454950800000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454950800000"]
#     },
#     {
#       "measure": ["75"],
#       "fk_sensortype": ["3"],
#       "date": ["1454950800000"]
#     },
#     {
#       "measure": ["22"],
#       "fk_sensortype": ["1"],
#       "date": ["1454954400000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454954400000"]
#     },
#     {
#       "measure": ["72"],
#       "fk_sensortype": ["3"],
#       "date": ["1454954400000"]
#     },
#     {
#       "measure": ["25"],
#       "fk_sensortype": ["1"],
#       "date": ["1454958000000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454958000000"]
#     },
#     {
#       "measure": ["71"],
#       "fk_sensortype": ["3"],
#       "date": ["1454958000000"]
#     },
#     {
#       "measure": ["19"],
#       "fk_sensortype": ["1"],
#       "date": ["1454961600000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454961600000"]
#     },
#     {
#       "measure": ["76"],
#       "fk_sensortype": ["3"],
#       "date": ["1454961600000"]
#     },
#     {
#       "measure": ["22"],
#       "fk_sensortype": ["1"],
#       "date": ["1454965200000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454965200000"]
#     },
#     {
#       "measure": ["71"],
#       "fk_sensortype": ["3"],
#       "date": ["1454965200000"]
#     },
#     {
#       "measure": ["10"],
#       "fk_sensortype": ["1"],
#       "date": ["1454968800000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454968800000"]
#     },
#     {
#       "measure": ["87"],
#       "fk_sensortype": ["3"],
#       "date": ["1454968800000"]
#     },
#     {
#       "measure": ["8"],
#       "fk_sensortype": ["1"],
#       "date": ["1454972400000"]
#     },
#     {
#       "measure": ["0"],
#       "fk_sensortype": ["2"],
#       "date": ["1454972400000"]
#     },
#     {
#       "measure": ["88"],
#       "fk_sensortype": ["3"],
#       "date": ["1454972400000"]
#     },
#     {
#       "measure": ["24"],
#       "fk_sensortype": ["4"],
#       "date": ["1454972400000"]
#     }
#   ]
# }
```

### Test Results

``` r
library(curlconverter)
library(testthat)

date()
# [1] "Tue Feb  9 22:20:01 2016"

test_dir("tests/")
# Warning in c(5L, 5L, 5L, 3L, 4L, 5L, 4L) == sapply(sapply(sapply(list.files(system.file("extdata/", : longer object
# length is not a multiple of shorter object length
# testthat results ========================================================================================================
# OK: 1 SKIPPED: 0 FAILED: 0
```

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
