# 设置工作目录
setwd("~/Documents/R/exchange/")

# 从exchange.csv读取原始数据
ex <- read.csv("exchange.csv",header = T)
colnames(ex) <- c("type","amount","date","product")  # 重新命名数据的列名称

# 绘制按照不产品上的交易情况的条形图
library(ggplot2)   # 加载ggplot2包
library(plyr)      # 加载plyr包
d <- ddply(ex,"product",summarise,t_con = length(product),t_amt = sum(amount))   # 生成d

# 绘制不同产品交易笔数的条形图
p <- ggplot(d,mapping = aes(x=reorder(product,t_con),y=t_con,fill=product))
p <- p + geom_bar("indentity")
#p <- p + labs(title="不同产品发生的交易量（过去一年）",x=NULL,y="交易笔数",fill="企业版产品")
#p <- p + theme(text = element_text(family = "WenQuanYiMicroHei"))
p

