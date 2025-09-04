/**
  EXEC sp_validate_rule
     @product_id = 'DIGILIFE',
     @plan_id = 'ADLMCU',
     @rider_id = NULL,

     @key2 = '1900-01-01',
     @key4 = 'Y',
     @key5 = 'M',
     @key6 = '1',
     @key8 = '50000.00',
     @key9 = 'A',
     @key15 = '2025-01-01'

     SELECT field_name, key_no, variable_name, is_rule FROM rule_field
     WHERE product_id = 'DIGILIFE'

     SELECT * FROM rules WHERE product_id = 'DIGILIFE'

 */
ALTER PROCEDURE [dbo].[sp_validate_rule]
    @product_id VARCHAR(50),
    @plan_id VARCHAR(50) = NULL,
    @rider_id VARCHAR(50) = NULL,

    -- input
    @key1 VARCHAR(50) = NULL,
    @key2 VARCHAR(50) = NULL,
    @key3 VARCHAR(50) = NULL,
    @key4 VARCHAR(50) = NULL,
    @key5 VARCHAR(50) = NULL,
    @key6 VARCHAR(50) = NULL,
    @key7 VARCHAR(50) = NULL,
    @key8 VARCHAR(50) = NULL,
    @key9 VARCHAR(50) = NULL,
    @key10 VARCHAR(50) = NULL,
    @key11 VARCHAR(50) = NULL,
    @key12 VARCHAR(50) = NULL,
    @key13 VARCHAR(50) = NULL,
    @key14 VARCHAR(50) = NULL,
    @key15 VARCHAR(50) = NULL,
    @key16 VARCHAR(50) = NULL,
    @key17 VARCHAR(50) = NULL,
    @key18 VARCHAR(50) = NULL,
    @key19 VARCHAR(50) = NULL,
    @key20 VARCHAR(50) = NULL,
    @key21 VARCHAR(50) = NULL,
    @key22 VARCHAR(50) = NULL,
    @key23 VARCHAR(50) = NULL,
    @key24 VARCHAR(50) = NULL,
    @key25 VARCHAR(50) = NULL
AS
BEGIN
    IF @product_id IS NULL OR @product_id = ''
    BEGIN
        RAISERROR('Missing required parameter: product_id', 16, 1);
    END;

    -- variable data nasabah
    DECLARE
        @owner_dob            VARCHAR(100) = NULL,
        @insured_dob VARCHAR(100) = NULL,
        @owner_gender CHAR(1) = NULL,
        @insured_gender CHAR(1) = NULL,
        @payment_method VARCHAR(20) = NULL,
        @coverage_period_unit VARCHAR(20) = NULL,
        @coverage_period VARCHAR(20) = NULL,
        @up VARCHAR(20) = NULL,
        @additional_benefit   VARCHAR(50)  = NULL,
        @policy_issue_date    VARCHAR(50)  = NULL,
        @current_date         DATETIME     = GETDATE(),
        @premium_period       VARCHAR(20)  = NULL,
        @currency             VARCHAR(20)  = NULL,
        @premium_amount       VARCHAR(50)  = NULL;

DECLARE
        @cursor_field_name VARCHAR(50),
        @key_no INT,
        @variable_name VARCHAR(50),
        @cursor_mandatory_field INT = 0,
        @cursor_field_display_name VARCHAR(200),
        @cursor_sql_query NVARCHAR(MAX);

DECLARE rule_field_cursor CURSOR FOR
    SELECT
        field_name,
        key_no,
        variable_name,
        is_rule,
        field_display_name FROM rule_field rf
    WHERE rf.product_id = @product_id;

OPEN rule_field_cursor;
FETCH NEXT FROM rule_field_cursor INTO
    @cursor_field_name,
    @key_no,
    @variable_name,
    @cursor_mandatory_field,
    @cursor_field_display_name;

-- Menghapus tabel sementara jika sudah ada sebelumnya
DROP TABLE IF EXISTS #temp_sp_getrule_results;

-- Membuat tabel sementara untuk menyimpan hasil
CREATE TABLE #temp_sp_getrule_results (
                                          field_name VARCHAR(MAX),
        product_id VARCHAR(50),
        plan_id VARCHAR(50),
        rider_id VARCHAR(50),
        result INT,
        error_message NVARCHAR(255),
        rule_name NVARCHAR(255)
    );

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT('Processing Rule Field: '+@cursor_field_name);

