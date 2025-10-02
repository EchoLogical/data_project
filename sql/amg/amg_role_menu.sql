-- daftar menunya
SELECT *
FROM tmenu

-- role
SELECT *
FROM trole_menu

-- mapping user dengan role di trole_menu
SELECT *
FROM trole_user

-- permissing mapping dengan trole_menu
SELECT *
FROM trole_menu_access

--SP get menu
EXEC sp_BuildMenuHierarchy_ByStructure @user_name = 'trah-up.dyah+test@avrist.com'
EXEC sp_BuildMenuHierarchy_ByStructure
     @user_name = 'DSNP121',
     @menu_id = 1,
     @menu_name = 'Dashboard'

--SP insert/update/delete role user
DECLARE @result VARCHAR(500)
EXEC sp_role_user
     @action='MOD|CRT|ACT|DEL',
     @user_name='DSNP121',
     @role_menu_id = '1',
     @is_active='1',
     @process_by='DSNP121',
     @result=@result out
SELECT @result AS result

DECLARE @result VARCHAR(500)
EXEC sp_role_user
     @action='CRT',
     @user_name='developer.avrist@avrist.com',
     @role_menu_id = '1',
     @is_active='1',
     @process_by='faisal.amir@avrist.com',
     @result=@result out
SELECT @result AS result

--SP insert/update/delete role menu access
DECLARE @result VARCHAR(500)
EXEC sp_role_menu_access
     @action='MOD|CRT|ACT|DEL',
     @role_menu_id='1',
     @menu_id = '1',
     @views='1',
     @modify='1',
     @is_active='1',
     @process_by='DSNP121',
     @result=@result out
SELECT @result AS result

-- view mapping role
select
    rm.name as role_menu_name,
    m.name as menu_name,
    rma.views,
    rma.modify,
    rma.actions
from
    trole_menu_access rma,
    trole_menu rm,
    tmenu m
where rm.id = rma.role_menu_id
and m.id = rma.menu_id
and m.parent_id = 0

-- view mapping user role
select
    ru.user_name,
    rm.name as menu_name
from
    trole_user ru,
     trole_menu rm
where ru.role_menu_id = rm.id



-- debug app
DECLARE @result VARCHAR(500)
EXEC sp_role_user @action = 'MOD',
     @user_name = 'DSNP117',
     @role_menu_id = '1',
     @is_active = '1',
     @process_by = 'Aqmarina-A.Ismahyati@avrist.com',
     @result = @result out
SELECT @result AS result



select
    al.email,
    tu.*
from trole_user tu, admin_login al
where al.username = tu.user_name

UPDATE trole_user
SET user_name = al.email
FROM trole_user tu
JOIN admin_login al ON al.username = tu.user_name



 