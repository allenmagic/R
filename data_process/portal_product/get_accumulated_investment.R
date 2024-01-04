###########################################################################################
## Project: Get expert fee and compare the fee with vendor's record
## File Name: get expert(completed) fee from our product database
## Create Date: 2023-09-01
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
###########################################################################################

## Build database connection from expert_dbconn.R script file which include expert productivity database host
source('sql_scripts/conn/portal_product_dbconn.R')
library('tidyverse')
library('readr')
library('ggplot2')


## Execute the sql query for all expert records including un-completed and completed
get_fund_accumulated_investment <- read_file('sql_scripts/query/portal_product/fund_accmulated_investment.sql')
fund_accumulated_investment <- dbSendQuery(
  portal_product_dbconn, 
  get_fund_accumulated_investment
)


## Create data.frame and set scientific is FALSE
df_fund_accumulated_investment <- fetch(fund_accumulated_investment,n = -1) %>% format(scientific = FALSE)

## Close the database connection
dbDisconnect(portal_product_dbconn) 



## Create bar chart
g <- ggplot(df_fund_accumulated_investment,aes(df_fund_accumulated_investment$value_date,df_fund_accumulated_investment$total_investment)) + geom_bar(stat = "identity")
g



