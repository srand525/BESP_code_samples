##----------------------------------------------------------------
## Sophie Rand
## Supplement to application for Director of Childcare Analytics, BESP, Job ID: 433038
## May 28, 2020

## This script loads the data produced in agg_data.R, aggregates up to the city-level
## to provide violation counts across all zip codes, and generates the trendline which appears
## in the accompanying dashboard. 
##----------------------------------------------------------------


library(highcharter)
library(dplyr)
source("agg_data.R",local = F)

citywide_violations <- violations_by_zip_demo %>% 
  group_by(inspection_date) %>% 
  summarise(tot_violations = sum(n_violations)
            ,tot_facilities = sum(n_facilities)) %>% 
  ungroup() %>% 
  data.frame()

hc_trendline <<- highchart(type="stock") %>%
  hc_title(text="Violations in Childcare Centers, Citywide",align="left") %>%
  hc_xAxis(type = "datetime", labels = list(format = '{value:%m/%d}'),title = list(text = "Inspection Date")) %>%
  hc_yAxis_multiples(list(title=list(text="# Violations")
                          ,align="left",top="0%",height="70%",opposite=F,labels=list(format="{value}"))
                     ,list(title=list(text="# Facilities in Violation"),align="right",top="71%",height="29%",opposite=T)) %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_tooltip(valueDecimals=0, crosshairs=TRUE, shared=TRUE) %>%
  hc_add_series(citywide_violations,name = "# Violations",type="line",hcaes(x=inspection_date,y=tot_violations)) %>%
  hc_add_series(citywide_violations,name = "# Facilities",type="line",hcaes(x=inspection_date,y=tot_facilities),yAxis=1) %>%
  hc_rangeSelector(buttons = list(
    list(type='month', text='1m', count=1),
    list(type='week', text='3w', count=3),
    list(type='week', text='2w', count=2),
    list(type='week', text='1w', count=1)))
  
