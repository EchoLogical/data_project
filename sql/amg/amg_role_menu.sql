SELECT *
FROM tmenu

SELECT *
FROM trole_menu

SELECT *
FROM trole_user

SELECT *
FROM trole_menu_access


select distinct role from admin_login;


select * from admin_login al
where al.role in (
    'ADMIN'
);

delete from trole_user
where user_name = 'DSNP124';

delete from admin_login
where email like '%faisal%';

select * from trole_user
where user_name = 'DSNP124';

select * from admin_login
where email like '%faisal%';


select * from ebd_data
where admin_id in (
    select id from admin_login
    where email like '%faisal%'
);

select * from hr_data
where adminId in (
    select id from admin_login
    where email like '%faisal%'
);

select * from broker_data
where adminId in (
    select id from admin_login
    where email like '%faisal%'
);


-- SP add muser ke menu
DECLARE @result VARCHAR(500)
EXEC sp_role_user
     @action='CRT',
     @user_name='DSNP121',
     @role_menu_id = '1',
     @is_active='1',
     @process_by='DSNP121',
     @result=@result out
SELECT @result AS result

--SP get menu
EXEC sp_BuildMenuHierarchy_ByStructure @user_name = 'DSNP121'

--SP insert/update/delete role user
DECLARE @result VARCHAR(500)
EXEC sp_role_user @action='MOD', @user_name='DSNP121', @role_menu_id = '1', @is_active='1', @process_by='DSNP121',
     @result=@result out
SELECT @result AS result

--SP insert/update/delete role menu access
DECLARE @result VARCHAR(500)
EXEC sp_role_menu_access @action='CRT', @role_menu_id='1', @menu_id = '1', @views='1', @modify='1', @is_active='1',
     @process_by='DSNP121', @result=@result out
SELECT @result AS result
 