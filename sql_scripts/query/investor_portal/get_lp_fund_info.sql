SELECT 
lp_name ,
fund_name ,
value_date ,
commit_amount as 'commit_amount',
abs(distribution) as 'distribution',
abs(distribution)/paid_amount as 'dpi'
FROM 
portal_dev.es_lp_fund_info elfi 
WHERE value_date >= "2022-03-31" 
# and lp_name = '阳光人寿保险股份有限公司'
ORDER BY fund_name ,value_date 
