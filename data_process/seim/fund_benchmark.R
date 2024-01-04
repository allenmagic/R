## loading the reticulate package
library(reticulate)
library(tidyverse)

## setting the condaenv for this script to use ak_share
use_condaenv(condaenv = "r-reticulate", required = TRUE)

## import akshare
ak <- import("akshare")


## get 000083 汇添富消费混合基金的净值数据
df_open_fund_daily_value <- ak$fund_open_fund_info_em(fund ='000083', indicator ='单位净值走势')