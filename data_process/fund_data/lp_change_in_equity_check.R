####################################################################
## 项目名称: 查询权益变动表数据并展示
## 创建日期: 2023-11-28
## 程序作者: Zheng Youxin
## 程序名称: lp_change_in_equity_check
####################################################################

# 连接irs数据库
source('sql_scripts/conn/irs_dbconn.R')
library(tidyverse)
library(writexl)
library(openxlsx)

## 执行查询SQL语句并创建查询对象
lp_fund_info_query <- read_file('sql_scripts/query/fund_data/lp_fund_info_query_usd.sql')
lp_fund_info_result <- dbSendQuery(
  irs_dbconn, 
  lp_fund_info_query
)


## 从查询对象中加载查询数据为dataframe
lp_fund_info_table <- fetch(lp_fund_info_result,n = -1)

## 关闭数据库链接
dbDisconnect(irs_dbconn) 

lp_fund_info_table <- lp_fund_info_table %>%
  rename(
    Investor = lp_name,
    Fund = fund_name,
    'ValueDate' = value_date,
    Commitment = commit_amount,
    'Unfunded Commitment' = unfunded_commit_amount,
    'LP Transfer In/Out' = lp_transfer_out,
    'Net Capital Contribution' = paid_amount,
    Distribution = distribution,
    'Return of Capital' = return_capital,
    'Carried Interest Paid' = carried_interest_paid,
    'Recallable Distribution' = recall_distribution,
    'Non-Recallable Distribution' = non_recall_distribution,
    'Management Fee' = mgmt_fee,
    'Other PnL' = other_pnl,
    'Dividend Income' = dividend,
    'Other Expenses' = other_fee,
    'Realized Gain/(Loss)' = realized_gain,
    'NAV (pre-carry)' = pre_nav,
    'Unrealized Carried Interest' = un_realized_carry,
    'NAV (post carry)' = post_nav,
    'Pre-funded Amount' = pre_funded_amount,
    'Capital Held in Reserve' = capital_held_in_reserve
  )


# 1. 筛选出 Fund 和 Value Date 列值同时出现次数超过一次的数据
specific_dates <- as.Date(c("2023-06-30", "2023-09-30"))
filtered_data <- lp_fund_info_table %>%
  filter(ValueDate %in% specific_dates) %>%
  group_by(Fund, ValueDate) %>%  # 注意这里改成了正确的列名 ValueDate
  filter(n() > 1) %>%
  ungroup()

# 指定目录路径
export_directory <- "/export_document/fund_data/usd_fund"

# 如果目录不存在，则创建它
if (!dir.exists(export_directory)) {
  dir.create(export_directory, recursive = TRUE)
}

# 删除先前导出的所有文件
previous_files <- list.files(path = export_directory, pattern = "\\.xlsx$", full.names = TRUE)
if (length(previous_files) > 0) {
  file.remove(previous_files)
}

# 获取唯一的Fund和Value Date组合
unique_combinations <- unique(filtered_data[, c("Fund", "ValueDate")])

for (i in seq_along(unique_combinations$Fund)) {
  # 提取当前组合的Fund和ValueDate
  current_fund <- unique_combinations$Fund[i]
  current_date <- unique_combinations$ValueDate[i]
  
  # 根据当前组合筛选数据
  df_to_write <- filtered_data %>%
    filter(Fund == current_fund & ValueDate == current_date)
  
  # 生成文件名（基于Fund和ValueDate）
  file_name <- paste0(current_fund, "-", format(as.Date(current_date), "%Y%m%d"), ".xlsx")
  full_file_path <- file.path(export_directory, file_name)
  
  # 创建一个新的Workbook对象
  wb <- createWorkbook()
  addWorksheet(wb, "Data")
  
  # 写入数据前，先创建一个样式用于千分位格式
  style <- createStyle(numFmt = "#,##0.00;-#,##0.00;\"NA\"")  # 千分位格式，并对NA进行处理
  
  # 针对所有数值列应用千分位样式
  cols_to_format_indices <- which(sapply(df_to_write, is.numeric))
  for (col_index in cols_to_format_indices) {
    addStyle(wb, "Data", style, rows = 2:(nrow(df_to_write) + 1), cols = col_index, gridExpand = TRUE)
  }
  
  # 将数据写入工作表
  writeData(wb, "Data", df_to_write)
  
  # 保存工作簿
  saveWorkbook(wb, full_file_path, overwrite = TRUE)
}