
#' Read CSV file
#'
#' This function checks whether the CSV file exists. If the file exists, then it is read
#' and coerced into a tibble.
#'
#' @param filename The name of the file that the function will read and coerce into
#'    a tibble.
#'
#' @importFrom readr read_csv
#' @importFrom tibble as_tibble
#'
#' @return This function returns a tibble derived from the input CSV file.
#'    If the input CSV file does not, an error is generated.
#'
#' @note Examples: fars_read("data2013.csv"), fars_read("data2015.csv")
#'
#' @note If the file "data2050.csv"" does not exist, attempting to read this file
#'     will generate an error.
#' try(fars_read("data2050.csv"))
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  tibble::as_tibble(data)
}



#' Create file name
#'
#' This function takes an input year, converts it to an integer, and then into a
#' file name in the format: "accident_YYYY.csv.bz2", where YYYY represents the
#' input year.
#'
#' @param year The input year that will be converted into a file name.
#'
#' @return This function returns the file name in the format: "accident_YYYY.csv.bz2".
#'
#' @note Examples: make_filename(1900), make_filename(2000), make_filename(2050)
#'
#' @note If a non-year argument is entered as the value for the function parameter
#'     "year", an error will be generated.
#' try(make_filename(today))
#' try(make_filename(January))
#'
#' @export
make_filename = function(year){
  year = as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}




#' Check input vector "years"
#'
#' This function checks whether the input vector "years", contains elements that appear
#' in the output from make_filename() that produces file names in the format:
#' "accident_YYYY.csv.bz2", where YYYY represents the year.
#'
#' @param years A vector of years that will be checked against the make_filenames()
#'    output.
#'
#' @importFrom dplyr mutate select %>%
#'
#' @return This function returns a data frame with MONTH and year variables for each
#'    file with a valid year. If the year is not valid, then a warning is returned.
#'
#' @note Examples: fars_read_years(c(2013,2014)), fars_read_years(c(2013,2014,2015))
#'
#' @note If the file "accident_2050.csv.bz2" does not exist, attempting to check the input
#'     year for this file will generate an error.
#' try(fars_read_years(c(2013,2014,2050)))
#'
#' @export
fars_read_years = function(years){
  MONTH <- NULL
  lapply(years, function(year) {
    file = make_filename(year)
    tryCatch({
      dat = fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}




#' Summarize input files
#'
#' This function computes the number of observations per month and year for each
#' of the input files with format: "accident_YYYY.csv.bz2", where YYYY represents
#' the year.
#'
#' @param years A vector of years.
#'
#' @importFrom dplyr bind_rows group_by summarize %>%
#' @importFrom tidyr spread
#'
#' @return This function returns a tibble with the number of observations for each
#'    month and year for each of the input files with format: "accident_YYYY.csv.bz2",
#'    where YYYY represents the year.
#'
#' @note Examples: fars_summarize_years(c(2013,2014)), fars_summarize_years(c(2013,2014,2015))
#'
#' @note If the file "accident_2050.csv.bz2" does not exist, attempting to summarize
#'     the input from this file will generate an error. The corresponding column in
#'     the output tibble, will not be generated.
#' try(fars_summarize_years(c(2013,2014,2050)))
#'
#' @export
fars_summarize_years = function(years){
  year <- MONTH <- n <- NULL
  dat_list = fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}





#' Create map of accidents
#'
#' This function creates a map of accidents that occurred within a specified state
#' and during a specified year.
#'
#' @param state.num The state code of interest
#' @param year The year of interest
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @return This function returns a map of accidents that occurred within a specified
#'    state and during a specified year. If the state code is not valid, the code stops
#'    and an error is generated. If there are no accidents for the given year and month,
#'    a warning is produced.
#'
#' @note Examples: fars_map_state(12,2013), fars_map_state(1,2013)
#'
#' @note If the file "accident_2050.csv.bz2" does not exist, attempting to create a map
#'    from this file will generate an error.
#' try(fars_map_state(6,2050))
#'
#' @export
fars_map_state = function(state.num, year){
  filename = make_filename(year)
  data = fars_read(filename)
  state.num = as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub = dplyr::filter(data, data$STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) = data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) = data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}

