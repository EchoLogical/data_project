SELECT admin_login.id          as id,
       admin_login.email       as email,
       admin_login.isActive    as isActive,
       admin_login.username    as username,
       broker_data.companyName as companyName,
       broker_data.brokerID    as brokerId,
       admin_login.role        as role,
       admin_login.eDate       as eDate,
       admin_login.createdAt   as createdAt,
       admin_login.updatedAt   as updatedAt
FROM admin_login
         LEFT OUTER JOIN broker_data ON admin_login.id = broker_data.adminId
WHERE admin_login.ROLE NOT IN ('EBD', 'admin_ebd')
ORDER BY admin_login.id DESC;

select distinct role from admin_login;

WITH duplicate_check as (
    SELECT email,
         COUNT(*) AS duplicate_count
    FROM admin_login
    GROUP BY email
    HAVING COUNT(*) > 1
)
select
    al.id as admin_id,
    ed.id as ebd_id,
    hr.id as hr_id,
    bd.id as broker_id,
    al.createdAt as admin_created_at,
    al.updatedAt as admin_updated_at,
    al.email as admin_email,
    al.role as admin_role,
    al.isActive as admin_isActive,
    ed.email as ebd_email,
    tu.user_name as trole_user_name,
    tm.name as role_permission
from admin_login al
left join ebd_data ed on al.id = ed.admin_id
left join trole_user tu on al.email = tu.user_name
left join trole_menu tm on tu.role_menu_id = tm.id
left join hr_data hr on hr.adminId = al.id
left join broker_data bd on bd.adminId = al.id
where al.email in (
    select email from duplicate_check
)


select * from ebd_data
where member_id = 'dsnp124'

select * from admin_login
where id = 1081

delete from admin_login where id in (
    20439
);

delete from ebd_data
where member_id = 'dsnp124';

select * from admin_login
where email = 'aqmarina-a.ismahyati+HR@avrist.com';





