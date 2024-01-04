####################################################################
## 项目名称: 查询专家访谈费用明细数据
## 创建日期: 2023-08-28
## 程序作者: Zheng Youxin
####################################################################

## 创建专家系统生产数据库链接并加载需要的包
source('sql_scripts/conn/expert_dbconn.R')
library(tidyverse)
library(readr)
library(magrittr)
library(writexl)
library(lubridate)
library(openxlsx)


## 执行查询SQL语句并创建查询对象
get_all_expert_records_with_status <- read_file('sql_scripts/query/expert/expert_query_all_detail.sql')
expert_all_records <- dbSendQuery(
  expert_dbconn, 
  get_all_expert_records_with_status
)


## 从查询对象中加载查询数据为dataframe
df_expert_all_records <- fetch(expert_all_records,n = -1)

## 关闭数据库链接
dbDisconnect(expert_dbconn) 

## 如果是项目费用则删除项目代号, 正则表达为 "\\(.*\\)$" 
df_expert_all_records %<>% 
  mutate(project_name = if_else(
    fee_type == "项目费用",  # 1. 如果是项目费用，则删除项目名称中的项目代号（括号及内容）
    str_replace(project_name, "\\(.*?\\)$", ""), # 使用非贪婪匹配删除最后一个括号及其内容
    project_name # 如果不是项目费用，保持原样
  ),
  interview_subject = str_replace_all(interview_subject, "\\r\\n|\\r|\\n", " "), # 2. 删除访谈主题字段值的换行符
  expert_intro = str_replace_all(expert_intro, "\\r\\n|\\r|\\n", " "),  # 3. 删除专家介绍字段值的换行符
  meeting_year=year(meeting_time),  # 4. 新增meeting_year字段
  meeting_quarter=paste0('Q',quarter(meeting_time)) # 5. 新增meeting_quarter字段
  ) %>%
  as_tibble()

## 新建筛选查看的字段参数
vendor_check_fileds <- c('cpe_interview_id','task_id_external','expert_vendor','interview_subject','applicant','department','meeting_time','meeting_year','meeting_quarter','fee','duration','fee_type','summary_status','team')


# 筛选出 expert_vendor 和 meeting_quarter 列值同时出现次数超过一次的数据
export_year <- as.numeric(c("2023"))
export_quarter <- c("Q3")
filtered_data <- df_expert_all_records %>%
  filter(meeting_year %in% export_year ,meeting_quarter %in% export_quarter) %>%
  group_by(expert_vendor, meeting_quarter) %>%  # 注意这里改成了正确的列名 ValueDate
  filter(n() > 1) %>%
  ungroup()

# 设置导出文件mulu 
export_directory <- paste0(getwd(),"/export_document/expert/")

# 如果目录不存在，则创建它
if (!dir.exists(export_directory)) {
  dir.create(export_directory, recursive = TRUE)
}

# 删除先前导出的所有文件
previous_files <- list.files(path = export_directory, pattern = "\\.xlsx$", full.names = TRUE)
if (length(previous_files) > 0) {
  file.remove(previous_files)
}


# 获取唯一的vendor和quarter组合
unique_combinations <- unique(filtered_data[, c("expert_vendor", "meeting_quarter")])

for (i in seq_along(unique_combinations$expert_vendor)) {
  # 提取当前组合的vendor和quarter组合
  current_vendor <- unique_combinations$expert_vendor[i]
  current_quarter <- unique_combinations$meeting_quarter[i]
  
  # 根据当前组合筛选数据
  df_to_write <- filtered_data %>%
    filter(expert_vendor == current_vendor & meeting_quarter == current_quarter)
  
  # 生成文件名（基于Fund和ValueDate）
  file_name <- paste0(current_vendor, "-", current_quarter, ".xlsx")
  full_file_path <- file.path(export_directory, file_name)
  
  # 创建一个新的Workbook对象
  wb <- createWorkbook()
  addWorksheet(wb, "records")
  
  # # 写入数据前，先创建一个样式用于千分位格式
  # style <- createStyle(numFmt = "#,##0.00;-#,##0.00;\"NA\"")  # 千分位格式，并对NA进行处理
  # 
  # # 针对所有数值列应用千分位样式
  # cols_to_format_indices <- which(sapply(df_to_write, is.numeric))
  # for (col_index in cols_to_format_indices) {
  #   addStyle(wb, "Data", style, rows = 2:(nrow(df_to_write) + 1), cols = col_index, gridExpand = TRUE)
  # }
  # 
  # 将数据写入工作表
  writeData(wb, "records", df_to_write)
  
  # 保存工作簿
  saveWorkbook(wb, full_file_path, overwrite = TRUE)
}

# ## 导出数据
#  write.table(df_expert_all_records %>% filter(meeting_quarter == "Q3" | task_id_external %in% c("014017695", "016572177", "014488378")), #筛选Q3的数据，且剔除二级访谈
#              file = 'export_document/expert/expert_fee_list_internal.csv',
#              sep = ",", 
#              fileEncoding = 'UTF-8', 
#              na = "NA", 
#              row.names = FALSE, 
#              col.names = TRUE)
#  
#  
#  write.table(df_expert_all_records %>% select(all_of(vendor_check_fileds)) %>% filter(meeting_quarter == "Q3" | task_id_external %in% c("014017695", "016572177", "014488378")),
#              file = 'export_document/expert/expert_fee_list_for_vendor_check.csv',
#              sep = ",", 
#              fileEncoding = 'UTF-8', 
#              na = "NA", 
#              row.names = FALSE, 
#              col.names = TRUE)
#  

view(df_expert_all_records %>% filter(task_id_external %in% c("014017695", "016572177", "014488378")) %>% summarise(sum_value = sum(fee,na.rm=TRUE)))
