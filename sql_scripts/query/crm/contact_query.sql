-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

SELECT
CASE io.relationship 
	WHEN 1 THEN '潜在'
	WHEN 2 THEN '已有'
	ELSE '其它'
END AS 'lp_relationship',
io.id ,
CASE io.affiliation_team 
	WHEN 1 THEN '人民币'
	WHEN 2 THEN '美元'
	ELSE '其它'
END AS 'affiliation',
ic.name ,
ic.english_name ,
ic.email1 ,
ic.email2 ,
ic.job ,
ic.dept ,
ic.address1 ,
ic.address2 ,
ic.phone1 ,
ic.phone2 ,
io.name as 'org_name' ,
io.name_en as 'org_name_en'
FROM ir_customer ic 
LEFT JOIN ir_organization io on ic.organization_id =io.id
WHERE ic.is_delete = 0
ORDER BY io.relationship DESC, io.affiliation_team DESC