# 这是一个计算企业版充值金额和次数按银行分布的方法，同时做出相应的图形

# 设置工作目录
setwd("~/Documents/R/bank/")

# 读取原始数据
bank <- read.csv("bank.csv",header=T)

# 加载ggplot包
library(ggplot2)å

# 绘制按照银行分布的申购
p <- ggplot(bank,aes(x=reorder(sbank,-rep(1,length(sbank)),sum),fill=bank)) 
p <- p + geom_bar()  
p <- p + labs(title="企业版过去一年充值业务按银行分布",x="银行",y="交易笔数") 
p <- p + theme(text=element_text(family="MicrosoftYaHei")) 
p