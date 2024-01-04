####################################################################
## Project: Compare contacter for LPs
## File Name: compareContact
## Create Date: 2023-09-19
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
####################################################################

## Build database connection from expert_dbconn.R script file which include expert productivity database host
source('sql_scripts/conn/irs_dbconn.R')
library(tidyverse)
library(readr)


## Execute the sql query for all expert records including un-completed and completed
all_contact_query <- read_file('sql_scripts/query/crm/contact_query.sql')

all_contact <- dbSendQuery(
  irs_dbconn, 
  all_contact_query
)

df_all_contact <- fetch(all_contact,n = -1)


## import contact list from excel file
contact_from_file <- readxl::read_xlsx('data_source/irs/contact.xlsx',sheet = '联系人',)

## Close the database connection
dbDisconnect(irs_dbconn) 