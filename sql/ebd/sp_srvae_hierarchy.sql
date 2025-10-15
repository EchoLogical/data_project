
/*
SELECT DISTINCT ROLE FROM COMPINAP_SRVAE

SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] --WHERE ldap_cd_dept_head = 'DSNP097' --ldap_cd_div_head = 'DSNP097'
SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]

  SELECT * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] CS
  JOIN [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] SH
  ON SH.ldap_cd_div_head = CS.srvae

  DECLARE @result				VARCHAR(500);
  EXEC sp_srvae_hierarchy
	@action='ADD_SRVAE',
	@srvae= 'TEST123',
	@role = NULL,
	@name = 'TEST 123',
	@status = '1',
	@process_by = 'DSNP121',
	@result = @result out

	SELECT @result AS result
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_div_head IS NOT NULL
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] IS NOT NULL ORDER BY ROLE ASC

  DECLARE @result				VARCHAR(500);
  EXEC sp_srvae_hierarchy
	@action='MOD_SRVAE',
	@dept_head_id='DSNP124',
	@srvae= 'KECAP106',
	@role = 'EBD_MEMBER',
	@name = 'TEST 106',
	@status = '1',
	@process_by = 'DSNP121',
	@result = @result out

	SELECT @result AS result
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_div_head IS NOT NULL
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] IS NOT NULL ORDER BY ROLE ASC
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]  WHERE srvae = 'DSNP114'
	DECLARE @result				VARCHAR(500);
  EXEC sp_srvae_hierarchy
	@action='ADD_SRVAE',
	@srvae= 'KECAP102',
	@role = 'EBD_MEMBER',
	@dept_head_id='DSNP121',
	@name = 'Test Test 102',
	@status = '1',
	@process_by = 'DSNP121',
	@result = @result out

	SELECT @result AS result
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_div_head IS NOT NULL
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] IS NOT NULL ORDER BY ROLE ASC

	--DELETE FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae='DSNP122'
	--DELETE FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]


	DECLARE @result VARCHAR(500);
	EXEC sp_srvae_hierarchy
		@action='MOD_SRVAE',
		@srvae= 'DSNP121',
		@role = 'DEPT_HEAD',
		@member_id = 'DSNP027',
		@dept_head_id = 'null',
		@name = 'ANGGIH',
		@status = '1',
		@process_by = 'testAdminEBD@avrist.com',
		@result = @result out
		SELECT @result AS MyResult

		-- ini untuk turun
		DECLARE @result VARCHAR(500);
		EXEC sp_srvae_hierarchy
			@action='MOD_SRVAE',
			@srvae= 'DPMO012',
			@role = 'EBD_MEMBER',
			@member_id = '',
			@dept_head_id = 'DSNP100',
			@name = 'Aprilla Malriati Ginting',
			@status = '1',
			@process_by = 'testAdminEBD@avrist.com',
			@result = @result out
		SELECT @result AS result
		SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_div_head IS NOT NULL
		SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] IS NOT NULL ORDER BY ROLE ASC
		SELECT*FROM [SVRQW16GHL01].[MedicalGate].[dbo].[member_change_history] ORDER BY created_date DESC

		-- ini naik
		DECLARE @result VARCHAR(500);
		EXEC sp_srvae_hierarchy
			@action='MOD_SRVAE',
			@srvae= 'DPMO012',
			@role = 'DEPT_HEAD',
			@member_id = 'DSNP116',
			@dept_head_id = '',
			@name = 'Aprilla Malriati Ginting',
			@status = '1',
			@process_by = 'testAdminEBD@avrist.com',
			@result = @result out
		SELECT @result AS result

		DELETE FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_member='DSNP116'


		DECLARE @result VARCHAR(500);
		EXEC sp_srvae_hierarchy
		@action = 'MOD_SRVAE', @div_head_id = '',
		@dept_head_id = '',
		@member_id = '',
		@role = 'DIV_HEAD',
		@srvae = 'DSNP109',
		@source = '', @status = '1', @process_by = 'testAdminEBD@avrist.com',
		@result = @result out
		SELECT @result AS result

		SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_div_head IS NOT NULL
		SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] IS NOT NULL ORDER BY ROLE ASC
		SELECT*FROM [SVRQW16GHL01].[MedicalGate].[dbo].[member_change_history] ORDER BY created_date DESC

		SELECT*FROM [SVRQW16GHL01].[MedicalGate].[dbo].[ebd_data] WHERE member_id IN ('DSNP117', 'DSNP109', 'DSNP127')
		SELECT*FROM [SVRQW16GHL01].[MedicalGate].[dbo].[admin_login] WHERE id IN (SELECT admin_id FROM [SVRQW16GHL01].[MedicalGate].[dbo].[ebd_data] WHERE member_id IN ('DSNP117', 'DSNP109', 'DSNP127'))



		--UPDATE [SVRQW16GHL01].[MedicalGate].[dbo].[admin_login] SET isActive = 0 WHERE id =10393

		--DELETE FROM [SVRQW16GHL01].[MedicalGate].[dbo].[member_change_history]
		--UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] SET [ldap_cd_div_head] = 'DSNP117'
		--UPDATE [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] SET [status] = 1 WHERE srvae='DSNP117'

	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
	SELECT TOP (1000) * FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae IN ('DACC031', 'DACC145','DSNP145','DSNP114')


*/

