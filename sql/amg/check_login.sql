select distinct role from admin_login;


select * from admin_login al
where al.role in (
    'HR'
    );

select * from admin_login al
where al.role in (
    'Super Admin'
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
