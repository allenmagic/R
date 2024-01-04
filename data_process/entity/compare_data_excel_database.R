####################################################################
## 项目名称: 比较原始表格数据和数据库数据
## 创建日期: 2023-12-14
## 程序作者: Zheng Youxin
####################################################################

source('data_process/entity/tidy_account_data.R')
source('data_process/entity/entity_import_from_file.R')

#view(account_bank_from_import_file)
#view(account_broker_from_import_file)
#view(master_company_from_import_file)
#view(df_account_info)

# 定义需要对比的字段
feilds_list <- c("company_name_en", "account_name", "account_nature", "account_number", "bank_full_name", "bank_location", "bank_swift", "account_type", "cheque_book",  "payment_authorisation_manual", "payment_authorisation_online", "trading_system",   "mandate_authorisation", "Remark")

checklist <- c("account_name","account_nature","account_number","company_name_en")


# 为每个数据框添加一个新列，该列是所有其他列拼接而成的字符串
account_info_excel <- account_info_excel %>%
  select(all_of(checklist))  %>%
  rowwise() %>% 
  mutate(combined = paste0(c_across(everything()), collapse = "-")) %>%
  ungroup() %>%
  arrange(combined)

account_info_db <- account_info_db %>%
  select(all_of(checklist))  %>%
  rowwise() %>% 
  mutate(combined = paste0(c_across(everything()), collapse = "-")) %>%
  ungroup() %>%
  arrange(combined)

diff_db_not_in_excel <- anti_join(account_info_db, account_info_excel, by = "combined")
diff_excel_not_in_db <- anti_join(account_info_excel, account_info_db, by = "combined")

view(diff_db_not_in_excel %>% select(-c(combined)))
view(diff_excel_not_in_db %>% select(-c(combined)))


write_xlsx(diff_excel_not_in_db %>% select(-c(combined)),
           'export_document/entity/account_remark_fix_issue.xlsx',
           col_names = TRUE,
           format_headers = TRUE,
            )