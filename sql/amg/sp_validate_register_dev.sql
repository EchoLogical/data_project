/**
    Mandatory for service AMG 2 com.avrist.amg.businessservice.registerebd
 */

DECLARE
    @email NVARCHAR(100), -- email ldap
    @member_id NVARCHAR(50), -- ldap code
    @member_role_id INT, -- ebd role id

    @result INT, -- validation result
    @result_position INT, -- validation result position
    @ebd_update_existing INT, -- flag to indicate whether an existing EBD record should be updated
    @admin_login_update_existing INT, -- flag to indicate whether an existing admin login record should be updated
    @result_msg VARCHAR(255), -- validation result message
    @admin_id INT, -- admin id
    @ebd_id INT, -- ebd id
    @deleted_admin_id INT -- deleted admin id

SET @email = 'faisal.amir@avrist.com'
SET @member_id = 'DSNP124'
SET @member_role_id = 3

SET @ebd_update_existing = 0
SET @admin_login_update_existing = 0

DECLARE
    @existing_ebd_id INT,
    @existing_ebd_admin_login_status INT,
    @exising_ebd_admin_id INT,
    @existing_ebd_admin_email VARCHAR(255),
    @target_admin_id INT

SELECT
    @existing_ebd_id = ed.id,
    @existing_ebd_admin_login_status = al.isActive,
    @exising_ebd_admin_id = al.id,
    @existing_ebd_admin_email = al.email
FROM ebd_data ed
JOIN admin_login al ON ed.admin_id = al.id
WHERE ed.member_id = @member_id;

SET @target_admin_id = @exising_ebd_admin_id

IF @existing_ebd_admin_login_status = 1
    BEGIN
        SET @result = 0;
        SET @result_position = 1;
        SET @result_msg = 'Member already active for email '+@existing_ebd_admin_email+'.';

        SELECT
            @result as result,
            @result_position as result_position,
            @result_msg as result_msg,
            @ebd_id as ebd_id,
            @admin_id as admin_id,
            @deleted_admin_id as deleted_admin_id

        RETURN;
    END

DECLARE
    @existing_admin_login_status INT,
    @exising_admin_id INT;

SELECT
    @existing_admin_login_status = isActive,
    @exising_admin_id = id
FROM admin_login
WHERE email = @Email

IF @existing_admin_login_status = 1
    BEGIN
        SET @result = 0;
        SET @result_position = 2;
        SET @result_msg = 'Member already active for email '+@Email+'.';

        SELECT
            @result as result,
            @result_position as result_position,
            @result_msg as result_msg,
            @ebd_id as ebd_id,
            @admin_id as admin_id,
            @deleted_admin_id as deleted_admin_id

        RETURN;
    END

IF @exising_admin_id IS NOT NULL
    BEGIN
        SET @target_admin_id = @exising_admin_id
    END

DECLARE
    @role_id INT

SELECT
    @role_id = id
FROM mst_srva_role
WHERE id = @member_role_id

IF @role_id IS NULL
    BEGIN
        SET @result = 0;
        SET @result_position = 3;
        SET @result_msg = 'Invalid member role.';

        SELECT
            @result as result,
            @result_position as result_position,
            @result_msg as result_msg,
            @ebd_id as ebd_id,
            @admin_id as admin_id,
            @deleted_admin_id as deleted_admin_id

        RETURN;
    END

IF @existing_ebd_id IS NOT NULL
    BEGIN
        SET @ebd_update_existing = 1;
    END

IF @target_admin_id IS NOT NULL
    BEGIN
        SET @admin_login_update_existing = 1;
    END

IF COALESCE(@target_admin_id, -1) <> COALESCE(@exising_ebd_admin_id, -1)
    BEGIN
        -- SET @deleted_admin_id = @exising_ebd_admin_id;
        SET @result = 0;
        SET @result_position = 4;
        SET @result_msg = 'Member '+@member_id+' has login email '+@existing_ebd_admin_email+' while email '+@email+' has registered for another account.';

        SELECT
            @result as result,
            @result_position as result_position,
            @result_msg as result_msg,
            @ebd_id as ebd_id,
            @admin_id as admin_id,
            @deleted_admin_id as deleted_admin_id

        RETURN;
    END

SET @result = 1;
SET @result_position = 5;
SET @result_msg = 'Pass validation';
SET @ebd_id = @existing_ebd_id
SET @admin_id = @target_admin_id;

SELECT
    @result as result,
    @result_position as result_position,
    @result_msg as result_msg,
    @ebd_id as ebd_id,
    @admin_id as admin_id,
    @deleted_admin_id as deleted_admin_id


