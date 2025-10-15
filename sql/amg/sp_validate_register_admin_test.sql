-- 🔹 Deklarasi variabel output
DECLARE
    @result INT,
    @result_msg VARCHAR(255),
    @result_pos INT,
    @admin_id INT,
    @flag_update_role INT;

-- 🔹 Eksekusi stored procedure dengan email yang ingin diuji
EXEC sp_validate_login_role
     @email = 'notactive-Trah-UP.Dyah@avrist.com',
     @result = @result OUTPUT,
     @result_msg = @result_msg OUTPUT,
     @result_pos = @result_pos OUTPUT,
     @admin_id = @admin_id OUTPUT,
     @flag_update_role = @flag_update_role OUTPUT;

-- 🔹 Lihat hasil output
SELECT
    @result AS result,
    @result_msg AS result_message,
    @result_pos AS result_position,
    @admin_id AS admin_id,
    @flag_update_role AS flag_update_role;