CREATE PROCEDURE [dbo].[sp_srvae_hierarchy]
	@action				VARCHAR(15),
	@div_head_id		VARCHAR(50) = '',
	@dept_head_id		VARCHAR(50) = '',
	@member_id			VARCHAR(MAX) = '',
	@role				VARCHAR(50) = '',
	@srvae				VARCHAR(50) = '',
	@name				VARCHAR(150) = '',
	@source				VARCHAR(500) = '',
	@status				VARCHAR(1) = '1',
	@process_by			VARCHAR(50) = '',
	@result				VARCHAR(500) OUT
AS
BEGIN
	SET NOCOUNT ON;

	--Declare Standard Variables
	DECLARE @return_ids					VARCHAR(1000)='',
			@process_status				VARCHAR(15)='',
			@process_description		VARCHAR(1000)='',
			@call_return_ids			VARCHAR(1000)='',
			@call_process_status		VARCHAR(15)='',
			@call_process_description	VARCHAR(1000)='',
			@call_result				NVARCHAR(1000)='',
			@invalid_reason				VARCHAR(1000)=''

	--Declare Related Variables
	DECLARE @today						DATETIME

BEGIN TRY

		--CREATE TABLE #ROLE (
		--	role_name VARCHAR(20),
		--	role_lvl int
		--);

		--INSERT INTO #ROLE VALUES ('DIV_HEAD', 1);
		--INSERT INTO #ROLE VALUES ('DEPT_HEAD', 2);
		--INSERT INTO #ROLE VALUES ('EBD_MEMBER', 3);

		DECLARE @temp_div_head_id		VARCHAR(50) = '',
				@temp_dept_head_id		VARCHAR(50) = '',
				@temp_srvae				VARCHAR(50) = '',
				@response				VARCHAR(500)='',
				@request				VARCHAR(500)='';

		DECLARE @tempRole VARCHAR(100) = '';

		DECLARE @data_member_id NVARCHAR(100);
		DECLARE @Members TABLE (member_id NVARCHAR(100));

SELECT TOP 1 @temp_div_head_id = srvae FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] = 'DIV_HEAD' AND [status] = 1;
SELECT TOP 1 @temp_dept_head_id = srvae FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE [role] = 'DEPT_HEAD' AND [status] = 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------
PRINT('PROCESS : ' + @action)
		SET @request =
			'@action = ' + @action + ', @div_head_id = ' + @div_head_id +
			', @dept_head_id = ' + @dept_head_id + ', @member_id = ' + @member_id +
			', @role = ' + @role + ', @srvae = ' + @srvae + ', @name = ' + @name +
			', @source = ' + @source + ', @status = ' + @status + ', @process_by = ' + @process_by

		DECLARE @resultOut				VARCHAR(500);
		IF @action='ADD_SRVAE'		--Create New SRVAE
