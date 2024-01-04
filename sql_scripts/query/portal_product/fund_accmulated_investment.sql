-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

SELECT
eff.fund_name  ,
value_date ,
total_investment ,
create_datetime 
FROM es_fm_fund_indicator effi
left join es_fm_fund eff on eff.id =effi.fund_id 
WHERE  effi.is_delete = 0 and total_investment is not null and value_date >= '2022-03-31'
ORDER by eff.fund_name , value_date 