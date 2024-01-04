####################################################################
## 项目名称: 读取各个基金以及其投资人文档名称
## 创建日期: 2023-12-15
## 程序作者: Zheng Youxin
####################################################################

# 加载必要的包
library(readxl)
library(purrr)
library(dplyr)


# 设置文件路径
file_path <- "E:/Documents/r_project/data_source/portal/fund_investor_folder_name.xlsx"

# 读取文件
investor_folder_name <- read_excel(file_path, range = cell_limits(ul = c(1,1)), col_names = TRUE)


# 从数据库读取LP投资基金和其实体名称
source('sql_scripts/conn/portal_product_dbconn.R')
library('tidyverse')
library('readr')


## 执行查询程序
get_lp_fund_info <- read_file('sql_scripts/query/portal_product/query_lp_fund_info.sql')
lp_fund_info <- dbSendQuery(
  portal_product_dbconn, 
  get_lp_fund_info
)

df_lp_fund_info <- fetch(lp_fund_info,n = -1) %>% format(scientific = FALSE)

## 关闭数据库
dbDisconnect(portal_product_dbconn) 

View(investor_folder_name)
View(df_lp_fund_info)

# 使用 merge() 函数来合并两个数据框
merged_data <- merge(investor_folder_name, df_lp_fund_info, by = "fund_name", all.x = TRUE)

# 筛选出那些 investor_folder_name 和 lp_name 一致的记录
result <- anti_join(investor_folder_name, df_lp_fund_info, by = c("fund_name", "investor_folder_name" = "lp_name"))
View(result)




