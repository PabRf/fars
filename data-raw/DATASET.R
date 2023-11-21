# Create data objects from raw data
library(readr)
data2013 = read_csv("accident_2013.csv.bz2"); range(data2013$YEAR)
data2014 = read_csv("accident_2014.csv.bz2"); range(data2014$YEAR)
data2015 = read_csv("accident_2015.csv.bz2"); range(data2015$YEAR)

# Add internal data object(s): generated data files saved in data/ subdirectory
usethis::use_data(data2013, data2014, data2015, internal = T)

