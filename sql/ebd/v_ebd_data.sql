SELECT ebd.id
     , ebd.role_id
     , ebd.member_id
     , ebd.admin_id
     , ebd.email
     , ebd.NAME
FROM ebd_data ebd
UNION
SELECT ABS(CHECKSUM(NEWID())) % 1000000 AS id
	,(
		SELECT id
		FROM mst_srva_role
		WHERE compass_definition = 'DIST_SUPPORT'
	) AS role_id
-- 	,CONCAT('AE',(
-- 			SELECT id
-- 			FROM mst_srva_role
-- 			WHERE compass_definition = 'DIST_SUPPORT'
-- 	),'-',al.id) AS member_id
    ,al.username as member_id
	,al.id AS admin_id
	,al.email AS email
	,dbo.fn_extractnamefromemail(al.email) AS NAME
FROM admin_login al
WHERE ROLE IN ('admin_ebd', 'Admin EB')
