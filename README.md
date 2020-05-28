# BESP Application Supplemental Materials


`agg_data.R` -  This script reads in data on inspections of childcare facilities in NYC, aggregates to the zip code level, and then merges inspection data with another dataset on zip code demographics to create a zip-level characteristics file.

The results of this script are used to generate several components in the accompanying dashboard including the map, trendline and value boxes.

`map.R` - This script loads the data produced in `agg_data.R`, merges to an NYC Zip shape file, and generates a map featuring pop-ups with important data points and a choropleth scaled by number of violations per zip code.

`trendline.R` - This script loads the data produced in `agg_data.R`, aggregates up to the city-level to provide violation counts across all zip codes, and generates the trendline which appears in the accompanying dashboard.

`inspection_dashboard.Rmd` - Yields the final product - an [inspection dashboard](https://sophiebellarand.shinyapps.io/inspection_dashboard/) using R Shiny and RMarkdown.

## Source files:
`Demographic_Statistics_By_Zip_Code.csv` - zip code demographics data from a small DYCD survey were retrieved from [NYC Open Data](https://data.cityofnewyork.us/City-Government/Demographic-Statistics-By-Zip-Code/kku6-nxdu)

`ZIP_CODE_040114`  - NYC Shape Files were retrieved from [NYC Open Data](https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u/data?no_mobile=true)

`DOHMH_Childcare_Center_Inspections.csv` - Childcare Center Inspection Data provided by DOHMH were retrieved from [NYC Open Data](https://data.cityofnewyork.us/Health/DOHMH-Childcare-Center-Inspections/dsg6-ifza/data)
