SELECT 
CASE iefv.provider_name
	WHEN 'capvision' THEN '凯盛'
	WHEN 'ThirdBridge' THEN '高临'
	WHEN 'GLG' THEN 'GLG'
	ELSE '其他'
END AS '专家供应商',
iefv.task_id as 'Task ID External',
iefv.interview_id as 'CPE Interview ID',
su.user_name as '申请人',
sd.dept_name as '所属部门/板块',
iefv.meeting_time as '访谈时间',
iefv.subject '专家访谈主题',
iefv.meeting_summary as '专家情况介绍',
iefv.fee as '访谈费用',
iefv.fee_currency as '费用货币',
iefv.fee_min as '实际访谈时长（分钟）',
CASE iefv.project_type
	WHEN 'proj' THEN '项目费用'
	WHEN 'industry' THEN '行研费用'
	WHEN 'user' THEN '高管费用'
	ELSE '其他费用'
END AS '访谈费用类型',
iefv.project_code as '项目/行研/高管编码',
iefv.project_name as '项目/行研/高管名称',
iefv.meeting_summary_url as '访谈纪要飞书文档'
FROM is_expert_fee_view iefv
LEFT JOIN sys_user su on iefv.apply_user = su.user_no 
LEFT JOIN sys_user_dept sud on su.user_id = sud.user_id 
LEFT JOIN sys_dept sd on sud.dept_id = sd.dept_id  
WHERE iefv.meeting_time BETWEEN '2023-07-01 00:00:00' AND '2023-07-31 23:59:59' 
ORDER BY iefv.meeting_time 