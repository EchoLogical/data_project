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
ORDER BY admin_login.id DESC



select distinct role from admin_login;