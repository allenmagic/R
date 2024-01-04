-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

SELECT DISTINCT 
fund_name ,
lp_name 
#value_date ,
#commit_amount as 'commit_amount',
#abs(distribution) as 'distribution',
#abs(distribution)/paid_amount as 'dpi'
FROM 
es_lp_fund_info elfi 
WHERE value_date  = '2023-06-30'