BEGIN

			--VALIDATIONS
			IF @srvae=''
				SET @invalid_reason=@invalid_reason+'Invalid user or member '+CHAR(10)
			IF @role=''
				SET @invalid_reason=@invalid_reason+'Invalid role '+CHAR(10)
			IF @name=''
				SET @invalid_reason=@invalid_reason+'Invalid name '+CHAR(10)

			IF EXISTS(SELECT [srvae] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @srvae AND [status] = 1)
BEGIN
					SET @invalid_reason=@invalid_reason+'User or member id already exists ' + @srvae+CHAR(10)
END

			SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
			IF @invalid_reason<>''
BEGIN
				PRINT 'MASUK ERROR SINI 4'
SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END

			SET @call_result = dbo.fValidateSrvaeHierarchy(@action, @srvae, @role, @status);
			IF @call_result = 'OK'
BEGIN
					PRINT('@call_result : ' + @call_result)

					--PROCESS INSERT COMPINAP_SRVAE
					INSERT	[COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]
							([srvae], [role], [name], [created_at], [created_by], [source], [updated_at], [updated_by], [status])
SELECT	UPPER(@srvae), UPPER(@role), UPPER(@name), GETDATE(), UPPER(@process_by), @source, GETDATE(),  UPPER(@process_by), CAST(@status AS BIT)

    --PROCESS INSERT SRVAE_HIERARCHY
    PRINT('@@role : ' + @role)
					IF @role = 'EBD_MEMBER'
BEGIN
						IF @temp_div_head_id != '' AND @temp_dept_head_id != ''
BEGIN
EXEC sp_srvae_hierarchy @action='ADD_SRVAE_HRC', @div_head_id= @temp_div_head_id, @dept_head_id = @temp_dept_head_id,
								@member_id = @srvae, @process_by = @process_by, @result = @resultOut out
END
END
ELSE
BEGIN

SELECT @temp_srvae = srvae FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]
WHERE [role] = @role AND [status] = 1 AND NOT srvae = @srvae;

UPDATE	[COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]
SET
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
								updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END,
								[status]=0
						WHERE	[srvae]=@temp_srvae

						IF @role = 'DIV_HEAD'
BEGIN
UPDATE [SVRQW16GHL01].[MedicalGate].[dbo].[admin_login] SET isActive = 0
WHERE id IN (SELECT admin_id FROM [SVRQW16GHL01].[MedicalGate].[dbo].[ebd_data] WHERE member_id = @temp_srvae)

UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
SET
    ldap_cd_div_head = @srvae,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
									updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
							WHERE ldap_cd_div_head = @temp_srvae
END
ELSE IF @role = 'DEPT_HEAD'
BEGIN
							IF @member_id <> ''
BEGIN

								SET @data_member_id = '';
DELETE FROM @Members;
-- Split and insert into table variable
INSERT INTO @Members (member_id)
SELECT LTRIM(RTRIM(value))
FROM STRING_SPLIT(@member_id, ',');

-- Cursor for looping through each member_id
IF CURSOR_STATUS('local', 'member_cursor_ADD_SRVAE') >= -1
BEGIN
CLOSE member_cursor_ADD_SRVAE
    DEALLOCATE member_cursor_ADD_SRVAE
END

								IF CURSOR_STATUS('local', 'member_cursor_MOD_SRVAE') >= -1
BEGIN
CLOSE member_cursor_MOD_SRVAE;
DEALLOCATE member_cursor_MOD_SRVAE;
END

								DECLARE member_cursor_ADD_SRVAE CURSOR FOR
SELECT DISTINCT member_id FROM @Members;

OPEN member_cursor_ADD_SRVAE;
FETCH NEXT FROM member_cursor_ADD_SRVAE INTO @data_member_id;

