-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

select
id,
arrangement_type,
reference_code
from authorisation_arrangement
where deleted_status = 0