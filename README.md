# BESP_application

my initial thought was to share some of the work I'd told you about during our call, e.g. the ASHR dashboard,  or cauris dashboard, or satscan analysis of ashr. howver none of those tools ever went though an export process so i cant share (but if you're on any of the syndromic mailing lists, I may have contributed to those items).

Instead, I figured this could be my first opportunity to learn a bit more about your data beyond what we discussed, so i used the childcare violations data found on nyc open data. here, i focus only on counts of violations over time. any number of the scripts that yields this dashboard can be considered 'scripts for analysis'. This one might be a good example.

i learned about the different types of idenifiers, eg name, ids, geoids, etc

To see the final end product, take a look here:
shiny link
### Highlights
- retrieves data; and generates fake data
- relational data frames are merged to produce daily counts of violations
- relational data frames are joined spatially, to create a map showing daily violation statistics overlayed with demographic characteristics of a zip code
- creating of a dashboard using R (flexdashboard and Rmarkdown)
- interactivity of the dashboard with Shiny
- a GIS component in the dashboard  
- rapid prototype of a dashboard


This dashbaord reports on violations over time.

Limitations:
- does not report on remediation of violations, though that is available in the data
- rolls up violations to the month

additional metrics that wed like to add would include
- drilling down to specific child care centers to view violations over time
- overlaying such information on a map with more pertinent information, e.g, actual attendance of students, perhaps clinical information demographics on the zip
- show remeidation of violations
- text analysis on the free text fields in the inspection  reports

make sure to include a report out on the potential of the data - take a closer look at the other variables

e.g if there were a program geared toward inspection of childcare facilities in underserved or impovershied neighborhoods,

sophie -- be very explicit about the use case for this!!

- there is a great opportunity to track the performance of a particular location over time and provide targeted support to frequent offenders
- this can be extended to multiple other use cases
case management - for the inspectors
program tracking - drilling down to specific facilities or regions
change the time input to a date range

### Source files:
demographics data from

https://data.cityofnewyork.us/City-Government/Demographic-Statistics-By-Zip-Code/kku6-nxdu

NYC Shape File https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u/data?no_mobile=true

childcare data downloaded from

https://data.cityofnewyork.us/Health/DOHMH-Childcare-Center-Inspections/dsg6-ifza/data


### To Do
a major accuracy check.
add warning about estimates for the demographics