WHILE @@FETCH_STATUS = 0
BEGIN
									-- Check if member exists
									IF NOT EXISTS (
										SELECT 1 FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
										WHERE ldap_cd_member = @data_member_id
									)
BEGIN

										IF NOT EXISTS(SELECT [srvae] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id)
BEGIN
											SET @invalid_reason=@invalid_reason+'User or member id doesnt exists ' + @data_member_id+CHAR(10)
END
ELSE
BEGIN
											SET @tempRole = '';
SELECT @tempRole = [role] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id
    IF @tempRole IS NULL
BEGIN
												SET @tempRole = 'EBD_MEMBER'
UPDATE [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] SET [role] = @tempRole, [status]=1,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
													updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
												WHERE srvae = @data_member_id;
END
END

										SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
										IF @invalid_reason<>''
BEGIN
											PRINT 'MASUK ERROR SINI 5'
											CLOSE member_cursor_ADD_SRVAE;
											DEALLOCATE member_cursor_ADD_SRVAE;

SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION

END

EXEC sp_srvae_hierarchy
											@action = 'ADD_SRVAE_HRC',
											@div_head_id = @temp_div_head_id,
											@dept_head_id = @srvae,
											@member_id = @data_member_id,
											@process_by = @process_by,
											@result = @resultOut OUT;

END
ELSE
BEGIN
SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''

SELECT @result= (
    SELECT
        @process_status process_status,
        @process_description process_description,
        @return_ids return_ids
    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER )

SET @tempRole = '';
SELECT @tempRole = [role] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id
    IF @tempRole IS NULL
BEGIN
											SET @tempRole = 'EBD_MEMBER'
END

										SET @resultOut = '';
EXEC sp_member_change_history @action = @action, @role_id_aft = @tempRole,
											@member_id_aft = @data_member_id, @email_aft	= '', @name_aft = '', @report_to_aft = @srvae,
											@status_aft = 1, @request = @request, @response = @result,
											@process_by = @process_by, @result = @resultOut out;

UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
SET ldap_cd_dept_head = @srvae,
    ldap_cd_div_head = @temp_div_head_id,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
											updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
										WHERE ldap_cd_member = @data_member_id;
END

FETCH NEXT FROM member_cursor_ADD_SRVAE INTO @data_member_id;
END

CLOSE member_cursor_ADD_SRVAE;
DEALLOCATE member_cursor_ADD_SRVAE;

END
							--UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
							--SET
							--		ldap_cd_dept_head = @srvae
							--WHERE ldap_cd_dept_head = @temp_srvae
END
ELSE IF @role = 'EBD_MEMBER'
BEGIN
							-- Check if member exists
							IF NOT EXISTS (
								SELECT 1 FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
								WHERE ldap_cd_member = @srvae
							)
BEGIN
								IF @dept_head_id <> ''
BEGIN
EXEC sp_srvae_hierarchy @action='ADD_SRVAE_HRC', @div_head_id= @temp_div_head_id, @dept_head_id = @dept_head_id,
										@member_id = @srvae, @process_by = @process_by, @result = @resultOut out
END
ELSE
BEGIN
									SET @invalid_reason=@invalid_reason+'Department Head must be assigned. This field cannot be left empty.'+CHAR(10)
									SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
									IF @invalid_reason<>''
BEGIN
										PRINT 'MASUK ERROR SINI 6'
SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END
END
END
ELSE
BEGIN
UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
SET ldap_cd_dept_head = @srvae,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
								updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
								WHERE ldap_cd_member = @data_member_id;
END

END
END
END

SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''
END

		------------------------------------------------------------------------------------------------------------------------------------------------------------------
ELSE IF @action='MOD_SRVAE'	--Modify SRVAE
BEGIN
			--VALIDATIONS
			IF @srvae=''
				SET @invalid_reason=@invalid_reason+'Invalid srvae'+CHAR(10)

			IF NOT EXISTS(SELECT [srvae] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @srvae)
BEGIN
					SET @invalid_reason=@invalid_reason+'User or member doesnt exists'+CHAR(10)
END

			--other validations...

			SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
			IF @invalid_reason<>''
