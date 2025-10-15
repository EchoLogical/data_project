
DECLARE
    @result INT,
    @result_position INT,
    @ebd_update_existing INT,
    @admin_login_update_existing INT,
    @result_msg VARCHAR(255),
    @admin_id INT,
    @ebd_id INT,
    @deleted_admin_id INT

EXEC sp_validate_register_ebd
    @email = 'faisal.amir@avrist.com',
    @member_id = 'DSNP124',
    @member_role_id = 3,
    @result = @result OUTPUT,
    @result_position = @result_position OUTPUT,
    @ebd_update_existing = @ebd_update_existing OUTPUT,
    @admin_login_update_existing = @admin_login_update_existing OUTPUT,
    @result_msg = @result_msg OUTPUT,
    @admin_id = @admin_id OUTPUT,
    @ebd_id = @ebd_id OUTPUT,
    @deleted_admin_id = @deleted_admin_id OUTPUT;

SELECT
    @result AS Result,
    @result_position AS ResultPosition,
    @ebd_update_existing AS EBDUpdateExisting,
    @admin_login_update_existing AS AdminLoginUpdateExisting,
    @result_msg AS ResultMessage,
    @admin_id AS AdminId,
    @ebd_id AS EbdId,
    @deleted_admin_id AS DeletedAdminId;