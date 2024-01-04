####################################################################
## 项目名称: 读取ROD文件
## 创建日期: 2023-12-15
## 程序作者: Zheng Youxin
####################################################################

# 加载必要的包
library(readxl)
library(purrr)
library(dplyr)


# 设置工作目录
setwd("E:/Documents/r_project/data_source/entity/ROD_BVI")

# 获取目录下所有excel文件的列表
excel_files_bvi <- list.files(pattern = "\\.xlsx$", full.names = TRUE)

# 使用purrr包的map_df函数读取所有文件并合并在一个数据框
all_data_bvi <- map_df(excel_files_bvi, ~ read_excel(.x, range = cell_limits(c(2,1),c(50,1))))

members_list_bvi <- all_data[rowSums(is.na(all_data)) < 3, ]  %>%
  distinct(Name, .keep_all = TRUE)

View(members_list_bvi)
  