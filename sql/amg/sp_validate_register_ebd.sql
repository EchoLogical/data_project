/**
    Mandatory for service AMG 2 com.avrist.amg.businessservice.registerebd
 */

ALTER PROCEDURE sp_validate_register_ebd
    @email NVARCHAR(100), -- email ldap
    @member_id NVARCHAR(50), -- ldap code
    @member_role_id INT, -- ebd role id

    @result INT OUT, -- validation result
    @result_position INT OUT, -- validation result position
    @ebd_update_existing INT OUT, -- flag to indicate whether an existing EBD record should be updated
    @admin_login_update_existing INT OUT, -- flag to indicate whether an existing admin login record should be updated
    @result_msg VARCHAR(255) OUT, -- validation result message
    @admin_id BIGINT OUT, -- admin id
    @ebd_id INT OUT, -- ebd id
    @deleted_admin_id BIGINT OUT -- deleted admin id
AS
BEGIN
    SET @ebd_update_existing = 0
    SET @admin_login_update_existing = 0

    DECLARE
        @existing_ebd_id INT,
        @existing_ebd_admin_login_status INT,
        @exising_ebd_admin_id BIGINT,
        @existing_ebd_admin_email VARCHAR(255),
        @target_admin_id BIGINT

    -- Check if the member already has an active EBD record
    SELECT
        @existing_ebd_id = ed.id,
        @existing_ebd_admin_login_status = al.isActive,
        @exising_ebd_admin_id = al.id,
        @existing_ebd_admin_email = al.email
    FROM ebd_data ed
    JOIN admin_login al ON ed.admin_id = al.id
    WHERE ed.member_id = @member_id

    -- flag admin id shoud be updated next
    SET @target_admin_id = @exising_ebd_admin_id

    -- validate if member status already active
    IF @existing_ebd_admin_login_status = 1
        BEGIN
            SET @result = 0
            SET @result_position = 1
            SET @result_msg = 'Member already active for email '+@existing_ebd_admin_email+'.'
            RETURN
        END

    DECLARE
        @existing_admin_login_status INT,
        @exising_admin_id BIGINT

    -- find existing admin login record by email to prevent duplicate data
    SELECT
        @existing_admin_login_status = isActive,
        @exising_admin_id = id
    FROM admin_login
    WHERE email = @Email

    -- validate if admin login data already active
    IF @existing_admin_login_status = 1
        BEGIN
            SET @result = 0
            SET @result_position = 2
            SET @result_msg = 'Member already active for email '+@Email+'.'
            RETURN
        END

    -- change target admin id which will be udpdated
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

    -- validate role id
    IF @role_id IS NULL
        BEGIN
            SET @result = 0
            SET @result_position = 3
            SET @result_msg = 'Invalid member role.'
            RETURN
        END

    -- flag to indicate whether an existing EBD record should be updated
    IF @existing_ebd_id IS NOT NULL
        BEGIN
            SET @ebd_update_existing = 1
        END

    -- flag to indicate whether an existing admin login record should be updated
    IF @target_admin_id IS NOT NULL
        BEGIN
            SET @admin_login_update_existing = 1
        END

    -- flag to indicate whether an existing admin id should be deleted
    IF COALESCE(@target_admin_id, -1) <> COALESCE(@exising_ebd_admin_id, -1)
        BEGIN
            -- SET @deleted_admin_id = @exising_ebd_admin_id
            SET @result = 0
            SET @result_position = 4
            SET @result_msg = 'Member '+@member_id+' has login email '+@existing_ebd_admin_email+' while email '+@email+' has registered for another account.'
            RETURN
        END

    SET @result = 1
    SET @result_position = 5
    SET @result_msg = 'Pass validation'
    SET @ebd_id = @existing_ebd_id
    SET @admin_id = @target_admin_id
END
GO

