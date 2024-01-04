###########################################################################################
## Project: Get expert fee and compare the fee with vendor's record
## File Name: get expert(completed) fee from our product database
## Create Date: 2023-09-01
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
###########################################################################################

library(tidyverse)
library(ggplot2)

## Get hist for distribution for LP
df_lp_fund_info %<>%  as_tibble() %>% mutate(across(4:6,as.numeric)) %>% mutate_if(is.numeric, funs(ifelse(is.na(.), 0, .)))

g <- ggplot(df_lp_fund_info %>% filter(lp_name == '阳光人寿保险股份有限公司',value_date>='2021-09-30',fund_name == '人民币PE基金二期'), aes(x=value_date,y=distribution)) + geom_col()
g