BEGIN TRY
    IF @cursor_mandatory_field = 1
        BEGIN
            SET @cursor_sql_query =
            N'IF @key'+CAST(@key_no AS NVARCHAR(10))+' IS NULL OR @key' +CAST(@key_no AS NVARCHAR(10))+ ' = ''''
                BEGIN
                    INSERT INTO #temp_sp_getrule_results
                            SELECT
                                @cursor_field_name AS field_name,
                                @product_id        AS product_id,
                                @plan_id           AS plan_id,
                                @rider_id          AS rider_id,
                                1                  AS result,
                                ''' + @cursor_field_display_name + ' tidak boleh kosong'' AS error_message,
                                ''Mandatory Field Validation @key' + CAST(@key_no AS NVARCHAR(10)) + ''' AS rule_name
                        END
                    ELSE
                        BEGIN
                            SET ' + @variable_name + ' = @key' + CAST(@key_no AS NVARCHAR(10)) + '
                        END';
            END
            ELSE
            BEGIN
                SET @cursor_sql_query =
                    'SET ' + @variable_name + ' = @key' + CAST(@key_no AS NVARCHAR(10));
            END;

            -- Untuk debug
            PRINT('SET ' + @variable_name + ' : @key' + CAST(@key_no AS NVARCHAR(10)));

            -- Eksekusi SQL dinamis
            EXEC sp_executesql
                @cursor_sql_query,
                N'@key1 VARCHAR(50), @key2 VARCHAR(50), @key3 VARCHAR(50), @key4 VARCHAR(50),
                  @key5 VARCHAR(50), @key6 VARCHAR(50), @key7 VARCHAR(50), @key8 VARCHAR(50),
                  @key9 VARCHAR(50), @key10 VARCHAR(50), @key11 VARCHAR(50), @key12 VARCHAR(50),
                  @key13 VARCHAR(50), @key14 VARCHAR(50), @key15 VARCHAR(50), @key16 VARCHAR(50),
                  @key17 VARCHAR(50), @key18 VARCHAR(50), @key19 VARCHAR(50), @key20 VARCHAR(50),
                  @key21 VARCHAR(50), @key22 VARCHAR(50), @key23 VARCHAR(50), @key24 VARCHAR(50),
                  @key25 VARCHAR(50), @cursor_field_name VARCHAR(50), @product_id VARCHAR(50),
                  @plan_id VARCHAR(50), @rider_id VARCHAR(50),
                  @coverage_period_unit VARCHAR(20) OUTPUT, @coverage_period VARCHAR(20) OUTPUT,
                  @owner_dob VARCHAR(100) OUTPUT, @insured_dob VARCHAR(100) OUTPUT,
                  @owner_gender CHAR(1) OUTPUT, @insured_gender CHAR(1) OUTPUT,
                  @payment_method VARCHAR(20) OUTPUT, @up VARCHAR(20) OUTPUT,
                  @additional_benefit VARCHAR(50) OUTPUT, @policy_issue_date VARCHAR(50) OUTPUT,
                  @premium_period VARCHAR(20) OUTPUT, @currency VARCHAR(20) OUTPUT, @premium_amount VARCHAR(50) OUTPUT',
                @key1, @key2, @key3, @key4, @key5, @key6, @key7, @key8, @key9, @key10,
                @key11, @key12, @key13, @key14, @key15, @key16, @key17, @key18, @key19, @key20,
                @key21, @key22, @key23, @key24, @key25, @cursor_field_name, @product_id, @plan_id, @rider_id,
                @coverage_period_unit OUTPUT, @coverage_period OUTPUT,
                @owner_dob OUTPUT, @insured_dob OUTPUT, @owner_gender OUTPUT, @insured_gender OUTPUT,
                @payment_method OUTPUT, @up OUTPUT, @additional_benefit OUTPUT, @policy_issue_date OUTPUT,
                @premium_period OUTPUT, @currency OUTPUT, @premium_amount OUTPUT;
        END TRY
        BEGIN CATCH
            PRINT('Error in ' + @cursor_field_name + ': ' + ERROR_MESSAGE());
            PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(50)));
            PRINT('Error severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10)));
            PRINT('Error state: ' + CAST(ERROR_STATE() AS VARCHAR(10)));
            PRINT('Error procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
            PRINT('Error line: ' + CAST(ERROR_LINE() AS VARCHAR(10)));
        END CATCH;

        FETCH NEXT FROM rule_field_cursor INTO
            @cursor_field_name,
            @key_no,
            @variable_name,
            @cursor_mandatory_field,
            @cursor_field_display_name;
    END;

    CLOSE rule_field_cursor;
    DEALLOCATE rule_field_cursor;

    -- variable
    DECLARE
        @owner_age INT,
        @insured_age INT,
        @age_rule VARCHAR(50);

    SELECT TOP 1
        @age_rule = rule_condition
    FROM rules
    WHERE rule_name = '@age_rule'
      AND product_id = @product_id
      AND isActive = 'AC';

    IF @age_rule IS NOT NULL
    BEGIN
        PRINT('Age rule: ' + @age_rule);
        PRINT('Owner DOB: ' + @owner_dob);
        PRINT('Insured DOB: ' + @insured_dob);

        BEGIN TRY
            SET @owner_age = dbo.fAge(@age_rule, CAST(@owner_dob AS DATETIME));
            PRINT('Calculated owner age using ' + @age_rule + ': ' + CAST(@owner_age AS VARCHAR(10)));

            SET @insured_age = dbo.fAge(@age_rule, CAST(@insured_dob AS DATETIME));
            PRINT('Calculated insured age using ' + @age_rule + ': ' + CAST(@insured_age AS VARCHAR(10)));
        END TRY
        BEGIN CATCH
            PRINT('Error in calculating owner and insured age: ' + ERROR_MESSAGE());
            PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(50)));
            PRINT('Error severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10)));
            PRINT('Error state: ' + CAST(ERROR_STATE() AS VARCHAR(10)));
            PRINT('Error procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
            PRINT('Error line: ' + CAST(ERROR_LINE() AS VARCHAR(10)));
        END CATCH;
    END;

    -- Deklarasi variabel untuk menyimpan kondisi aturan, pesan error, dan nama aturan
    DECLARE
        @cursor_rule_condition NVARCHAR(MAX),
        @cursor_error_message  NVARCHAR(255),
        @cursor_rule_name      NVARCHAR(255);

    -- Cursor untuk setiap kondisi aturan dari tabel rules
    DECLARE rule_cursor CURSOR FOR
        SELECT
            rf.field_name,
            r.rule_condition,
            r.rule_name,
            r.error_message,
            rf.key_no,
            rf.variable_name
        FROM rules r
        LEFT JOIN rule_field rf ON rf.rules_id = r.rule_id
        WHERE r.product_id = @product_id
          AND (r.plan_id = @plan_id OR r.plan_id IS NULL)
          AND (r.rider_id = @rider_id OR r.rider_id IS NULL)
          AND r.isActive = 'AC'
          AND r.type_rules = 'isValidate'
          AND rf.is_rule = 1;

    -- Membuka cursor
    OPEN rule_cursor;

    FETCH NEXT FROM rule_cursor INTO
        @cursor_field_name,
        @cursor_rule_condition,
        @cursor_rule_name,
        @cursor_error_message,
        @key_no,
        @variable_name;

    -- Loop untuk setiap baris hasil dari cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            SET @cursor_sql_query = N'
                INSERT INTO #temp_sp_getrule_results
                SELECT
                    @cursor_field_name AS field_name,
                    @product_id        AS product_id,
                    @plan_id           AS plan_id,
                    @rider_id          AS rider_id,
                    CASE WHEN ' + @cursor_rule_condition + ' THEN 1 ELSE 0 END AS result,
                    @cursor_error_message AS error_message,
                    @cursor_rule_name     AS rule_name';

            PRINT('Rule SQL Query: ' + @cursor_sql_query);

            -- Menjalankan pernyataan SQL dinamis
            EXEC sp_executesql
                @cursor_sql_query,
                N'@product_id VARCHAR(50),
                  @rider_id VARCHAR(50),
                  @plan_id VARCHAR(50),
                  @owner_dob VARCHAR(100),
                  @insured_dob VARCHAR(100),
                  @owner_gender CHAR(1),
                  @insured_gender CHAR(1),
                  @payment_method VARCHAR(20),
                  @coverage_period_unit VARCHAR(20),
                  @coverage_period INT,
                  @up VARCHAR(20),
                  @cursor_error_message NVARCHAR(255),
                  @cursor_rule_name NVARCHAR(255),
                  @cursor_field_name VARCHAR(MAX),
                  @key_no INT,
                  @variable_name NVARCHAR(255),
                  @additional_benefit VARCHAR(50),
                  @policy_issue_date VARCHAR(50),
                  @premium_period VARCHAR(20),
                  @currency VARCHAR(20),
                  @premium_amount VARCHAR(50)',
                @product_id,
                @rider_id,
                @plan_id,
                @owner_dob,
                @insured_dob,
                @owner_gender,
                @insured_gender,
                @payment_method,
                @coverage_period_unit,
                @coverage_period,
                @up,
                @cursor_error_message,
                @cursor_rule_name,
                @cursor_field_name,
                @key_no,
                @variable_name,
                @additional_benefit,
                @policy_issue_date,
                @premium_period,
                @currency,
                @premium_amount;
        END TRY
        BEGIN CATCH
            PRINT('Error in ' + @cursor_rule_name + ': ' + ERROR_MESSAGE());
            PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(50)));
            PRINT('Error severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10)));
            PRINT('Error state: ' + CAST(ERROR_STATE() AS VARCHAR(10)));
            PRINT('Error procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
            PRINT('Error line: ' + CAST(ERROR_LINE() AS VARCHAR(10)));
        END CATCH;

        -- Baris berikutnya
        FETCH NEXT FROM rule_cursor INTO
            @cursor_field_name,
            @cursor_rule_condition,
            @cursor_rule_name,
            @cursor_error_message,
            @key_no,
            @variable_name;
    END;

    -- Menutup dan menghapus alokasi cursor
    CLOSE rule_cursor;
    DEALLOCATE rule_cursor;

    -- Menampilkan hasil yang memenuhi kondisi (result = 1)
    SELECT *
    FROM #temp_sp_getrule_results
    WHERE result = 1;
END;
GO

