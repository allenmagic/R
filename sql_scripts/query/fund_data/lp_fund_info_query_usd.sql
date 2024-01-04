-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

select
lp_name ,
elfi.fund_name ,
value_date,
commit_amount ,
unfunded_commit_amount ,
lp_transfer_out ,
paid_amount ,
distribution ,
carried_interest_paid ,
recall_distribution ,
non_recall_distribution ,
mgmt_fee ,
other_pnl ,
dividend ,
other_fee ,
realized_gain ,
un_realized_gain ,
pre_nav ,
un_realized_carry ,
post_nav ,
pre_funded_amount ,
return_capital ,
capital_held_in_reserve 
from irs.es_lp_fund_info elfi 
left join irs.ir_fund iif on elfi.fund_id = iif.id
where iif.currency_id  = 2 
order by elfi.fund_name ,value_date 