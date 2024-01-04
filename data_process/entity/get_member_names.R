####################################################################
## 项目名称: 处理提取Name信息
## 创建日期: 2023-12-15
## 程序作者: Zheng Youxin
####################################################################


# 加载openxlsx包
library(openxlsx)


# 加载数据预处理的文件
#setwd("E:/Documents/r_project/data_process/entity")
source('E:/Documents/r_project/data_process/entity/import_rod_from_file_bvi.R')
source('E:/Documents/r_project/data_process/entity/import_rod_from_file_Cayman.R')

View(members_list_cayman)
View(members_list_bvi)

members_list_bvi <- members_list_bvi %>%
  mutate(member_name = coalesce(NAME,Name,`NAME OF MEMBER`)) %>%
  select(c(member_name)) %>%
  distinct(member_name, .keep_all = TRUE)

members_list_cayman <- members_list_cayman %>%
  mutate(member_name = coalesce(NAME,Name)) %>%
  select(c(member_name))  %>%
  distinct(member_name, .keep_all = TRUE)

member_lis_all <- rbind(members_list_bvi, members_list_cayman) %>%
  distinct(member_name)

View(member_lis_all)

write.xlsx(member_lis_all,'E:/Documents/r_project/export_document/entity/member_list.xlsx',           
           col_names = TRUE,
           format_headers = TRUE
           )