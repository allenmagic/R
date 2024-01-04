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


# 设置工作目录
folder_path <- "~/Projects/r_project/data_source/entity/ROD_BVI/CPE Investment XI Limited_20211215_ROD.xlsx"

# 获取目录下所有excel文件的列表
file_list_bvi <- list.files(path = folder_path, pattern = "\\.xlsx$", full.names = TRUE)

# 定义函数：读取Excel文件并添加company_id列
read_company_name <- function(file_path) {
  
  # 读取Company Name
  company_name <- read_excel(file_path, range = "A1:J1", col_names = FALSE) %>%
    select_if(~ !all(is.na(.))) 
  #company_name <- company_name[[1]] %>% as.character()
  
  return(company_name)
}

# 使用purrr包的map_dfr函数应用函数并合并数据框
company_list <- map_dfr(file_list_bvi, read_company_name, .id = NULL)

company_legal <- read_excel(folder_path, range = "A1:J1", col_names = FALSE)
company_legal <- company_legal %>%
  select_if(~ !all(is.na(.))) %>%
company_legal[[1]]