BEGIN
				PRINT 'MASUK ERROR SINI 7'
SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END

			SET @call_result = dbo.fValidateSrvaeHierarchy(@action, @srvae, @role, @status);
			PRINT('VALIDATE : ' + @call_result)
			IF @call_result = 'OK'
BEGIN

				--Jika update role dari EBD_MEMBER to DEPT_HEAD
				SET @tempRole = '';
SELECT @tempRole = [role] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @srvae AND [status] = 1;
IF @tempRole <> ''
BEGIN
					IF @tempRole = 'EBD_MEMBER' AND @role = 'DEPT_HEAD'
BEGIN
						DELETE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_member = @srvae;
END
END
				------------------------------

UPDATE	[COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]
SET		srvae=CASE WHEN @srvae = '' OR @srvae IS NULL THEN srvae ELSE @srvae END,
							[role]=CASE WHEN @role = '' OR @role IS NULL THEN [role] ELSE @role END,
							[name]=CASE WHEN @name = '' OR @name IS NULL THEN [name] ELSE @name END,
							source=CASE WHEN @source = '' OR @source IS NULL THEN source ELSE @source END,
							updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
							updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END,
							[status]=CASE WHEN @status = '' OR @status IS NULL THEN [status] ELSE @status END
					WHERE	[srvae]=@srvae

					--PROCESS INSERT SRVAE_HIERARCHY
					PRINT('CEK ROLE : ' + @role + ' @srvae : ' + @srvae + ' status : ' + @status)
					IF @role = 'EBD_MEMBER'
BEGIN
						DECLARE @resultOut1				VARCHAR(500);
						DECLARE @temp				VARCHAR(500) = CASE WHEN @dept_head_id = '' THEN @temp_dept_head_id ELSE @dept_head_id END;
						PRINT('@temp : ' + @temp)
						PRINT('@dept_head_id : ' + @dept_head_id)
						PRINT('@temp_dept_head_id : ' + @temp_dept_head_id)
						IF NOT EXISTS(SELECT 1 FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_member = @srvae)
BEGIN
							PRINT('NOT EXISTS HIERARCHY : sp_srvae_hierarchy @action=ADD_SRVAE_HRC')
							EXEC sp_srvae_hierarchy @action='ADD_SRVAE_HRC', @div_head_id= @temp_div_head_id, @dept_head_id = @temp,
								@member_id = @srvae, @process_by = @process_by, @result = @resultOut1 out
								PRINT('@resultOut1 : ' + @resultOut1)
END
ELSE
BEGIN
SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''

SELECT @result= (
    SELECT
        @process_status process_status,
        @process_description process_description,
        @return_ids return_ids

    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER )

SET @tempRole = '';
SELECT @tempRole = [role] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id
    IF @tempRole IS NULL
BEGIN
								SET @tempRole = 'EBD_MEMBER'
END

							SET @resultOut = '';
EXEC sp_member_change_history @action = @action, @role_id_aft = @tempRole,
								@member_id_aft = @srvae, @email_aft	= '', @name_aft = '', @report_to_aft = @temp,
								@status_aft = 1, @request = @request, @response = @result,
								@process_by = @process_by, @result = @resultOut out;

UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
SET ldap_cd_dept_head = @temp,
    ldap_cd_div_head = @temp_div_head_id,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
									updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
							WHERE ldap_cd_member = @srvae;
END
END
ELSE
BEGIN

SELECT @temp_srvae = srvae FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]
WHERE [role] = @role AND [status] = 1 AND NOT srvae = @srvae;

PRINT('ELSE : UPDATE	[COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] @temp_srvae : ' + @temp_srvae)

						IF @role = 'DIV_HEAD'
BEGIN
							PRINT('MASUK IF @role = DIV_HEAD : ' + @temp_srvae + ' BEFORE HEAD')
							PRINT('MASUK IF @role = DIV_HEAD : ' + @srvae + ' AFTER HEAD')
