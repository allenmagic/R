# 设置工作目录
setwd("~/Documents/R/exchange/")

# 从exchange.csv读取原始数据
rm(list = ls())   # 预清楚所有对象
ex <- read.csv("exchange.csv",header = T)
colnames(ex) <- c("type","amount","date","product")  # 重新命名数据的列名称

# 绘制按照不产品上的交易情况的条形图
library(ggplot2)   # 加载ggplot2包
library(plyr)      # 加载plyr包
d <- ddply(ex,"product",summarise,t_con = length(product),t_amt = sum(amount))   # 生成d
lv <- c("企业web版","企业客户端","TA强赎","企业app") # 设定因子水平的顺序

# 一些小设置
font <- c("WenQuanYiMicroHei")   # Macbook使用文泉驿字体
#font <- c("Microsoft YaHei")   # Mac使用微软雅黑字体

# 绘制不同产品交易笔数的条形图
p <- ggplot(d,aes(x=product,y=t_con,fill=product))
p <- p + geom_bar(stat = "identity",width = 0.6)
p <- p + scale_x_discrete(limits=lv)  #改变柱状图排序按照lv水平排序
p <- p + labs(title="不同产品发生的交易量（过去一年）",x=NULL,y="交易额",fill="企业版产品")
p <- p + theme(axis.title.y = element_text(angle = 0))
p <- p + theme(plot.title = element_text(hjust = 0.6,colour = "blue"))  # 改变标题的位置和颜色
p <- p + theme(text = element_text(family = font))
p


# 绘制不同产品交易额大小的条形图
q <- ggplot(d,aes(x=product,y=t_amt,fill=product)) 
q <- q + geom_bar(stat = "identity",width = 0.6)
q <- q + scale_x_discrete(limits=lv)  #改变柱状图排序按照lv水平排序
q <- q + labs(title="不同产品发生的交易额（过去一年）",x=NULL,y="交易笔数",fill="企业版产品")
q <- q + theme(text = element_text(family = font))
q
