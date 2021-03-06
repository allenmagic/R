# load raw data and create a data.frame object
setwd("~/Documents/R/bank/")
bank <- read.csv("bank.csv",header=T)

# kill the CMB 
bank <- bank[bank$sbank!="招商",]
nb <- data.frame(bank$amount,bank$date,bank$bank,bank$sbank)

# rename the colnames of the data.frame
colnames(nb) <- c("ex","date","bank","sbank")  


# create a data.frame object
rg <- data.frame(band = c("<100万","100-200万","200-500万","500-1000万",">1000万"),
                 con = c(0,0,0,0,0))

# count the ex.value <= 1m (m is million)
rg[1,2] <- nrow(nb[nb$ex <= 1000000,])

# count the ex.value other condition
rg[2,2] <- nrow(nb[nb$ex > 1000000 & nb$ex <= 2000000,])
rg[3,2] <- nrow(nb[nb$ex > 2000000 & nb$ex <= 5000000,])
rg[4,2] <- nrow(nb[nb$ex > 5000000 & nb$ex <= 10000000,])
rg[5,2] <- nrow(nb[nb$ex > 10000000,])
rg

# calculate the ration and create data.frame
nrg <- cbind(rg,ratio = rg$con/sum(rg$con))
n_rg <- data.frame("充值区间" = nrg$band,"交易笔数" = nrg$con,"交易占比" = paste(round(nrg$ratio*100,2),"%",sep=''))
n_rg

# create the table for ratio
library(printr)
knitr::kable(n_rg,caption = "交易额大小统计")


# get the bar graphic by rg
library(ggplot2)
p <- ggplot(rg,aes(x=band,y=con,fill = con))
p <- p + scale_x_discrete(limits = rg$band)
p <- p + geom_bar(stat = "identity")
p <- p + labs(title = "按照转账金额大小分布",x = "转账金额",y = "转账的笔数",fill = "转账金额（万元）")
p <- p + geom_text(aes(label=rg$con),vjust=1.5,colour="white")
p <- p + theme(text=element_text(family="MicrosoftYaHei"))
p


