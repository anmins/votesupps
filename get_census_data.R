####~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Collect Data from Census API
## 
## Notes
## From Chris's email:
## a map (likely using amcharts jquery mapping tool) that lists top employment
## sectors for each jurisdiction. Each state and each county would have its own
## dedicated page that listed the top employment sectors in the jurisdiction. 
## The Census Bureau compiles this data every 5 years:
## http://www.census.gov/econ/susb/index.html
## 
## API key: fb9a5df29c5d7510df67ef32fe7f311f9a0eb1dc
##
## SUSB MSA codes: http://www2.census.gov/econ/susb/data/msa_codes_2007_to_2011.txt
## State, county, NAICS data: http://www.census.gov/econ/susb/data/susb2011.html
##
## Creator: Eric Stone (ericstone@me.com) 
####~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#download ACS data by county

#package tutorial
#http://dusp.mit.edu/sites/dusp.mit.edu/files/attachments/publications/working_with_acs_R_v_2.0.pdf



#what is available?
# 5 year estimates: 5 year periods ending in the years 2009-2016
# 3 and 1 year ACS also available but not for such a wide timeframe
# several of the every 10 years census data available

library(acs)
library(data.table)

#only do this once:
#api.key.install(key="fb9a5df29c5d7510df67ef32fe7f311f9a0eb1dc")

#create a geo.set using the geo.make() function:
#use acs.lookup() to explore potential variables
#acs.fetch() to get the data
#extract the data from the asc.fetch() result with: 
#estimate(), standard.error() or confint()

#helpful tables:
#sex by age  "B01001"
#foreign born   "B05006"
#race "B02008"
#poverty by race - separate table for each group
#"B17020A" (white) 
#"B17020B" AfrAm
#"B17020C" NativeAM
#"B17020D" Asian
#"B17020E" Haw/PI
#"B17020F" Other
#"B17020G" Two+
#"B17020H" WhiteNotHisp
#"B17020I" Hisp/Latino  


#more tables:
#https://censusreporter.org/topics/table-codes/

#table numbering explained
#https://www.census.gov/programs-surveys/acs/guidance/which-data-tool/table-ids-explained.html

#get the variable names for matching:
sex.by.age.var.names <- acs.lookup(endyear = 2015, span = 5, table.number = "B01001")
foreign.born.var.names <- acs.lookup(endyear = 2015, span = 5, table.number = "B05006")
poverty.by.race.white <- acs.lookup(endyear = 2015, span = 5, table.number = "B17020A")

acs.lookup(endyear = 2015, span = 5, table.number = "B02002")

#try all states for 2015 (can't get 2016 to work it should be available since 12/7/17)
all.cntys  <- geo.make(state = state.abb, county = "*")
sex.by.age <- acs.fetch(geo = all.cntys, endyear = 2015, table.number="B01001")
#^takes some time to fetch

sex.by.age.est <- estimate(sex.by.age)
sex.by.age.dt <- data.table(estimate(sex.by.age))
sex.by.age.dt[, county_name := row.names(sex.by.age.est)]

sex.by.age.dt <- melt(sex.by.age.dt, id.vars = "county_name")

foreign.born <- acs.fetch(geo = all.cntys, endyear=2015, table.number="B05006")



