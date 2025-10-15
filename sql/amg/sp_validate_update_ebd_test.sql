DECLARE
    @result INT,
    @result_position INT,
    @result_message VARCHAR(255),
    @flag_update_hierarchy INT,
    @email_result VARCHAR(255),
    @ebd_id INT,
    @admin_id INT;

EXEC sp_validate_update_ebd
    @id = 61,
    @email = 'rifqi@avrist.com',
    @email_status = 1,
    @member_role_id = 2,
    @result = @result OUTPUT,
    @result_position = @result_position OUTPUT,
    @result_message = @result_message OUTPUT,
    @flag_update_hierarchy = @flag_update_hierarchy OUTPUT,
    @email_result = @email_result OUTPUT,
    @ebd_id = @ebd_id OUTPUT,
    @admin_id = @admin_id OUTPUT;

SELECT
    @result AS result,
    @result_position AS result_position,
    @result_message AS result_message,
    @flag_update_hierarchy AS flag_update_hierarchy,
    @email_result AS email_result,
    @ebd_id AS ebd_id,
    @admin_id AS admin_id;
