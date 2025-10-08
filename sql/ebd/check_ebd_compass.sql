select * from COMPINAP_SRVAE
where srvae = 'DSNP124';

delete from COMPINAP_SRVAE
where srvae = 'DSNP124';

DECLARE
    @ldapcd VARCHAR(10) = 'DSNP124';
select * from SRVAE_HIERARCHY
where ldap_cd_member = @ldapcd or ldap_cd_div_head = @ldapcd or ldap_cd_dept_head = @ldapcd;

delete from SRVAE_HIERARCHY
where ldap_cd_dept_head = 'DSNP124' OR ldap_cd_member = 'DSNP124';

select * from COMPINAP_SRVAE_POLICY
where srvae = 'DSNP124';

delete from COMPINAP_SRVAE_POLICY
where srvae = 'DSNP124';