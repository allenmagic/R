####################################################################
## 项目名称: 读取文件夹下所有的权益变动表的数据
## 创建日期: 2023-12-21
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
folder_path <- "E:/Documents/r_project/data_source/portal/usd_fund_data/"

# 获取目录下所有excel文件的列表
file_list <- list.files(path = folder_path, pattern = "\\.xlsx$", full.names = TRUE)

# 定义函数：读取Excel文件并添加company_id列
read_and_label <- function(file_path) {
  
  # 读取数据
  data <- read_excel(file_path, col_names = TRUE) %>%
    mutate(file_name = basename(file_path))

  return(data)
  
}


combined_lp_fund <- map_dfr(file_list, read_and_label, .id = NULL)

View(combined_lp_fund)

