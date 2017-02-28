# 计算各个取到的交易量（过去一年）

# 设置工作目录
setwd("~/Documents/R/exchange/")

# 从exchange.csv读取原始数据
ex <- read.csv("exchange.csv",header = T)
colnames(ex) <- c("type","amount","date","product")  # 重新命名数据的列名称

# 绘制按照不产品的交易笔数的条形图
library(ggplot2)   # 加载ggplot2包
lv <- c("企业web版","企业客户端","TA强赎","企业app") # 设定因子水平的顺序
p <- ggplot(ex,aes(x=product,fill=product))   # 生成p对象
p <- p + geom_bar() + scale_x_discrete(limits=lv)  # 绘制条形图并按照lv改变x变量的顺序
p <- p + labs(title="不同产品发生的交易量（过去一年）",x=NULL,y="交易笔数",fill="企业版产品")
p <- p + theme(text = element_text(family = "WenQuanYiMicroHei"))
p

# 绘制按照不同产品的交易金额的条形图
q <- ggplot(ex,aes(x=product,y=sum(amount),fill=product))
q <- q + geom_bar(stat = "indentity")
q