UPDATE [SVRQW16GHL01].[MedicalGate].[dbo].[admin_login] SET isActive = 0
WHERE id = (SELECT TOP 1 admin_id FROM [SVRQW16GHL01].[MedicalGate].[dbo].[ebd_data]
    WHERE member_id = @temp_srvae  AND role_id = 1)

    IF EXISTS (SELECT member_id FROM [SVRQW16GHL01].[MedicalGate].[dbo].[ebd_data] WHERE member_id = @srvae)
BEGIN
								PRINT('MASUK BOSS')
UPDATE [SVRQW16GHL01].[MedicalGate].[dbo].[admin_login]
SET isActive = 1, updatedAt = GETDATE()
WHERE id = (
    SELECT TOP 1 admin_id
    FROM [SVRQW16GHL01].[MedicalGate].[dbo].[ebd_data]
    WHERE member_id = @srvae AND role_id = 1
--ORDER BY updatedAt DESC
    )
END

UPDATE	[COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE]
SET
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
									updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END,
									[status]=0
							WHERE	[srvae]=@temp_srvae

UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
SET
    ldap_cd_div_head = @srvae,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
									updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
							WHERE ldap_cd_div_head = @temp_srvae
END
ELSE IF @role = 'DEPT_HEAD'
BEGIN
							SET @data_member_id = '';

							-- Table variable to hold split member IDs
							--DECLARE @Members TABLE (member_id NVARCHAR(100));
DELETE FROM @Members;
-- Split and insert into table variable
INSERT INTO @Members (member_id)
SELECT LTRIM(RTRIM(value))
FROM STRING_SPLIT(@member_id, ',');

-- Cursor for looping through each member_id
IF CURSOR_STATUS('local', 'member_cursor_ADD_SRVAE') >= -1
BEGIN
								PRINT('MASUK IF CURSOR_STATUS member_cursor_ADD_SRVAE')
								CLOSE member_cursor_ADD_SRVAE
								DEALLOCATE member_cursor_ADD_SRVAE
END

							IF CURSOR_STATUS('local', 'member_cursor_MOD_SRVAE') >= -1
BEGIN
								PRINT('MASUK IF CURSOR_STATUS member_cursor_MOD_SRVAE')
								CLOSE member_cursor_MOD_SRVAE;
								DEALLOCATE member_cursor_MOD_SRVAE;
END
							PRINT('@member_cursor_MOD_SRVAE : BEFORE DECLARE' )
							DECLARE member_cursor_MOD_SRVAE CURSOR FOR
SELECT DISTINCT member_id FROM @Members;
PRINT('@member_cursor_MOD_SRVAE : AFTER DECLARE' )
							OPEN member_cursor_MOD_SRVAE;
							PRINT('@member_cursor_MOD_SRVAE : OPEN DECLARE' )
							FETCH NEXT FROM member_cursor_MOD_SRVAE INTO @data_member_id;

							WHILE @@FETCH_STATUS = 0
BEGIN
								PRINT('@data_member_id : ' + @data_member_id)
								IF NOT EXISTS(SELECT [srvae] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id)
BEGIN
											SET @invalid_reason=@invalid_reason+'User or member id doesnt exists ' + @data_member_id+CHAR(10)
END
ELSE
BEGIN
											SET @tempRole = '';
SELECT @tempRole = [role] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id
    IF @tempRole IS NULL
BEGIN
												SET @tempRole = 'EBD_MEMBER'
UPDATE [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] SET [role] = @tempRole, [status]=1,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
													updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
												WHERE srvae = @data_member_id;
END
END

								SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
								IF @invalid_reason<>''
BEGIN
									PRINT 'MASUK ERROR SINI 1'
									CLOSE member_cursor_MOD_SRVAE;
									DEALLOCATE member_cursor_MOD_SRVAE;

SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END

								-- Check if member exists
								IF NOT EXISTS (
									SELECT 1 FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
									WHERE ldap_cd_member = @data_member_id
								)
