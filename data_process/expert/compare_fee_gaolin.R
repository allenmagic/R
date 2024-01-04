####################################################################
## 项目名称: 查询专家访谈费用明细数据
## 创建日期: 2023-08-28
## 程序作者: Zheng Youxin
####################################################################

## 创建专家系统生产数据库链接并加载需要的包
source('data_process/expert/get_expert_records.R')



## 导入高临的usage report数据并处理
fee_detail_from_gaolin <- read.xlsx('data_source/expert/vendor/gaolin.xlsx',sheet = 'Package Consumption') 

fee_detail_from_gaolin <- fee_detail_from_gaolin %>%
  as_tibble() %>% # 1. 将数据框转换为tibble
  rename(
    task_id = Task.ID,          # 2. 重命名列Task.ID为task_id
    meeting_date = Event.Date,  # 2. 重命名列Event.Date为meeting_date
    fee = Fee,                  # 2. 重命名列Fee为fee
    cpe_interview_id = Client.Code   # 2. 重命名列Client.Code为cpe_interview_id
  ) %>%
  mutate(
    task_id = as.numeric(task_id),           # 3. 将task_id列转换为数值型
    fee = round(as.numeric(fee), 2),         # 4. 将fee列转换为数值型并保留两位小数
    meeting_date = as.Date(meeting_date, origin = "1899-12-30")  # 同时转换meeting_date列为年月日格式
  ) %>%
  rename_with(~ paste0(., "_From_ThirdBridge"), everything()) # 添加字段后缀
  


# 以下是管道处理脚本程序
df_fee_gaolin_from_expert <- df_expert_all_records %>% 
  select(all_of(vendor_check_fileds)) %>%  # 根据check需要的字段
  rename(task_id = task_id_external) %>% # 重命名task_id_external为task_id
  filter(expert_vendor == "高临") %>% # 筛选vendor为高临
  filter(meeting_quarter == "Q3" | task_id %in% c("014017695", "016572177", "014488378")) %>%  #筛选第三季度和三个特殊访谈
  mutate(
    task_id = as.numeric(sub("^0+", "", task_id)), # 删除task_id首位的0并转换为数值型
    meeting_date = as.Date(meeting_time), # 转换meeting_time为日期型，并添加到新列meeting_date
    fee = round(as.numeric(fee), 2) # 将fee转换为数值型，保留两位小数
  ) %>%
  rename_with(~ paste0(., "_From_CPE"), everything()) # 添加字段后缀



## 合并数据框fee_detail_from_gaolin和df_fee_gaolin_from_expert,合并按照taskid进行关联处理，并对相同命名字段加上对应的后缀
df_fee_combined <- full_join(fee_detail_from_gaolin,df_fee_gaolin_from_expert, by = c( 'task_id_From_ThirdBridge' = 'task_id_From_CPE')) %>%
  mutate(fee_diff = fee_From_ThirdBridge - fee_From_CPE)

## 筛选的字段
cpe_feilds_to_export <- c('cpe_interview_id_From_CPE','applicant_From_CPE','meeting_time_From_CPE','fee_From_CPE','duration_From_CPE','fee_diff')


view(df_fee_combined)


write_xlsx(df_fee_combined %>%
          select(matches("From_ThirdBridge"), all_of(cpe_feilds_to_export)),
           'export_document/expert/fee_check_detail.xlsx',
           col_names = TRUE,
           format_headers = TRUE,
)
