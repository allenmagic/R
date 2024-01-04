###########################################################################################
## Project: Product performance analysis
## File Name: get stock performance data from excel document
## Create Date: 2023-09-12
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
###########################################################################################


## loading the tidyverse package
library(pacman)
pacman::p_load(treemapify)
pacman::p_load(tidyverse)
pacman::p_load(showtext)

## Loading data from excel file and delete the row with name is error item
stock_performance_data <- readxl::read_excel("data_source/seim/performance_analysis.xlsx")
color_value <- c("#00A870","#AE1129")
get_record <- 5
stock_performance_data_fixed <- stock_performance_data %>% 
  filter(stock != "误差项") %>% 
  mutate(gain_loss = weeky_profit>=0) %>% 
  arrange(desc(weeky_profit)) %>%
  slice(c(head(row_number(),get_record),tail(row_number(),get_record)))


## Create the tree graphics for the top and tail stock performance
## Loading Google fonts (https://fonts.google.com/)
#font_add_google("Noto Sans Simplified Chinese","Noto Sans SC",repo = "https://fonts.google.com/")
font_add_google("Covered By Your Grace", "grace")
showtext_auto(enable = TRUE, record = TRUE)

## Draw the graphics by ggplot2
g <- ggplot2::ggplot(stock_performance_data_fixed,  ## datasets
                     aes(area=abs(weeky_profit/10000), ## statitcs indicator
                     fill = gain_loss,  ## fill color for data with positive and negative
                     label=paste0(stock,"\n",weeky_profit/10000,"万元",sep=""))) + ## label text on the data point
  treemapify::geom_treemap(size = 1, color = "#FFFFFF") + 
  scale_fill_manual(values = color_value,guide="none") +
  geom_treemap_text(color="#FFFFFF",size="11",place = "center")  #family="Source Cascadia",
g

## Create the tree graphics for the industry performance
p <- ggplot2::ggplot(stock_performance_data_fixed %>% 
                       group_by(industry) %>% 
                       summarise(industry_profit=sum(weeky_profit)) %>% 
                       arrange(desc(industry_profit)),
                       aes(area=abs(industry_profit/10000), 
                       fill = industry_profit>=0,
                       label=paste0(industry,"\n",industry_profit/10000,"万元",sep=""))) + 
  treemapify::geom_treemap(size = 1, color = "#FFFFFF") + 
  scale_fill_manual(values = color_value,guide="none") +
  geom_treemap_text(color="#FFFFFF",size="11",place = "center")
p