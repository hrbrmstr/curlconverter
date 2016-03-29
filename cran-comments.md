## Test environments
* local OS X install, R 3.2.4
* ubuntu 12.04 (on travis-ci), R 3.2.4
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

## Spelling

I know folks double-check the automated output, but
the spelling - cURL - is what the cURL project folks
use and I'd like to keep it what way in the package
DESCRIPTION. 

I updated the examples and only added \dontrun{} blocks
around the bits that would retreive content from the internet
since that's just to show folks how to use the result of 
the functions and not part of the core functionaly
(it's really only testing httr's ability to retreive data).
