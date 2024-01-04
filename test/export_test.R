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


# 1. 筛选出Fund和ValueDate列值相同的数据
specific_dates <- as.Date(c("2023-06-30", "2023-09-30"))
filtered_data <- lp_fund_info_table %>%
  filter(ValueDate %in% specific_dates) %>%
  group_by(Fund, ValueDate) %>%
  filter(n_distinct(Fund) == 1 & n_distinct(ValueDate) == 1)

# 创建一个列表来存储每个Fund_ValueDate的子数据框
result_list <- split(filtered_data, paste(filtered_data$Fund, filtered_data$ValueDate, sep = ""))

# 2. 将筛选出的数据导入到Excel表格
for (i in seq_along(result_list)) {
  data <- result_list[[i]]
  file_name <- paste(data$Fund[1], data$ValueDate[1], sep = "_")
  
  # 3. 同一个Excel表格里所有数据的Fund和ValueDate是相同的
  workbook <- createWorkbook(file_name)
  
  # 4. 除开Investor、Fund、ValueDate这三列，其他列的数据分别导出为千分位的数值，NA用NA显示
  columns_to_process <- colnames(data)[!(colnames(data) %in% c("Investor", "Fund", "ValueDate"))]
  processed_data <- data %>%
    dplyr::select(-c(Investor, Fund, ValueDate)) %>%
    mutate_all(~ifelse(is.na(.), "NA", round(., 3, digits = 3)))
  
  # 将处理后的数据合并到原始数据（包含Investor、Fund、ValueDate列）
  final_data <- cbind(data[, c("Investor", "Fund", "ValueDate")], processed_data)
  
  # 将数据写入Excel表格
  addWorksheet(workbook, sheetName = file_name)
  writeData(workbook, sheet = file_name, final_data)
}
closeWorkbook(workbook)