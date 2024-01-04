SELECT 
lp_name ,
value_date ,
SUM(commit_amount) as 'total_commit',
SUM(paid_amount) as 'total_paid_amount', 
SUM(paid_amount)/SUM(commit_amount) as 'progress',
SUM(ABS(distribution)) as 'total_distribution',
SUM(capital_account) as 'total_capital_accout' 
FROM 
portal_dev.es_lp_fund_info elfi 
WHERE value_date >= '2022-03-31'
GROUP BY lp_name, value_date 
ORDER BY lp_name, value_date 