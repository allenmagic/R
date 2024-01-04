-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

select distinct
cb.company_name_en ,
cad.account_name ,
cad.category ,
bk.param_drpt as bank_full_name ,
blc.param_drpt as bank_location ,
ca.swift_code ,
ca.bank_or_broker as account_nature,
cad.account_number ,
cad.account_type ,
cad.currency ,
cad.cheque_book ,
cad.online_payment as payment_authorisation_online_code,
cad.paper_form as payment_authorisation_manual_code,
cad.trading as trading_authorisation_code,
cad.system_administrator as system_administrator_code,
cad.mandate as mandate_authorisation_code,
cad.opening_date as account_opening_date,
cad.closure_date as account_closure_date,
cad.crs_controlling_person as CRS_controlling_person,
cad.remark as Remark
from company_account_detail cad  
left join company_account ca on ca.id = cad.account_id 
left join company_base cb on ca.company_id = cb.id 
left join authorisation_overview ao on ao.id = cad.paper_form 
left join authorisation_arrangement aa on aa.id = ao.arrangement_id 
left join (select b.id,b.bank_name_id,bp.param_drpt from base_param bp left join bank b on bp.id = b.bank_name_id where param_type = 'bank_name') as bk on bk.id = ca.bank_id  
left join (select bl.id,bl.location,bp.param_drpt from base_param bp left join bank_location bl on bp.id = bl.location where param_type = 'bank_location') as blc on blc.id = ca.bank_location 
where cad.deleted_status = 0 

