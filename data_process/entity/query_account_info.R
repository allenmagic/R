####################################################################
## 项目名称: 查询实体账户信息
## 创建日期: 2023-12-13
## 程序作者: Zheng Youxin
####################################################################

## 创建数据库链接并加载需要的包
source('sql_scripts/conn/entity_dbconn.R')
library(tidyverse)
library(readr)
library(magrittr)
library(writexl)
library(lubridate)
library(openxlsx)


## 执行查询SQL语句并创建查询对象

get_param_info <- read_file('sql_scripts/query/entity/get_parma_info.sql')
param_info_query <- dbSendQuery(
  entity_dbconn,
  get_param_info
)

df_param_info <- fetch(param_info_query, n = -1)

# 查询account数据
get_account_info <- read_file('sql_scripts/query/entity/get_account_data.sql')
account_info_query <- dbSendQuery(
  entity_dbconn, 
  get_account_info
)

df_account_info <- fetch(account_info_query, n = -1)

# 查询authorisation arrangement信息
get_authorisation_arrangement_info <- read_file('sql_scripts/query/entity/get_authorisation_arrangement.sql')
authorisation_arrangement_info_query <- dbSendQuery(
  entity_dbconn,
  get_authorisation_arrangement_info
)

df_authorisation_arrangement_info <- fetch(authorisation_arrangement_info_query, n = -1)


# 查询authorisation overview信息
get_authorisation_overview_info <- read_file('sql_scripts/query/entity/get_authorisation_overview.sql')
authorisation_overview_info_query <- dbSendQuery(
  entity_dbconn,
  get_authorisation_overview_info
)

df_authorisation_overview_info <- fetch(authorisation_overview_info_query, n = -1)


## 关闭数据库链接
dbDisconnect(entity_dbconn) 

