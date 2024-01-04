####################################################################
## 项目名称: 专家费用明细数据处理
## 创建日期: 2023-11-22
## 程序作者: Zheng Youxin
####################################################################

## 创建专家系统生产数据库链接并加载需要的包
library(tidyverse)
library(readr)
library(magrittr)
library(writexl)
library(lubridate)

# 从数据库获取项目名称和项目代码
source('sql_scripts/conn/expert_dbconn.R')

expert_project_code_name_query <- read_file('sql_scripts/query/expert/expert_project_code_name_query.sql')
expert_project_code_name <- dbSendQuery(
  expert_dbconn, 
  expert_project_code_name_query
)

df_expert_project_code_name <- fetch(expert_project_code_name,n = -1)

## 关闭数据库链接
dbDisconnect(expert_dbconn) 


# 从专家系统导出的明细费用表格读取数据
df_expert_fee_allocation_details <- read.xlsx('data_source/expert/allocation/expert_fee_allocation.xlsx',sheet = '费用分类') 

# 初步处理数据
df_expert_fee_allocation_details <- df_expert_fee_allocation_details %>%
  rename(year = 年份, month = 月份, fee_date = 费用日期, project_name = 项目名称, fund = 基金名称, dept = 部门名称, account = 科目名称, raw_value = 原始金额人民币, raw_value_usd = 原始金额美元, applicant = 申请人, fee_entity = 费用公司, remark = 备注, subject_type = 类型, data_source = 数据源, fee_type = 日报费用类型, fee_sub_type = 日报费用子类型, fee_to = 归属人, fee_dept = 归属部门, fee_classfication = 费用分类, amount_fee = 日报金额, creat_time = 创建时间, update_time = 更新时间) %>%  # 重命名为英文字段名称
  separate(col = remark, into = c('subject', 'vendor'), sep = "(?=-[^-]+$)", remove = TRUE)  %>%  # 将备注拆分为主体和供应商
  mutate(
    vendor = str_replace_all(vendor,"-",""),
    fee_date = as.Date(fee_date,origin = "1899-12-30"),
    creat_time = as.POSIXct(creat_time * (24*3600), origin = "1899-12-30", tz = "UTC"),
    update_time = as.POSIXct(update_time * (24*3600), origin = "1899-12-30", tz = "UTC"),
    amount_fee_usd = round(amount_fee/6.8, digits = 2)
    ) %>%
  left_join(df_expert_project_code_name, by = "project_name", suffix = c(".excel",".system")) %>%
  mutate(account = '66012204\\业务及管理费\\部门研究开发费\\部门专家访谈')  

# 提取高管信息
df_expert_director <- df_expert_fee_allocation_details %>%
  filter(fee_classfication == '高管费用') %>%
  select(project_name,fee_to) %>%
  distinct() %>%
  arrange(project_name) %>%
  group_by(project_name) %>%
  summarize(fee_director = toString(unique(fee_to)), .groups = 'drop')

view(df_expert_d_fee)

# 创建高管列并取出高管字段的内容值
df_expert_fee_allocation_excel <- df_expert_fee_allocation_details %>%
  filter(fee_date >= '2023-07-01',fee_classfication != '高管费用') %>%
  left_join(df_expert_director, by = "project_name") %>%
  arrange(project_name,desc(fee_date),applicant)
  
  # mutate(project_name = str_replace(project_name, "\\(.*?\\)$", "")  %>%
  #          filter(fee_date >= '2023-07-01',fee_classfication != '高管费用') %>%
  #          select(all_of(export_feilds_to_excel)) %>%
  #          arrange(project_name,desc(fee_date),applicant)


# 指定导出字段和顺序
export_feilds_to_excel <- c('year','month','fee_date','project_code','project_name','fund','account','fee_to','amount_fee_usd','applicant','vendor','fee_director')



view(df_expert_fee_allocation_excel %>%
       mutate(project_name = str_replace(project_name, "\\(.*?\\)$", ""))  %>%
       filter(fee_date >= '2023-07-01') %>%
       select(all_of(export_feilds_to_excel)))

write_xlsx(df_expert_fee_allocation_excel %>%
            mutate(project_name = str_replace(project_name, "\\(.*?\\)$", ""))  %>%
            filter(fee_date >= '2023-07-01') %>%
            select(all_of(export_feilds_to_excel)),
           'export_document/expert/expert_fee_allocation.xlsx',
           col_names = TRUE,
           format_headers = TRUE,
)

  