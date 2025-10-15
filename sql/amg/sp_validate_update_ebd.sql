ALTER PROCEDURE sp_validate_update_ebd
    @id INT,
    @email VARCHAR(255),
    @email_status INT,
    @member_role_id INT,

    @result INT OUT,
    @result_position INT OUT,
    @result_message VARCHAR(255) OUT,
    @flag_update_hierarchy INT OUT,
    @email_result VARCHAR(255) OUT,
    @ebd_id INT OUT,
    @admin_id BIGINT OUT
AS
BEGIN
    
    SET @Result = 0
    SET @Result_Position = 0
    SET @Result_Message = NULL
    SET @Flag_Update_Hierarchy = 0
    SET @Email_Result = @Email
    SET @ebd_id = NULL
    SET @admin_id = NULL

    DECLARE
        @role_id INT
    SELECT
        @role_id = id
    FROM mst_srva_role
    WHERE id = @member_role_id
    IF @role_id IS NULL
        BEGIN
            SET @result = 0
            SET @result_position = 1
            SET @Result_Message = 'Invalid member role.'
            RETURN
        END

    SELECT
        @ebd_id = ebd.id,
        @admin_id = al.id
    FROM ebd_data ebd
    JOIN admin_login al ON ebd.admin_id = al.id
    WHERE ebd.id = @id

    IF @ebd_id IS NULL
        BEGIN
            SELECT
                @admin_id = id
            FROM admin_login WHERE id = @id
        END

    IF @admin_id IS NULL AND @ebd_id IS NULL
        BEGIN
            SET @result = 0
            SET @result_position = 2
            SET @result_message = 'No EBD or admin found.'
            RETURN
        END

    IF @ebd_id IS NOT NULL
        BEGIN
            DECLARE
                @count_admin INT
            select @count_admin = count(*) FROM admin_login WHERE id = @admin_id
            IF @count_admin = 0
                BEGIN
                    SET @result = 0
                    SET @result_position = 3
                    SET @result_message = 'Invalid EBD data.'
                END

           SET @flag_update_hierarchy = 1
        END

    IF @email_status = 0
        BEGIN
            SET @email_result = 'notactive-'+@email
        END
    ELSE
        BEGIN
            SET @email_result = REPLACE(@email, 'notactive-', '')

            DECLARE
                @email_count INT
            SELECT
                @email_count = COUNT(*)
            FROM admin_login al
            WHERE al.email = @email_result

            IF @email_count > 0
                BEGIN
                    SET @result = 0
                    SET @result_position = 4
                    SET @result_message = 'Email already exists.'
                    RETURN
                END
        END


    SET @result = 1
    SET @result_position = 5
    SET @result_message = 'Passed.'
    RETURN
END
GO

