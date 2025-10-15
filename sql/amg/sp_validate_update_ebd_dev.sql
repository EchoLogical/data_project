DECLARE
    @id INT,
    @email VARCHAR(255),
    @email_status BIT,

    @result BIT,
    @result_position INT,
    @result_message VARCHAR(255),
    @flag_update_hierarchy BIT,
    @email_result VARCHAR(255),
    @ebd_id INT,
    @admin_id INT

-- SET @id = 67;
SET @id = 10316;
SET @Email = 'test@example.com';
SET @Email_Status = 1;

SET @Result = 0;
SET @Result_Position = 0;
SET @Result_Message = NULL;
SET @Flag_Update_Hierarchy = 0;
SET @Email_Result = @Email;

SELECT
    @ebd_id = ebd.id,
    @admin_id = al.id
FROM ebd_data ebd
JOIN admin_login al ON ebd.admin_id = al.id
WHERE ebd.id = @id;

IF @ebd_id IS NULL
    BEGIN
        SELECT
            @admin_id = id
        FROM admin_login WHERE id = @id;
    END

IF @admin_id IS NULL AND @ebd_id IS NULL
    BEGIN
        SET @result = 0
        SET @result_position = 1
        SET @result_message = 'No EBD or admin found.'

        SELECT
            @result AS result,
            @result_position as result_position,
            @result_message as result_message,
            @flag_update_hierarchy as flag_update_hierarchy,
            @email_result as email_result,
            @ebd_id as ebd_id,
            @admin_id as admin_id

        RETURN;
    END

IF @ebd_id IS NOT NULL
    BEGIN
       SET @flag_update_hierarchy = 1
    END

IF @email_status = 0
    BEGIN
        SET @email_result = 'notactive-'+@email
    END

SET @result = 1
SET @result_position = 2
SET @result_message = 'Passed.'

SELECT
    @result AS result,
    @result_position as result_position,
    @result_message as result_message,
    @flag_update_hierarchy as flag_update_hierarchy,
    @email_result as email_result,
    @ebd_id as ebd_id,
    @admin_id as admin_id

