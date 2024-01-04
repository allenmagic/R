####################################################################
## 项目名称: 读取member的First Name和Last Name信息
## 创建日期: 2023-12-15
## 程序作者: Zheng Youxin
####################################################################

# 加载必要的包
library(readxl)
library(purrr)
library(dplyr)

source('data_process/entity/import_rod_from_file_bvi.R')
source('data_process/entity/import_rod_from_file_Cayman.R')

# 合并bvi和cayman的数据
data_rod <- rbind(combined_df_bvi, combined_df_cayman)

# 设置文件路径
file_path <- "~/Projects/r_project/data_source/entity/member_list.xlsx"

# 读取member的姓名信息
member_list <- read_excel(file_path, col_names = TRUE) 
member_list$NAME <- str_trim(member_list$NAME)
data_rod$NAME <- str_trim(data_rod$NAME )


order_list <- c("Name","First_Name","Last_Name","Former_Name","Date_of_Birth","Place_of_Birth","Nationality","Service_Address","Residential_Address","Entity","Role","Appointment_Date","Resignation_Date1","Address","Resignation_Date2")


data_rod_all <- data_rod %>%
  left_join(member_list, by = 'NAME') %>%
  rename(Name = NAME,
         Former_Name = FORMERNAME,
         Date_of_Birth = DATEOFBIRTHINCORPORATIONREGISTRATION,
         Place_of_Birth = PLACEOFBIRTHINCORPORATIONREGISTRATION,
         Nationality = NATIONALITYWHEREAPPLICABLE,
         Service_Address = SERVICEADDRESSINDIVIDUALREGISTEREDOFFICECORPORATE,
         Residential_Address = RESIDENTIALADDRESSINDIVIDUALPRINCIPALOFFICEADDRESSCORPORATE,
         Role = OFFICEHELD,
         Appointment_Date = DATEAPPOINTED,
         Resignation_Date1 = DATECEASED,
         Resignation_Date2 = DATERESIGNEDORREMOVED,
         Entity = COMPANYNAME,
         Address = ADDRESS,
         First_Name = `First Name`,
         Last_Name = `Last Name`
         ) %>%
  select(all_of(order_list)) %>%
  unite(Resignation_Date,Resignation_Date1,Resignation_Date2,remove = TRUE, na.rm = TRUE) %>%
  unite(Residential,Residential_Address,Address,remove = TRUE, na.rm = TRUE)



write_xlsx(
  data_rod_all,
  path = 'export_document/entity/all_rod_records.xlsx',
  col_names = TRUE,
  format_headers = TRUE
)


