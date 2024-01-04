####################################################################
## 项目名称: 读取member的First Name和Last Name信息
## 创建日期: 2023-12-15
## 程序作者: Zheng Youxin
####################################################################

# 加载必要的包
library(readxl)
library(purrr)
library(dplyr)
library(tools)

source('data_process/entity/import_rod_from_file_bvi.R')
source('data_process/entity/import_rod_from_file_Cayman.R')

# 合并bvi和cayman的数据
data_rod <- rbind(combined_df_bvi, combined_df_cayman)

# 设置文件路径
file_path <- "E:/Documents/r_project/data_source/entity/member_list.xlsx"

# 读取member的姓名信息
member_list <- read_excel(file_path, col_names = TRUE) 
member_list$NAME <- str_trim(member_list$NAME)
data_rod$NAME <- str_trim(data_rod$NAME)


order_list <- c("Name","First_Name","Last_Name","Former_Name","Date_of_Birth","Place_of_Birth","Nationality","Service_Address","Residential_Address","Entity","Region","Role","Transfer_to","Appointment_Date","Resignation_Date1","Address","Resignation_Date2")


data_rod_all <- data_rod %>%
  left_join(member_list, by = 'NAME') %>%
  rename(Name = NAME,
         Former_Name = FORMERNAME,
         Date_of_Birth = DATEOFBIRTHINCORPORATIONREGISTRATION,
         Place_of_Birth = PLACEOFBIRTHINCORPORATIONREGISTRATION,
         Nationality = NATIONALITYWHEREAPPLICABLE,
         Service_Address = SERVICEADDRESSINDIVIDUALREGISTEREDOFFICECORPORATE,
         Residential_Address = RESIDENTIALADDRESSINDIVIDUALPRINCIPALOFFICEADDRESSCORPORATE,
         Appointment_Date = DATEAPPOINTED,
         Resignation_Date1 = DATECEASED,
         Resignation_Date2 = DATERESIGNEDORREMOVED,
         Entity = COMPANYNAME,
         Address = ADDRESS,
         First_Name = `First Name`,
         Last_Name = `Last Name`,
         Region = REGION
         ) %>%
  mutate(OFFICEHELD = str_to_title(OFFICEHELD)) %>%
  mutate(OFFICEHELD = case_when(OFFICEHELD == "Alternatedirectortochingnarcindychan" | OFFICEHELD == "Alternatedirectortochingnar" ~ "Alternate Director To Ching Nar Cindy Chan", TRUE ~ OFFICEHELD)) %>%
  separate(col = OFFICEHELD, into = c('Role','Transfer_to'), sep = 'To|Of', extra = "merge", fill = "right") %>%
  mutate(Transfer_to = str_trim(Transfer_to)) %>%
  select(all_of(order_list)) %>%
  unite(Resignation_Date,Resignation_Date1,Resignation_Date2,remove = TRUE, na.rm = TRUE) %>%
  unite(Residential,Residential_Address,Address,remove = TRUE, na.rm = TRUE) %>%
  mutate(Transfer_to = str_replace(Transfer_to,"\\b(\\w+)$", function(m) toupper(m))) %>%
  mutate(Last_Name = toupper(Last_Name)) %>%
  mutate(Former_Name = ifelse(Former_Name == "N/A", NA, Former_Name))  %>%
  mutate(Resignation_Date = ifelse(Resignation_Date == "" | Resignation_Date == " ", NA_character_, Resignation_Date)) %>%
  mutate(Role = if_else(str_detect(Role, "Management Director"), "Management Director", Role)) %>%
  mutate(Role = str_trim(Role)) 





status <- data_rod_all %>%
  group_by(Entity)  %>%
  summarize(
    Total_Directors = n(),
    Resignation_Directors = sum(!is.na(Resignation_Date), na.rm = TRUE)
  ) %>%
  left_join(data_rod_all[c("Entity","Region")], by = "Entity") %>%
  select(c("Region","Entity","Total_Directors","Resignation_Directors")) %>%
  distinct()


write_xlsx(
  data_rod_all,
  path = 'export_document/entity/all_rod_records.xlsx',
  col_names = TRUE,
  format_headers = TRUE
)



write_xlsx(
  status,
  path = 'export_document/entity/director_count.xlsx',
  col_names = TRUE,
  format_headers = TRUE
)


write_xlsx(
  data_rod_all %>%
    select(c(Residential)) %>% 
    distinct() %>%
    arrange(Residential) %>%
    mutate('Confirm Adress' = ''),
  path = 'export_document/entity/residential.xlsx',
  col_names = TRUE,
  format_headers = TRUE
)

