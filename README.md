
# fars

<!-- badges: start -->
[![R-CMD-check](https://github.com/PabRf/fars/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PabRf/fars/actions/workflows/R-CMD-check.yaml)
[![Build Status](https://app.travis-ci.com/PabRf/fars.svg?branch=main)](https://app.travis-ci.com/PabRf/fars)
<!-- badges: end -->

The goal of farsFunctions is to provide a group of functions that extract state- and year-based data, verifies 
            the year of the input file(s), as well as summarizes and creates maps of the input file data.

## Installation

You can install the development version of farsFunctions like so:

``` r
install.packages("devtools")
install.packages("PabRf/fars")
```

## Example

These are basic examples which shows you how to use the functions:

``` r
library(fars)
fars_read("accident_2013.csv.bz2")
make_filename(2013)
fars_read_years(c(2013,2014,2015))
fars_summarize_years(c(2013,2014,2015))
fars_map_state(12,2013)

```