BEGIN
EXEC sp_srvae_hierarchy
										@action = 'ADD_SRVAE_HRC',
										@div_head_id = @temp_div_head_id,
										@dept_head_id = @srvae,
										@member_id = @data_member_id,
										@process_by = @process_by,
										@result = @resultOut OUT;
END
ELSE
BEGIN
SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''

SELECT @result= (
    SELECT
        @process_status process_status,
        @process_description process_description,
        @return_ids return_ids

    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER )

SET @tempRole = '';
SELECT @tempRole = [role] FROM [COMPASS_PORTAL].[dbo].[COMPINAP_SRVAE] WHERE srvae = @data_member_id
    IF @tempRole IS NULL
BEGIN
										SET @tempRole = 'EBD_MEMBER'
END

									SET @resultOut = '';
EXEC sp_member_change_history @action = @action, @role_id_aft = @tempRole,
										@member_id_aft = @data_member_id, @email_aft	= '', @name_aft = '', @report_to_aft = @srvae,
										@status_aft = 1, @request = @request, @response = @result,
										@process_by = @process_by, @result = @resultOut out;

									PRINT('MASUK UPDATE')
									PRINT('ldap_cd_dept_head = ' + @srvae)
									PRINT('ldap_cd_div_head = ' + @temp_div_head_id)
									PRINT('ldap_cd_member = ' + @data_member_id)
UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
SET ldap_cd_dept_head = @srvae,
    ldap_cd_div_head = @temp_div_head_id,
    updated_at=CASE WHEN GETDATE() IS NULL THEN updated_at ELSE GETDATE() END,
										updated_by=CASE WHEN @process_by IS NULL THEN updated_by ELSE @process_by END
									WHERE ldap_cd_member = @data_member_id;
END

FETCH NEXT FROM member_cursor_MOD_SRVAE INTO @data_member_id;
END

