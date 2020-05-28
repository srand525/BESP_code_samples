##----------------------------------------------------------------
## Sophie Rand
## Supplement to application for Director of Childcare Analytics, BESP, Job ID: 433038
## May 28, 2020

## This script reads in data on inspections of childcare facilities in NYC, aggregates to the zip code level
## and then merges inspection data with another dataset on zip code demographics to create a zip-level 
## characteristics file. 

## The results of this script are used to generate several components in the accompanying dashboard including the
## map, trendlines and value boxes. 
##----------------------------------------------------------------

library(dplyr)

#1. Read in raw inspections data
#2. Clean and format inspection data
#3. Aggregate inspection data to look at violations by date and zipcode
#4. Create a childcare centers file with zipcode demographics and max capcity of the childcare center
#5. Merge the files to prepare for visualizations

#1. Read in raw data
raw_data <- read.csv("DOHMH_Childcare_Center_Inspections.csv",stringsAsFactors = F)

#2. Clean, format and filter raw data to only those inspections that turned up violations
raw_data_subset <- raw_data %>% 
  mutate(inspection_date = as.Date(Inspection.Date, format = "%m/%d/%Y") #Convert date col from character to date type var
         ,zip_code = as.character(ZipCode)) %>% 
  dplyr::rename(daycare_id = Day.Care.ID
                ,violation_cat = Violation.Category
                ,max_cap = Maximum.Capacity) %>% #Rename columns for ease of retrieval
  select(zip_code,daycare_id,inspection_date,violation_cat,max_cap) %>% #Select columns needed for analysis
  filter(!is.na(inspection_date) & !(violation_cat %in% c(""," ")) & !is.na(zip_code)) 
  #Filter out rows where inspection_date or zip_code are NA, or where there was no violation found

#3. Aggregate by inspection date to count number of violations and number of facilities by day
violations_by_zip <- raw_data_subset %>% 
  group_by(inspection_date,zip_code) %>% #Group by Date and Zip code, our units of analysis
  summarise(n_facilities = n_distinct(daycare_id) #Count number of facilities with a violation
            ,n_violations = n()) %>% 
  ungroup() %>% 
  select(inspection_date,zip_code,n_facilities,n_violations) %>% #Select columns with aggregate counts
  data.frame()


#4. Create a zipcode characteristics file with zipcode demographics and the total max capcity of the childcare centers
# in that zip

#Find the max of the maximum capacity per child care center, to catch any instances wehre there may be multiple values per facility 
center_demo_df <- raw_data_subset %>% 
  group_by(daycare_id,zip_code) %>% 
  summarise(capacity = max(max_cap)) %>% 
  ungroup() %>% 
  group_by(zip_code) %>% 
  summarise(tot_reach = sum(capacity,na.rm = T)) %>% #Sum capacity by zip code to get a proxy for reach by zipcode
  data.frame()


# Read in demographic statistics by zip and select columns of interest
demo_by_zip_df <- read.csv("Demographic_Statistics_By_Zip_Code.csv") %>% 
  mutate(zip_code = as.character(JURISDICTION.NAME)) %>% 
  dplyr::rename(pct_receives_assistance = PERCENT.RECEIVES.PUBLIC.ASSISTANCE
                ,n_surveyed = COUNT.PARTICIPANTS) %>% #update column names for easier readability
  select(zip_code,n_surveyed, pct_receives_assistance)

# Merge to create a zip code characteristics file

zip_char_df <- left_join(center_demo_df,demo_by_zip_df, by = "zip_code")

#5. Merge the files to prepare for visualizations

violations_by_zip_demo <<- left_join(violations_by_zip,zip_char_df, by = "zip_code")


