-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

select
id,
reference_code,
arrangement_id,
overview_type
from authorisation_overview
where deleted_status = 0