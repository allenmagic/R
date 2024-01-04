####################################################################
## 项目名称: 处理通过SQL查询的account信息
## 创建日期: 2023-12-13
## 程序作者: Zheng Youxin
####################################################################

source('data_process/entity/query_account_info.R')


# 创建payment_authorisation_manual关系
df_authorisation_arrangement_list <- df_authorisation_overview_info %>%
  #filter(overview_type == 'paper_form') %>%
  left_join(df_authorisation_arrangement_info, by = c("arrangement_id" = "id"))  %>%
  mutate(payment_arrangement = paste0(reference_code.x,"-",reference_code.y)) %>%
  select(c(id,overview_type,payment_arrangement))


# 对数据进行处理
df_account_info <- df_account_info %>%
  left_join(df_param_info %>% filter(param_type == 'bank_nature'), by = c("account_nature" = "param_seq")) %>%
  mutate(account_nature = param_drpt) %>%
  select(-c(id, parent_id, param_type, param_drpt)) %>%  ## 根据参数表查看更新bank和broker的code值
  left_join(df_param_info %>% filter(param_type == 'account_type'), by = c("account_type" = "id")) %>%
  mutate(account_type = param_drpt) %>%
  select(-c(parent_id, param_type, param_drpt, param_seq)) %>% ## 从参数表中取account_type的值内容
  mutate(cheque_book = case_when(
    cheque_book == 1 ~ "Y",
    cheque_book == 2 ~ "N",
    TRUE ~ as.character(NA)
  ))  %>% ## 修改cheque_book为对应的表述值
  left_join(df_authorisation_arrangement_list, by = c("payment_authorisation_manual_code" = "id"))  %>%
  left_join(df_authorisation_arrangement_list, by = c("payment_authorisation_online_code" = "id"), suffix = c("","_online"))  %>%
  left_join(df_authorisation_arrangement_list, by = c("trading_authorisation_code" = "id"), suffix = c("","_trading"))  %>%
  left_join(df_authorisation_arrangement_list, by = c("system_administrator_code" = "id"), suffix = c("","_system"))  %>%
  left_join(df_authorisation_arrangement_list, by = c("mandate_authorisation_code" = "id"), suffix = c("","_mandate"))

# 重命名部分字段
account_info_db <- df_account_info %>% 
  rename(payment_authorisation_manual = payment_arrangement, payment_authorisation_online = payment_arrangement_online, trading_authorisation = payment_arrangement_trading,system_administrator = payment_arrangement_system, mandate_authorisation = payment_arrangement_mandate, bank_swift = swift_code) %>%
  mutate(across(where(is.character), trimws))  %>%
  mutate(bank_swift = ifelse(bank_swift == "", NA, bank_swift))  %>%
  mutate(Remark = ifelse(Remark == "", NA, Remark))  %>%
  mutate(trading_system = case_when(
    !is.na(trading_authorisation) ~ trading_authorisation,
    !is.na(system_administrator) ~ system_administrator,
    TRUE ~ NA_character_
  ))



