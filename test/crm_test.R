# 加载RMySQL包用于读取MySQL数据表
library(RMySQL) 

# 建立数据库链接，CRM数据库地址：10.11.6.13


# 获取联系人信息
ir_contactors <- dbSendQuery(
  dbconn, 
  'SELECT * FROM ir_customer')

df_ir_contactors <- fetch(ir_contactors)

