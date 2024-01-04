###########################################################################################
## Project: Get expert fee and compare the fee with vendor's record
## File Name: get expert(completed) fee from our product database
## Create Date: 2023-09-01
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
###########################################################################################

## Build database connection from expert_dbconn.R script file which include expert productivity database host
source('sql_scripts/conn/investor_portal_dbconn.R')
library('tidyverse')
library('readr')


## Execute the sql query for all expert records including un-completed and completed
get_lp_fund_info <- read_file('sql_scripts/query/investor_portal/get_lp_fund_info.sql')
lp_fund_info <- dbSendQuery(
  portal_dbconn, 
  get_lp_fund_info
)

df_lp_fund_info <- fetch(lp_fund_info,n = -1)  %>% format(scientific = FALSE)



## Execute the sql query for all expert records including un-completed and completed
get_lp_investment_summary <- read_file('sql_scripts/query/portal_product/get_lp_investment_summary.sql')
lp_investment_summary <- dbSendQuery(
  portal_dbconn, 
  get_lp_investment_summary
)

df_lp_investment_summary <- fetch(lp_investment_summary,n = -1) %>% format(scientific = FALSE)


## Close the database connection
dbDisconnect(portal_dbconn) 