# 导入所需模块
import pandas as pd
from sqlalchemy import create_engine
import re

# 假设 expert_dbconn.R 中定义了如下内容：
host = "10.11.5.31"
dbname = "expert"
user = "expert_prod"
password = "exp&123cpe"
port = 3306
# 使用 SQLAlchemy 创建数据库引擎
engine = create_engine('postgresql+psycopg2://user:password@host:port/dbname')

# 读取 SQL 文件
with open('sql_scripts/query/expert/expert_query_all_detail.sql', 'r', encoding='utf-8') as file:
    sql_query = file.read()

# 执行 SQL 查询并创建数据框
df_expert_all_records = pd.read_sql_query(sql_query, engine)

# 处理project_name字段，删除括号及其内部的内容
df_expert_all_records['project_name'] = df_expert_all_records['project_name'].apply(lambda x: re.sub(r"\(.*\)", "", x))

# 删除换行符
df_expert_all_records['interview_subject'] = df_expert_all_records['interview_subject'].replace("\n", "", regex=True)
df_expert_all_records['expert_intro'] = df_expert_all_records['expert_intro'].replace("\n", "", regex=True)

# 创建子集
columns_to_keep = ['cpe_interview_id', 'task_id_external', 'expert_vendor', 'interview_subject', 'applicant', 'department', 'meeting_time', 'fee', 'duration', 'summary_status']
df_expert_all_records_table = df_expert_all_records[columns_to_keep]

# 转换数据类型（如果需要）

# 导出 CSV 文件
df_expert_all_records.to_csv('export_document/expert/expert_fee_list_internal_py.csv', index=False, encoding='utf-8-sig')
df_expert_all_records_table.to_csv('export_document/expert/expert_fee_list_for_vendor_check_py.csv', index=False, encoding='utf-8-sig')

# 关闭数据库链接
engine.dispose()
