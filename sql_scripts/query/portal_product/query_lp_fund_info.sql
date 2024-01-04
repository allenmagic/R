-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

SELECT DISTINCT 
elfi.fund_name ,
lp_name ,
case eff.currency_id
	when 1 then 'RMB'
	when 2 then 'USD'
end as currency
FROM 
es_lp_fund_info elfi 
left join es_fm_fund eff on elfi.fund_id = eff.id 
WHERE value_date  = '2023-06-30'