CLOSE member_cursor_MOD_SRVAE;
DEALLOCATE member_cursor_MOD_SRVAE;
							--UPDATE [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
							--SET
							--		ldap_cd_dept_head = @srvae
							--WHERE ldap_cd_dept_head = @temp_srvae

END
END

SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''
END
ELSE
BEGIN
					SET @invalid_reason=@invalid_reason+@call_result+CHAR(10)
					SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
					IF @invalid_reason<>''
BEGIN
						PRINT 'MASUK ERROR SINI 2'
SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END
END

END

		------------------------------------------------------------------------------------------------------------------------------------------------------------------
ELSE IF @action='ADD_SRVAE_HRC'	--Add SRVAE HRC
BEGIN
			PRINT('PROCCESS @action=ADD_SRVAE_HRC')
			--VALIDATIONS
			IF @div_head_id=''
				SET @invalid_reason=@invalid_reason+'Invalid div_head_id'+CHAR(10)
			IF @dept_head_id=''
				SET @invalid_reason=@invalid_reason+'Invalid dept_head_id'+CHAR(10)
			IF @member_id=''
				SET @invalid_reason=@invalid_reason+'Invalid member_id'+CHAR(10)
			IF EXISTS(SELECT ldap_cd_member FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_member = @member_id)
				SET @invalid_reason=@invalid_reason+'Member id already exists'+CHAR(10)

			PRINT('@invalid_reason : ' + @invalid_reason)
			SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
			IF @invalid_reason<>''
BEGIN
				PRINT 'MASUK ERROR SINI 8'
				IF CURSOR_STATUS('local', 'member_cursor_MOD_SRVAE') >= -1
BEGIN
CLOSE member_cursor_MOD_SRVAE;
DEALLOCATE member_cursor_MOD_SRVAE;
END

				IF CURSOR_STATUS('local', 'member_cursor_ADD_SRVAE') >= -1
BEGIN
CLOSE member_cursor_ADD_SRVAE;
DEALLOCATE member_cursor_ADD_SRVAE;
END

SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END

INSERT INTO [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
([ldap_cd_member], [ldap_cd_dept_head], [ldap_cd_div_head], [created_at], [created_by], [updated_at], [updated_by])
VALUES
    (@member_id, @dept_head_id, @div_head_id, GETDATE(), @process_by, GETDATE(), @process_by)

SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''

SELECT @result= (
    SELECT
        @process_status process_status,
        @process_description process_description,
        @return_ids return_ids

    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER )
SET @resultOut = '';
EXEC sp_member_change_history @action = @action, @role_id_aft = @role,
				@member_id_aft = @member_id, @email_aft	= '', @name_aft = '', @report_to_aft = @dept_head_id,
				@status_aft = 1, @request = @request, @response = @result,
				@process_by = @process_by, @result = @resultOut out;
END

		------------------------------------------------------------------------------------------------------------------------------------------------------------------
ELSE IF @action='MOD_SRVAE_HRC'	--MOD SRVAE HRC
BEGIN
			--SELECT * FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY] WHERE ldap_cd_member = 'DSNP097'
			--VALIDATIONS
			IF @member_id=''
				SET @invalid_reason=@invalid_reason+'Invalid member id'+CHAR(10)
			IF @dept_head_id=''
				SET @invalid_reason=@invalid_reason+'Invalid dept head id'+CHAR(10)
			IF @div_head_id=''
				SET @invalid_reason=@invalid_reason+'Invalid div head id'+CHAR(10)

			IF NOT EXISTS(SELECT [id] FROM [COMPASS_PORTAL].[dbo].[SRVAE_HIERARCHY]
				WHERE ldap_cd_member = @member_id AND ldap_cd_dept_head = @dept_head_id AND ldap_cd_div_head = @div_head_id)
BEGIN
					SET @invalid_reason=@invalid_reason+'Data doesnt exists'+CHAR(10)
END

			--other validations...

			SET @invalid_reason=LEFT(@invalid_reason, dbo.fmax(LEN(@invalid_reason)-1,0))
			IF @invalid_reason<>''
BEGIN
				PRINT 'MASUK ERROR SINI 3'
SELECT	@process_status='-1', @process_description=@invalid_reason
    GOTO COMPLETION
END

UPDATE [dbo].[SRVAE_HIERARCHY]
SET [ldap_cd_member] = @member_id
        ,[ldap_cd_dept_head] = @dept_head_id
        ,[ldap_cd_div_head] = @div_head_id
        ,[updated_at] = GETDATE()
        ,[updated_by] = @process_by
WHERE ldap_cd_member = @member_id AND ldap_cd_dept_head = @dept_head_id AND ldap_cd_div_head = @div_head_id

SELECT	@process_status	= '0',
          @process_description = 'Process completed sucessfully',
          @return_ids=''
END

		------------------------------------------------------------------------------------------------------------------------------------------------------------------

END TRY
BEGIN CATCH
PRINT('BEGIN CATCH')
		IF CURSOR_STATUS('local', 'member_cursor_MOD_SRVAE') >= -1
BEGIN
CLOSE member_cursor_MOD_SRVAE;
DEALLOCATE member_cursor_MOD_SRVAE;
END

		IF CURSOR_STATUS('local', 'member_cursor_ADD_SRVAE') >= -1
BEGIN
CLOSE member_cursor_ADD_SRVAE;
DEALLOCATE member_cursor_ADD_SRVAE;
END

SELECT	@process_status = CAST(ERROR_NUMBER() AS VARCHAR), @process_description = LEFT(ERROR_MESSAGE(),1000)
END CATCH

COMPLETION:
--DROP TABLE #ROLE
PRINT('COMPLETION:')
SELECT @result= (
    SELECT
        @process_status process_status,
        @process_description process_description,
        @return_ids return_ids
    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER )

DECLARE @tempResult VARCHAR(500) = @result;

SET @resultOut = '';
EXEC sp_member_change_history @action = @action, @role_id_aft = @role,
	@member_id_aft = @srvae, @email_aft	= '', @name_aft = @name, @report_to_aft = '',
	@status_aft = @status, @request = @request, @response = @tempResult,
	@process_by = @process_by, @result = @resultOut out;
	--SELECT @resultOut AS ResultAs
END

go

