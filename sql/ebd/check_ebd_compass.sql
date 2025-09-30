select * from COMPINAP_SRVAE
where srvae = 'DSNP028';

delete from COMPINAP_SRVAE
where srvae = 'DSNP028';

DECLARE
    @ldapcd VARCHAR(10) = 'DSNP028';
select * from SRVAE_HIERARCHY
where ldap_cd_member = @ldapcd or ldap_cd_div_head = @ldapcd or ldap_cd_dept_head = @ldapcd;


delete from SRVAE_HIERARCHY
where ldap_cd_dept_head = 'DSNP028';

select * from COMPINAP_SRVAE_POLICY
where srvae = 'DSNP028';

delete from COMPINAP_SRVAE_POLICY
where srvae = 'DSNP028';