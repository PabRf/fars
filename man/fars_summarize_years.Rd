% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_summarize_years}
\alias{fars_summarize_years}
\title{Summarize input files}
\usage{
fars_summarize_years(years)
}
\arguments{
\item{years}{A vector of years.}
}
\value{
This function returns a tibble with the number of observations for each
month and year for each of the input files with format: "accident_YYYY.csv.bz2",
where YYYY represents the year.
}
\description{
This function computes the number of observations per month and year for each
of the input files with format: "accident_YYYY.csv.bz2", where YYYY represents
the year.
}
\note{
Examples: fars_summarize_years(c(2013,2014)), fars_summarize_years(c(2013,2014,2015))

If the file "accident_2050.csv.bz2" does not exist, attempting to summarize
the input from this file will generate an error. The corresponding column in
the output tibble, will not be generated.
try(fars_summarize_years(c(2013,2014,2050)))
}
