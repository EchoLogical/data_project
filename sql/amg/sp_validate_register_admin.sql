CREATE PROCEDURE sp_validate_register_admin
    @email varchar(255),

    @result INT OUTPUT,
    @result_msg VARCHAR(255) OUTPUT,
    @result_pos INT OUTPUT,
    @admin_id BIGINT OUTPUT,
    @flag_update_role INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    SET @result = 0
    SET @result_msg = NULL
    SET @result_pos = 0
    SET @admin_id = NULL
    SET @flag_update_role = 0

    DECLARE
        @admin_status INT,
        @admin_role VARCHAR(50),
        @ebd_id INT
    SELECT
        @admin_status = al.isActive,
        @admin_id = al.id,
        @admin_role = al.role,
        @ebd_id = ebd.id
    FROM admin_login al
    LEFT JOIN ebd_data ebd ON al.id = ebd.admin_id
    WHERE al.email = @email
    OR al.email = 'inactive-'+@email

    IF @admin_id IS NULL
        BEGIN
            SET @result = 1;
            SET @result_pos = 1;
            SET @result_msg = 'New account identified.';
            RETURN;
        END;

    IF @admin_status = 1
        BEGIN
            SET @result = 0
            SET @result_pos = 2
            SET @result_msg = 'Email is already registered.'
            RETURN
        END

    IF @admin_status = 0
        BEGIN
            SET @result = 1
            SET @result_pos = 4
            SET @result_msg = 'Inactive email found.'
            SET @flag_update_role = 1
            SET @admin_id = NULL
            RETURN;
        END;
END
GO