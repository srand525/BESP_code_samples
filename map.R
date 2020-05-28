##----------------------------------------------------------------
## Sophie Rand
## Supplement to application for Director of Childcare Analytics, BESP, Job ID: 433038
## May 28, 2020

## This script loads the data produced in agg_data.R, merges to an NYC Zip shape file, and generates
## a map featuring pop-ups with important data points and a choropleth scaled by number of violations per zip code.
##----------------------------------------------------------------


library(leaflet)
library(scales)
library(rgdal)
source("agg_data.R")

#1. Read in NYC Shape file
#2. Project shape file to prepare for mapping
#3. Create function to generate the inspectional data for a given day merged with the shape file
#4. Create function to generate popup for the map
#5. Create function to create color ramp for choropleth - based on # violations
#6. Create function to create the map

#1. Read in NYC Shape file
shape_path <- "ZIP_CODE_040114"
nyc_zip_shp <- readOGR(dsn=shape_path,verbose = F)

#2. Project shape file to prepare for mapping
nyc_zip_file <<- spTransform(nyc_zip_shp, CRS("+proj=longlat +datum=WGS84"))
  
#3. Create function to generate the inspectional data for a given day merged with the shape file
gen_shape_files <<- function(input_date){
  
  violations_by_zip_demo_date <- violations_by_zip_demo %>% filter(inspection_date == input_date)
  
  violations_demo_shape_date <- merge(nyc_zip_file,violations_by_zip_demo_date,by.x = "ZIPCODE", by.y = "zip_code")  
  
  return(violations_demo_shape_date)
}

#4. Create function to generate popup for the map
gen_popup <<- function(violations_demo_shape_date){
  map_popup <- sprintf("ZIP Code: %s 
                    <br/> # Violations: %s 
                       <br/> # Childcare Centers w Violations: %s 
                       <br/><strong>Demographics in Zip (source: DYCD) </strong>
                       <br/> # Surveyed in Zip: %s
                       <br/> pct. surveyed receiving public assistance: %s"
                       ,violations_demo_shape_date$ZIPCODE
                       ,violations_demo_shape_date$n_violations
                       ,violations_demo_shape_date$n_facilities
                       ,violations_demo_shape_date$n_surveyed
                       ,violations_demo_shape_date$pct_receives_assistance
                       # ,scales::percent(violations_demo_shape_date$pct_receives_assistance,na.rm)
                       ) %>%
    lapply(htmltools::HTML)
  
  return(map_popup)
}


#5. Create function to create color ramp for choropleth - based on # violations
gen_color_ramp <<-function(violations_demo_shape_date){
  map_color_ramp <- leaflet::colorNumeric(
    palette = "plasma",
    domain = violations_demo_shape_date$violation_count, na.color = "transparent")
  return(map_color_ramp)
}

#6. Create function to create the map
gen_map <<- function(shape_file,color_ramp,pop_up){
  map <- leaflet(shape_file) %>% 
    addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
    setView(lng=-73.958925,lat=40.695857,zoom=11) %>%
    addPolygons(fillColor=~color_ramp(n_violations),label= pop_up,fill = T,stroke = F,opacity = 0.8) %>% 
    addLegend("bottomright", pal = color_ramp,values = ~shape_file$n_violations
              , title = "Violations by Zip",
              labFormat = labelFormat(suffix= " Violations"),
              opacity = 1)

return(map)
}
# nyc_zip_file <- read_files()
input_date <- as.Date("2018-07-28")
shape_test <- gen_shape_files(input_date)
popup_test <- gen_popup(shape_test)
colorramp_test <- gen_color_ramp(shape_test)
# # 
map <- gen_map(shape_file = shape_test,color_ramp = colorramp_test,pop_up = popup_test)


shape_test$pct_receives_assistance
# shape_test
# 
# ######
# nyc_zip_file=nyc_zip_file[order(nyc_zip_file$ZIPCODE),]
# 
# # Using data generated in gen_data.R, filter to today's data
# violations_by_zip_demo_today <- violations_by_zip_demo[violations_by_zip_demo$violation_date == Sys.Date(),]
# 
# # Merge violations and demographics to shape file (using base R's merge)
# violations_demo_today_shape <- merge(nyc_zip_file,violations_by_zip_demo_today,by.x = "ZIPCODE", by.y = "zip_code")
# 
# # <br/>Num Individuals surveyed: %s
# # Create HTML pop-up for map
# map_popup <- sprintf("ZIP Code: %s 
#                   <br/> # Violations: %s 
#                   <br/> # Childcare Centers w Violations: %s 
#                     <br/><strong>Demographics in Zip (source: DYCD) </strong>
#                     <br/> # Surveyed in Zip: %s
#                     <br/> pct. surveyed receiving public assistance: %s"
#                      ,violations_demo_today_shape$ZIPCODE
#                      ,violations_demo_today_shape$violation_count
#                      ,violations_demo_today_shape$n_total
#                      ,violations_demo_today_shape$n_total
#                      ,scales::percent(violations_demo_today_shape$pct_receives_assistance
#                       )) %>%
#   lapply(htmltools::HTML)
# 
# # Create color ramp for choropleth - based on # violations
# map_color_ramp <- leaflet::colorNumeric(
#   palette = "plasma",
#   domain = violations_demo_today_shape$violation_count, na.color = "transparent")
# 
# map <- leaflet(violations_demo_today_shape) %>% 
#   addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
#   setView(lng=-73.958925,lat=40.695857,zoom=11) %>%
#   addPolygons(fillColor=~map_color_ramp(violation_count),label= map_popup,fill = T,stroke = F,opacity = 0.8) %>% 
#   addLegend("bottomright", pal = map_color_ramp,values = ~violations_demo_today_shape$violation_count
#             , title = "Violations by Zip",
#             labFormat = labelFormat(suffix= " Violations"),
#             opacity = 1)
