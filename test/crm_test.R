# 加载RMySQL包用于读取MySQL数据表
library(RMySQL) 

# 建立数据库链接，CRM数据库地址：10.11.6.13
dbconn <- dbConnect(
  MySQL(), host = '10.11.6.13', 
  dbname = 'irs', 
  user = 'irs', 
  password = 'irs_12qwaszx!@QWASZX', 
  port = 3306)

# 获取联系人信息
ir_contactors <- dbSendQuery(
  dbconn, 
  'SELECT * FROM ir_customer')

df_ir_contactors <- fetch(ir_contactors)

