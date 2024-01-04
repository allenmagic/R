###########################################################################################
## Project: Check the data between eneity system and import excel file
## Create Date: 2023-12-05
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
###########################################################################################

# Load the libraries useful
library('tidyverse')
library('readr')
library('openxlsx')
library('tools')


# Load data from import excel file
account_bank_from_import_file <- read.xlsx('data_source/entity/entity_list_for_import.xlsx', sheet = 'account_bank')
account_broker_from_import_file <- read.xlsx('data_source/entity/entity_list_for_import.xlsx', sheet = 'account_broker')
master_company_from_import_file <- read.xlsx('data_source/entity/entity_list_for_import.xlsx', sheet = 'master_company')

# 定义转化日期的函数
convert_dates <- function(x) {
  ifelse(is.na(x), 
         NA, 
         ifelse(is.double(x), 
                as.Date(x, origin = "1899-12-30", "%Y-%m-%d"), 
                x))
}

# 转化日期
account_bank_from_import_file$account_opening_date <- sapply(account_bank_from_import_file$account_opening_date, convert_dates)
account_bank_from_import_file$account_closure_date <- sapply(account_bank_from_import_file$account_closure_date, convert_dates)
account_broker_from_import_file$account_opening_date <- sapply(account_broker_from_import_file$account_opening_date, convert_dates)
account_broker_from_import_file$account_closure_date <- sapply(account_broker_from_import_file$account_closure_date, convert_dates)


# 处理bank表格数据的字段名称，修改为和df_account_info字段名一致
account_info_excel <- rbind(
account_bank_from_import_file <- account_bank_from_import_file %>%
  rename(company_name_en = entity_name, category = categories, account_number = account_no)  %>%
  mutate(account_nature = toTitleCase(account_nature)),
account_broker_from_import_file <- account_broker_from_import_file %>%
  rename(company_name_en = entity_name, category = categories, account_number = account_no)  %>%
  mutate(account_nature = toTitleCase(account_nature))
) %>% mutate(across(where(is.character), trimws)) %>%
  rename(trading_system = system_administrator)


