####################################################################
## 项目名称: 读取ROD-BVI文件
## 创建日期: 2023-12-15
## 程序作者: Zheng Youxin
####################################################################

# 加载必要的包
library(readxl)
library(purrr)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)


# 设置工作目录
folder_path <- "E:/Documents/r_project/data_source/entity/ROD_BVI/"

# 获取目录下所有excel文件的列表
file_list_bvi <- list.files(path = folder_path, pattern = "\\.xlsx$", full.names = TRUE)

# 定义函数：读取Excel文件并添加company_id列
read_and_label <- function(file_path) {
  
  # 读取company_name
  company_name <- read_excel(file_path, range = "A1:J1", col_names = FALSE) %>%
    select_if(~ !all(is.na(.))) %>%
    drop_na()
  
  company_name <- unique(company_name[[1]])
  
  
  # 从A2单元格开始读取数据直到表格的最后一个数据
  data <- read_excel(file_path, range = cell_limits(ul = c(2,1))) %>%
    mutate(company_name = company_name) %>%
    mutate(Region = 'BVI')
  
  # 将列名全部修改为大写的字母并去除空格和特殊符号只保留大写字母，减少不同列名的影响
  colnames(data) <- gsub(" ", "", colnames(data))
  colnames(data) <- toupper(colnames(data))
  colnames(data) <- gsub("[^A-Z]+", "", colnames(data))
  
  
  # 检查列名包含Date|date的列并将列的值类型转化为datetime类型的值
  date_col_name <- grep("Date|date", colnames(data), value = TRUE, ignore.case = TRUE, perl = TRUE)
  if (length(date_col_name) > 0) {
    for (i in 1:length(date_col_name)) {
      data[[date_col_name[i]]] <- as.Date(data[[date_col_name[i]]], "%Y-%m-%d")
    }
  }
  
  return(data)
  
}


# 使用purrr包的map_dfr函数应用函数并合并数据框
combined_df_bvi <- map_dfr(file_list_bvi, read_and_label, .id = NULL) %>%
  select_if(~ !all(is.na(.))) %>%
  fill(NAME,.direction = "down")



