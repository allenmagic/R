-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

select 
id ,
parent_id ,
param_type ,
param_drpt ,
param_seq 
from base_param bp
where deleted_status = 0
