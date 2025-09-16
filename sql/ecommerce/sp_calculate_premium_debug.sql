-- Pastikan temp tables dari eksekusi sebelumnya dibersihkan
DROP TABLE IF EXISTS #dataProducts;
DROP TABLE IF EXISTS #dataPlans;
DROP TABLE IF EXISTS #TempRiderCalculation;


DECLARE
    @input_id bigint=0,
    @product_id VARCHAR(20) = 'MLC',
    @plan_id VARCHAR(200) = 'MLC_GOLD',
    @plan_type varchar(25) = 'B', --BASIC  --RIDER
    @plan_option varchar(25) = '',
    @age INT = 0,
    @dob DATETIME='2007-01-20',
    @gender CHAR(1) = '',
    @payment_method VARCHAR(20) = '',
    @premium_period INT=0,
    @premium_mode varchar(25)='',
    @coverage_period INT=0,
    @up DECIMAL(18, 2)=0,
    @currency VARCHAR(20) = '',
    @plan_member_type varchar(1) = '',
    @occupation_class varchar(25)='',
    @mode varchar(25)='',
    @partner_code varchar(25)='ECCOMERCE'

SET NOCOUNT ON;
DECLARE
    @policy_year INT=0,
    @risk_type varchar(1),
    @rule_condition NVARCHAR(MAX),
    @error_message NVARCHAR(max),
    @sql NVARCHAR(MAX),
    @life_premium_amount DECIMAL(18, 2) = 0,
    @default_benefit_amount DECIMAL(18, 2) = 0,
    @default_sum_insured DECIMAL(18, 2) = 0,
    @default_plan_option varchar(25) = NULL,
    @age_rule varchar(2),
    @uniqueID varchar(500)= NULL,
    @illustration_id bigint=0,
    @process_table varchar(1)='',
    @result INT;


-- Buat tabel untuk menyimpan urutan
DECLARE @PlanOrder TABLE
(
   plan_id    VARCHAR(50),
   sort_order INT
)

-- Split string dan masukkan ke @PlanOrder dengan urutan
INSERT INTO @PlanOrder(plan_id, sort_order)
SELECT LTRIM(RTRIM(Split.a.value('.', 'VARCHAR(100)'))) AS plan_id,
       ROW_NUMBER() OVER (ORDER BY (SELECT 1))          AS sort_order
FROM (SELECT CAST('<X>' + REPLACE(@plan_id, ',', '</X><X>') + '</X>' AS XML) AS Data) AS A
         CROSS APPLY Data.nodes('/X') AS Split(a)

IF @mode <> '' and @mode = 'D'
    BEGIN
        DELETE ref_tillustration_plan where illustration_id = @input_id
        --AND plan_code IN (SELECT plan_id FROM @PlanOrder)
        --By 1 plan
        --DELETE ref_tillustration_plan where illustration_id = @input_id AND plan_code = @plan_id
        IF NOT EXISTS(SELECT illustration_id FROM ref_tillustration_plan where illustration_id = @input_id)
            BEGIN
                DELETE ref_tillustration where illustration_id = @input_id
            END
    END
ELSE
    BEGIN
        IF EXISTS(SELECT illustration_id FROM ref_tillustration_plan where illustration_id = @input_id)
            BEGIN
                DELETE ref_tillustration_plan
                where illustration_id = @input_id
                  AND plan_code NOT IN (SELECT plan_id FROM @PlanOrder)
            END

        SELECT TOP 1 product_name,
                     product_category,
                     product_type,
                     product_channel,
                     product_status,
                     sequence_no
        INTO #dataProducts
        FROM products
        where product_status = 'AC'
          AND product_id = @product_id

        SELECT p.plan_id,
               p.product_id,
               p.coverage_period,
               p.payment_period,
               p.charge_period,
               p.charge_year,
               p.coverage_year,
               p.rider_list,
               p.source_plan_code,
               p.source_plan_option,
               p.destination_plan_code,
               p.map_plan_code,
               p.service_code,
               p.parameter,
               p.[status],
               p.plan_name,
               p.plan_type,
               p.isFormula,
               p.default_benefit_amount,
               p.default_sum_insured,
               p.plan_exc_mutual,
               p.plan_base
        INTO #dataPlans
        FROM plans p
                 JOIN @PlanOrder po ON p.plan_id = po.plan_id
        WHERE p.product_id = @product_id
          AND p.[status] = 'AC'
        ORDER BY po.sort_order

        SELECT TOP 1 @age_rule = rule_condition
        from rules
        where product_id = @product_id
          AND isActive = 'AC'
          AND type_rules = 'plan'
        SELECT @age = dbo.fAge(@age_rule, @dob)

        DECLARE @modal_factor DECIMAL(10, 4) = 0, @annual_factor DECIMAL(10, 4) = 0, @payment_method_name VARCHAR(50)=NULL;
        SELECT TOP 1 @modal_factor = COALESCE(factor_value, 0),
                     @annual_factor = annualize_value,
                     @payment_method_name = payment_method_name
        FROM new_modal_factors
        WHERE product_id = @product_id
          AND payment_method = @premium_mode;

        DECLARE @plan_plan_id VARCHAR(20) =NULL, @plan_product_id VARCHAR(20) =NULL, @plan_coverage_period INT=0, @plan_payment_period INT=0,
            @plan_charge_period INT=0, @plan_charge_year INT=0, @plan_coverage_year INT=0, @plan_rider_list VARCHAR(50) =NULL,
            @plan_source_plan_code VARCHAR(50) =NULL, @plan_source_plan_option VARCHAR(50) =NULL, @plan_destination_plan_code VARCHAR(50) =NULL,
            @plan_map_plan_code VARCHAR(50) =NULL, @plan_service_code VARCHAR(50) =NULL, @plan_parameter VARCHAR(MAX) =NULL,
            @plan_status VARCHAR(2) =NULL, @plan_plan_name VARCHAR(50) =NULL, @plan_plan_type VARCHAR(1) =NULL, @plan_isFormula VARCHAR(1) =NULL,
            @plan_default_benefit_amount DECIMAL(18, 2), @plan_default_sum_insured DECIMAL(18, 2), @mutual_plan_code VARCHAR(20), @plan_base VARCHAR(2);

        -- Eksekusi semua formula dari tabel
        DECLARE @formula_name NVARCHAR(100), @formula_expr NVARCHAR(MAX), @formula_result DECIMAL(18, 2);
        DECLARE @formula_plan_id NVARCHAR(100);

        DECLARE @TempRiderCalculationId int = 0;
        CREATE TABLE #TempRiderCalculation
        (
            TempRiderCalculationId   int,
            PRODUCT_ID               VARCHAR(20),
            PLAN_ID                  VARCHAR(20),
            SUM_INSURED_RIDER        DECIMAL(18, 2) DEFAULT 0,
            ANNUALIZED_PREMIUM_RIDER DECIMAL(18, 2) DEFAULT 0,
            MODAL_PREMIUM_RIDER      DECIMAL(18, 2) DEFAULT 0
        );

-- Siapkan variabel untuk hasil kalkulasi
        DECLARE @SUM_INSURED DECIMAL(18, 2) = 0;
        DECLARE @BASIC_PREMIUM DECIMAL(18, 2) = 0;
        DECLARE @MODAL_PREMIUM DECIMAL(18, 2) = 0;
        DECLARE @PREMIUM_MODAL VARCHAR = 0;
        DECLARE @ANNUALIZED_PREMIUM DECIMAL(18, 2) = 0;

        DECLARE @BASIC_PREMIUM_RIDER DECIMAL(18, 2) = 0;
        DECLARE @MODAL_PREMIUM_RIDER DECIMAL(18, 2) = 0;
        DECLARE @ANNUALIZED_PREMIUM_RIDER DECIMAL(18, 2) = 0;
        DECLARE @TOTAL_PREMIUM DECIMAL(18, 2) = 0;
        DECLARE @RIDER1_PREMIUM DECIMAL(18, 2) = 0;
        DECLARE @RIDER2_PREMIUM DECIMAL(18, 2) = 0;
        DECLARE @MODAL_VALUE DECIMAL(18, 2) = 0;

        DECLARE @SUM_INSURED_RIDER DECIMAL(18, 2) = 0;
        DECLARE @ANNUALIZED_PREMIUM_RIDER1 DECIMAL(18, 2) = 0;
        DECLARE @MODAL_PREMIUM_RIDER1 DECIMAL(18, 2) = 0;

        DECLARE plan_cursor CURSOR FOR
            SELECT plan_id,
                   product_id,
                   coverage_period,
                   payment_period,
                   charge_period,
                   charge_year,
                   coverage_year,
                   rider_list,
                   source_plan_code,
                   source_plan_option,
                   destination_plan_code,
                   map_plan_code,
                   service_code,
                   parameter,
                   [status],
                   plan_name,
                   plan_type,
                   isFormula,
                   default_benefit_amount,
                   default_sum_insured,
                   plan_exc_mutual,
                   plan_base

            FROM #dataPlans
        OPEN plan_cursor;

        FETCH NEXT FROM plan_cursor INTO @plan_plan_id, @plan_product_id, @plan_coverage_period,
            @plan_payment_period, @plan_charge_period, @plan_charge_year, @plan_coverage_year,
            @plan_rider_list, @plan_source_plan_code, @plan_source_plan_option, @plan_destination_plan_code,
            @plan_map_plan_code, @plan_service_code, @plan_parameter, @plan_status, @plan_plan_name,
            @plan_plan_type, @plan_isFormula, @plan_default_benefit_amount, @plan_default_sum_insured,
            @mutual_plan_code, @plan_base;

        WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @plan_type = @plan_plan_type
                PRINT (' ')
                PRINT (@input_id)
                PRINT ('@plan_id : ' + @plan_plan_id)
                PRINT ('@plan_isFormula : ' + @plan_isFormula)
                DECLARE @basic_rate DECIMAL(10, 4), @rider1_rate DECIMAL(10, 4) = 0, @rider2_rate DECIMAL(10, 4) = 0;
                IF @plan_isFormula = 'Y'
                    BEGIN
                        PRINT 'fRate params:';
                        PRINT '  product_id='       + ISNULL(CAST(@plan_product_id    AS varchar(100)), '<NULL>');
                        PRINT '  plan_id='          + ISNULL(CAST(@plan_plan_id      AS varchar(100)), '<NULL>');
                        PRINT '  currency='         + ISNULL(CAST(@currency          AS varchar(100)), '<NULL>');
                        PRINT '  age='              + ISNULL(CAST(@age               AS varchar(100)), '<NULL>');
                        PRINT '  gender='           + ISNULL(CAST(@gender            AS varchar(100)), '<NULL>');
                        PRINT '  occupation_class=' + ISNULL(CAST(@occupation_class  AS varchar(100)), '<NULL>');
                        PRINT '  plan_option='      + ISNULL(CAST(@plan_option       AS varchar(100)), '<NULL>');
                        PRINT '  premium_period='   + ISNULL(CAST(@premium_period    AS varchar(100)), '<NULL>');
                        PRINT '  policy_year='      + ISNULL(CAST(@policy_year       AS varchar(100)), '<NULL>');
                        PRINT '  risk_type='        + ISNULL(CAST(@risk_type         AS varchar(100)), '<NULL>');
                        PRINT '  plan_member_type=' + ISNULL(CAST(@plan_member_type  AS varchar(100)), '<NULL>');
                        PRINT '  payment_method='   + ISNULL(CAST(@payment_method    AS varchar(100)), '<NULL>');
                        PRINT '  coverage_period='  + ISNULL(CAST(@coverage_period   AS varchar(100)), '<NULL>');


                        SELECT @basic_rate =
                               dbo.fRate(@plan_product_id, @plan_plan_id, @currency, @age, @gender, @occupation_class,
                                         @plan_option, @premium_period, @policy_year, @risk_type, @plan_member_type,
                                         @payment_method, @coverage_period, '', '', '')
                        SET @process_table = 'Y'

                        PRINT ('fRateParam : ' + CAST(@plan_product_id AS VARCHAR) + ',' +
                               CAST(@plan_plan_id AS VARCHAR) + ',' + CAST(@currency AS VARCHAR) + ',' +
                               CAST(@age AS VARCHAR) + ',' +
                               CAST(@gender AS VARCHAR) + ',' + CAST(@occupation_class AS VARCHAR) + ',' +
                               CAST(@plan_option AS VARCHAR) + ',' +
                               CAST(@premium_period AS VARCHAR) + ',' + CAST(@policy_year AS VARCHAR) + ',' +
                               CAST(@risk_type AS VARCHAR) + ',' + CAST(@plan_member_type AS VARCHAR) + ',' +
                               CAST(@payment_method AS VARCHAR) + ',' + CAST(@coverage_period AS VARCHAR))

                        PRINT ('@@basic_rate : ' + CAST(@basic_rate AS VARCHAR))
                    END
                ELSE
                    BEGIN
                        print ('NOT USED FORMULA AND PREPARE WITH PLAN_SETUP')
                        SET @process_table = 'Y'
                    END

                IF @basic_rate IS NULL OR @basic_rate = 0.0000
                    BEGIN
                        RAISERROR ('rate tidak ditemukan', 16, 1);
                        SET @process_table = 'N'
                        RETURN;
                    END

                DECLARE formula_cursor CURSOR FOR
                    SELECT plan_id, formula_name, formula_expression
                    FROM formulas
                    WHERE product_id = @product_id
                      AND plan_id = @plan_plan_id
                    ORDER BY plan_id, sequence_no;

                OPEN formula_cursor;
                FETCH NEXT FROM formula_cursor INTO @formula_plan_id, @formula_name, @formula_expr;
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        PRINT ('@formula_expr : ' + @formula_expr)

                        DECLARE @replaced_expr NVARCHAR(MAX) = @formula_expr;
                        DECLARE @tempRiderCount int = 0;
                        DECLARE @targetAnnual NVARCHAR(100) = '@ANNUALIZED_PREMIUM_RIDER';
                        DECLARE @targetSumInsured NVARCHAR(100) = '@SUM_INSURED_RIDER';
                        DECLARE @pos INT = 1;
                        DECLARE @countTargetAnnual INT = 0;
                        DECLARE @countTargetSumInsured INT = 0;
                        DECLARE @index INT = 1;

                        -- Simpan data rider tanpa primary key
                        DECLARE @RiderValues TABLE
                                             (
                                                 rn                       INT,
                                                 SUM_INSURED_RIDER        DECIMAL(18, 2),
                                                 ANNUALIZED_PREMIUM_RIDER DECIMAL(18, 2)
                                             );

                        ---- Masukkan data dari temp table
                        INSERT INTO @RiderValues(rn, SUM_INSURED_RIDER, ANNUALIZED_PREMIUM_RIDER)
                        SELECT ROW_NUMBER() OVER (ORDER BY TempRiderCalculationId),
                               SUM_INSURED_RIDER,
                               ANNUALIZED_PREMIUM_RIDER
                        FROM #TempRiderCalculation;
                        SELECT @tempRiderCount = COUNT(*) FROM @RiderValues

                        PRINT ('@tempRiderCount : ' + CAST(@tempRiderCount AS VARCHAR))

                        WHILE CHARINDEX(@targetAnnual, @formula_expr, @pos) > 0
                            BEGIN
                                SET @countTargetAnnual += 1;
                                SET @pos = CHARINDEX(@targetAnnual, @formula_expr, @pos) + LEN(@targetAnnual);
                            END

                        PRINT 'Jumlah ' + @targetAnnual + ' ditemukan: ' + CAST(@countTargetAnnual AS VARCHAR);

                        SET @pos = 1;
                        WHILE CHARINDEX(@targetSumInsured, @formula_expr, @pos) > 0
                            BEGIN
                                SET @countTargetSumInsured += 1;
                                SET @pos = CHARINDEX(@targetSumInsured, @formula_expr, @pos) + LEN(@targetSumInsured);
                            END

                        PRINT 'Jumlah ' + @targetSumInsured + ' ditemukan: ' + CAST(@countTargetSumInsured AS VARCHAR);

                        ---PROCESSING REPLACE TARGET FORMULA

                        SET @index = 1;

                        DECLARE @rnReplace INT,
                            @SUM_INSURED_RIDER_Replace DECIMAL(18, 2),
                            @ANNUALIZED_PREMIUM_RIDER_Replace DECIMAL(18, 2);

                        DECLARE @beforeReplaced_expr VARCHAR(MAX) = @replaced_expr;
                        DECLARE replace_cursor CURSOR FOR
                            SELECT SUM_INSURED_RIDER, ANNUALIZED_PREMIUM_RIDER FROM #TempRiderCalculation
                        --ORDER BY rn

                        OPEN replace_cursor;
                        FETCH NEXT FROM replace_cursor INTO @SUM_INSURED_RIDER_Replace, @ANNUALIZED_PREMIUM_RIDER_Replace;
                        WHILE @@FETCH_STATUS = 0
                            BEGIN
                                PRINT ('STATUS : ' + CAST(@rnReplace AS VARCHAR) + ', ' +
                                       CAST(@SUM_INSURED_RIDER_Replace AS VARCHAR) + ', ' +
                                       CAST(@ANNUALIZED_PREMIUM_RIDER_Replace AS VARCHAR));
                                SET @replaced_expr =
                                        REPLACE(@replaced_expr, @targetSumInsured + CAST(@index AS VARCHAR),
                                                CAST(@SUM_INSURED_RIDER_Replace AS VARCHAR));
                                PRINT ('1. REPLACE @targetSumInsured ' + CAST(@targetSumInsured AS VARCHAR) +
                                       CAST(@index AS VARCHAR) + ' ' + CAST(@SUM_INSURED_RIDER_Replace AS VARCHAR));

                                SET @replaced_expr = REPLACE(@replaced_expr, @targetAnnual + CAST(@index AS VARCHAR),
                                                             CAST(@ANNUALIZED_PREMIUM_RIDER_Replace AS VARCHAR));
                                PRINT ('1. REPLACE @targetAnnual ' + CAST(@targetAnnual AS VARCHAR) +
                                       CAST(@index AS VARCHAR) + ' ' +
                                       CAST(@ANNUALIZED_PREMIUM_RIDER_Replace AS VARCHAR));
                                SET @index += 1;
                                FETCH NEXT FROM replace_cursor INTO @SUM_INSURED_RIDER_Replace, @ANNUALIZED_PREMIUM_RIDER_Replace;
                            END
                        CLOSE replace_cursor;
                        DEALLOCATE replace_cursor;

                        PRINT ('@beforeReplaced_expr = @replaced_expr : ' + @beforeReplaced_expr + '=' + @replaced_expr)
                        IF @beforeReplaced_expr = @replaced_expr
                            BEGIN
                                DECLARE replace_cursor1 CURSOR FOR
                                    SELECT SUM_INSURED_RIDER, ANNUALIZED_PREMIUM_RIDER FROM #TempRiderCalculation
                                --ORDER BY rn
                                OPEN replace_cursor1;
                                FETCH NEXT FROM replace_cursor1 INTO @SUM_INSURED_RIDER_Replace, @ANNUALIZED_PREMIUM_RIDER_Replace;
                                WHILE @@FETCH_STATUS = 0
                                    BEGIN
                                        SET @replaced_expr =
                                                REPLACE(@replaced_expr, @targetSumInsured + CAST(@index AS VARCHAR),
                                                        CAST(@SUM_INSURED_RIDER_Replace AS VARCHAR));
                                        PRINT ('2. REPLACE @targetSumInsured ' + CAST(@targetSumInsured AS VARCHAR) +
                                               CAST(@index AS VARCHAR) + ' ' +
                                               CAST(@SUM_INSURED_RIDER_Replace AS VARCHAR));

                                        SET @replaced_expr =
                                                REPLACE(@replaced_expr, @targetAnnual + CAST(@index AS VARCHAR),
                                                        CAST(@ANNUALIZED_PREMIUM_RIDER_Replace AS VARCHAR));
                                        PRINT ('2. REPLACE @targetAnnual ' + CAST(@targetAnnual AS VARCHAR) +
                                               CAST(@index AS VARCHAR) + ' ' +
                                               CAST(@ANNUALIZED_PREMIUM_RIDER_Replace AS VARCHAR));

                                        FETCH NEXT FROM replace_cursor1 INTO @SUM_INSURED_RIDER_Replace, @ANNUALIZED_PREMIUM_RIDER_Replace;
                                    END
                                CLOSE replace_cursor1;
                                DEALLOCATE replace_cursor1;
                            END
                        ---END PROCESS REPLACE TARGET FORMULA

                        PRINT ('Total index : ' + CAST(@index AS VARCHAR))
                        DECLARE @i INT = 1;
                        WHILE @i <= 3--@countTargetAnnual + @countTargetSumInsured
                            BEGIN
                                SET @replaced_expr = REPLACE(@replaced_expr, @targetSumInsured + CAST(@i AS VARCHAR),
                                                             CAST(0 AS VARCHAR));

                                SET @replaced_expr = REPLACE(@replaced_expr, @targetAnnual + CAST(@i AS VARCHAR),
                                                             CAST(0 AS VARCHAR));
                                SET @i += 1;
                            END

                        PRINT ('AFTER REPLACE: ' + @replaced_expr);

                        DECLARE @RATE DECIMAL(10, 4);

                        SET @sql = N'SET @result = ' + @replaced_expr;--@formula_expr;

                        EXEC sp_executesql @sql,
                             N'@SUM_INSURED DECIMAL(18,2), @MODAL_PREMIUM DECIMAL(18,2),
                             @UP DECIMAL(18,2), @RATE DECIMAL(10,4),
                             @ANNUAL_FACTOR DECIMAL(10,4), @MODAL_FACTOR DECIMAL(10,4),
                             @BASIC_PREMIUM DECIMAL(18,2), @RIDER1_PREMIUM DECIMAL(18,2),
                             @RIDER2_PREMIUM DECIMAL(18,2), @TOTAL_PREMIUM DECIMAL(18,2),
                             @ANNUALIZED_PREMIUM DECIMAL(18,2), @MODAL_VALUE DECIMAL(18,2),
                             @SUM_INSURED_RIDER DECIMAL(18,2),
                             @PAYMENT_METHOD  VARCHAR(20),
                             @PREMIUM_MODE  VARCHAR(20),
                             @PLAN_ID VARCHAR(2),
                             @ANNUALIZED_PREMIUM_RIDER1 DECIMAL(18,2),
                             @MODAL_PREMIUM_RIDER1 DECIMAL(18,2),
                             @result DECIMAL(18,2) OUTPUT',

                            -- ?? Binding variabel (input/output)
                             @SUM_INSURED = @up,
                             @MODAL_PREMIUM = @MODAL_PREMIUM,
                             @UP = @up,
                             @RATE = @basic_rate, -- ? Tambahkan ini!
                             @ANNUAL_FACTOR = @annual_factor,
                             @MODAL_FACTOR = @modal_factor,
                             @BASIC_PREMIUM = @BASIC_PREMIUM,
                             @RIDER1_PREMIUM = @RIDER1_PREMIUM,
                             @RIDER2_PREMIUM = @RIDER2_PREMIUM,
                             @TOTAL_PREMIUM = @TOTAL_PREMIUM,
                             @ANNUALIZED_PREMIUM = @ANNUALIZED_PREMIUM,
                             @MODAL_VALUE = @MODAL_VALUE,
                             @SUM_INSURED_RIDER = @SUM_INSURED_RIDER,
                             @PAYMENT_METHOD = @payment_method,
                             @PREMIUM_MODE = @premium_mode,
                             @PLAN_ID = @plan_plan_id,
                             @ANNUALIZED_PREMIUM_RIDER1 = @ANNUALIZED_PREMIUM_RIDER1,
                             @MODAL_PREMIUM_RIDER1 = @MODAL_PREMIUM_RIDER1,
                             @result = @formula_result OUTPUT;

                        IF @plan_plan_id = @formula_plan_id
                            BEGIN
                                PRINT ('MASUK SINI : ' + @formula_name)
                                PRINT (@RATE)
                                IF @formula_name = 'Sum_Insured_Basic' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    SET @SUM_INSURED = @formula_result;

                                PRINT ('PLAN : ' + @plan_plan_id)
                                PRINT ('FORMULA_PLAN : ' + @formula_plan_id)
                                PRINT ('@formula_result : ' + CAST(@formula_result AS VARCHAR))

                                IF @formula_name = 'Basic_Premium' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        SET @BASIC_PREMIUM = @formula_result;
                                    END
                                IF @formula_name = 'Modal_Premium' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        SET @MODAL_PREMIUM = @formula_result;
                                    END
                                IF @formula_name = 'Annualized_Premium' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        SET @ANNUALIZED_PREMIUM = @formula_result;
                                    END
                                IF @formula_name = 'Modal_Value' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        SET @MODAL_VALUE = @formula_result;
                                    END

                                --IF @plan_plan_type = 'R'
                                --BEGIN
                                PRINT ('@formula_expr : ' + @formula_expr)
                                PRINT ('@replaced_expr : ' + @replaced_expr)
                                IF @formula_name LIKE 'Sum_Insured_Rider%' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        PRINT ('SINI Sum_Insured_Rider =========================================================')
                                        SET @SUM_INSURED_RIDER = @formula_result;
                                        PRINT ('@SUM_INSURED_RIDER : ' + CAST(@SUM_INSURED_RIDER AS VARCHAR))
                                        PRINT ('@ANNUALIZED_PREMIUM_RIDER1 : ' +
                                               CAST(@ANNUALIZED_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@MODAL_PREMIUM_RIDER1 : ' + CAST(@MODAL_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@TOTAL_PREMIUM : ' + CAST(@TOTAL_PREMIUM AS VARCHAR))
                                    END

                                IF @formula_name LIKE 'Annualized_Premium_rider%' AND
                                   @plan_plan_id = @formula_plan_id AND @plan_product_id = @product_id
                                    BEGIN
                                        PRINT ('SINI Annualized_Premium_rider =========================================================')
                                        SET @ANNUALIZED_PREMIUM_RIDER1 = @formula_result;
                                        PRINT ('@SUM_INSURED_RIDER : ' + CAST(@SUM_INSURED_RIDER AS VARCHAR))
                                        PRINT ('@ANNUALIZED_PREMIUM_RIDER1 : ' +
                                               CAST(@ANNUALIZED_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@MODAL_PREMIUM_RIDER1 : ' + CAST(@MODAL_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@TOTAL_PREMIUM : ' + CAST(@TOTAL_PREMIUM AS VARCHAR))
                                    END

                                IF @formula_name LIKE 'Modal_Premium_rider%' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        PRINT ('SINI Modal_Premium_rider =========================================================')
                                        SET @MODAL_PREMIUM_RIDER1 = @formula_result;
                                        PRINT ('@SUM_INSURED_RIDER : ' + CAST(@SUM_INSURED_RIDER AS VARCHAR))
                                        PRINT ('@ANNUALIZED_PREMIUM_RIDER1 : ' +
                                               CAST(@ANNUALIZED_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@MODAL_PREMIUM_RIDER1 : ' + CAST(@MODAL_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@TOTAL_PREMIUM : ' + CAST(@TOTAL_PREMIUM AS VARCHAR))
                                    END
                                --END

                                IF @formula_name = 'Total_Premium' AND @plan_plan_id = @formula_plan_id AND
                                   @plan_product_id = @product_id
                                    BEGIN
                                        PRINT ('SINI Total_Premium =========================================================')
                                        --(@BASIC_PREMIUM+@ANNUALIZED_PREMIUM_RIDER1+@ANNUALIZED_PREMIUM_RIDER2*@MODAL_FACTOR)*@ANNUAL_FACTOR
                                        PRINT (' ')
                                        PRINT ('COBA =========================================================')
                                        PRINT ('@BASIC_PREMIUM : ' + CAST(@BASIC_PREMIUM AS VARCHAR))
                                        --PRINT('@ANNUALIZED_PREMIUM_RIDER1 : ' + CAST(@ANNUALIZED_PREMIUM_RIDER1 AS VARCHAR))
                                        --PRINT('@ANNUALIZED_PREMIUM_RIDER2 : ' + CAST(@ANNUALIZED_PREMIUM_RIDER2 AS VARCHAR))
                                        PRINT ('@MODAL_FACTOR : ' + CAST(@MODAL_FACTOR AS VARCHAR))
                                        PRINT ('@ANNUAL_FACTOR : ' + CAST(@ANNUAL_FACTOR AS VARCHAR))
                                        --SELECT ((@BASIC_PREMIUM+0+0)*@MODAL_FACTOR)*@ANNUAL_FACTOR AS TOTAL
                                        PRINT ('COBA =========================================================')
                                        PRINT (' ')
                                        SET @TOTAL_PREMIUM = @formula_result;
                                        PRINT ('@SUM_INSURED_RIDER : ' + CAST(@SUM_INSURED_RIDER AS VARCHAR))
                                        PRINT ('@ANNUALIZED_PREMIUM_RIDER1 : ' +
                                               CAST(@ANNUALIZED_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@MODAL_PREMIUM_RIDER1 : ' + CAST(@MODAL_PREMIUM_RIDER1 AS VARCHAR))
                                        PRINT ('@TOTAL_PREMIUM : ' + CAST(@TOTAL_PREMIUM AS VARCHAR))
                                    END

                                IF @plan_plan_type = 'R'
                                    BEGIN
                                        IF EXISTS(SELECT plan_id
                                                  FROM #TempRiderCalculation
                                                  WHERE product_id = @product_id
                                                    AND plan_id = @formula_plan_id
                                                    AND plan_id = @plan_plan_id)
                                            BEGIN
                                                PRINT ('UPDATE @SUM_INSURED_RIDER : ' + CAST(@SUM_INSURED_RIDER AS VARCHAR))
                                                UPDATE #TempRiderCalculation
                                                SET SUM_INSURED_RIDER        = @SUM_INSURED_RIDER,
                                                    ANNUALIZED_PREMIUM_RIDER = @ANNUALIZED_PREMIUM_RIDER1,
                                                    MODAL_PREMIUM_RIDER      = @MODAL_PREMIUM_RIDER1
                                                WHERE product_id = @product_id
                                                  AND plan_id = @formula_plan_id
                                                  AND plan_id = @plan_plan_id
                                            END
                                        ELSE
                                            BEGIN
                                                PRINT ('INSERT @SUM_INSURED_RIDER : ' + CAST(@SUM_INSURED_RIDER AS VARCHAR))
                                                INSERT INTO #TempRiderCalculation
                                                VALUES (@TempRiderCalculationId, @product_id, @plan_plan_id,
                                                        @SUM_INSURED_RIDER, @ANNUALIZED_PREMIUM_RIDER1,
                                                        @MODAL_PREMIUM_RIDER1);
                                                SET @TempRiderCalculationId = @TempRiderCalculationId + 1;
                                            END
                                    END

                            END
                        ELSE
                            BEGIN
                                SELECT @premium_mode = premium_mode,
                                       @modal_premium = modal_premium,
                                       @basic_premium = premium_basic,
                                       @annualized_premium = annualized_premium
                                from ref_tillustration
                                where illustration_id = @input_id
                            END

                        FETCH NEXT FROM formula_cursor INTO @formula_plan_id, @formula_name, @formula_expr;
                    END
                CLOSE formula_cursor;
                DEALLOCATE formula_cursor;

                IF @process_table = 'Y'
                    BEGIN

                        IF EXISTS(SELECT illustration_id
                                  FROM ref_tillustration
                                  WHERE illustration_id = @input_id
                                    AND partner_code = @partner_code
                                    AND product_code = @product_id)
                            BEGIN
                                --Update Table illustration
                                UPDATE ref_tillustration
                                SET premium_mode=@premium_mode,
                                    total_premium=@total_premium,
                                    modal_premium=@modal_premium,
                                    premium_basic=@basic_premium,
                                    annualized_premium=@annualized_premium,
                                    premium_period=@premium_period,
                                    coverage_period=CASE
                                                        WHEN @coverage_period <> 0 THEN @coverage_period
                                                        ELSE coverage_period END,
                                    currency=@currency,
                                    acceptance_date=getdate(),
                                    updated_date=getdate(),
                                    updated_by=@partner_code
                                WHERE illustration_id = @input_id
                                SELECT @illustration_id = illustration_id
                                from ref_tillustration
                                WHERE illustration_id = @input_id
                            END
                        ELSE
                            BEGIN
                                INSERT INTO ref_tillustration (illustration_no, partner_code, agent_code, product_code,
                                                               package_code, owner_id,
                                                               insured_id, insured_relationship, currency, premium_mode,
                                                               total_premium, modal_premium, premium_basic,
                                                               annualized_premium, premium_period, coverage_period,
                                                               purpose_of_insurance, purpose_of_insurance_other,
                                                               [status], expired_date, acceptance_date, disclaimer,
                                                               disclaimer_ipaddress, created_date,
                                                               created_by, updated_date, updated_by)
                                SELECT 'ILL' + CAST(1 AS VARCHAR),
                                       @partner_code,
                                       'agent_code',
                                       @product_id,
                                       'NULL',
                                       0,
                                       0,
                                       NULL,
                                       @currency,
                                       @payment_method,
                                       @TOTAL_PREMIUM,
                                       @MODAL_PREMIUM,
                                       @BASIC_PREMIUM,
                                       @ANNUALIZED_PREMIUM,
                                       @premium_period,
                                       @coverage_period,
                                       'BLM',
                                       'BLM_TAU',
                                       'IN',
                                       DATEADD(DAY, 1, GETDATE()),
                                       NULL,
                                       NULL,
                                       NULL,
                                       GETDATE(),
                                       @partner_code,
                                       GETDATE(),
                                       @partner_code;
                                SELECT @illustration_id = @@IDENTITY
                                SET @input_id = @illustration_id
                            END
                    END

                IF @mutual_plan_code <> ''
                    BEGIN
                        IF EXISTS(SELECT plan_code
                                  FROM ref_tillustration_plan
                                  WHERE illustration_id = @illustration_id AND plan_code = @mutual_plan_code)
                            BEGIN
                                DELETE
                                FROM ref_tillustration_plan
                                WHERE illustration_id = @illustration_id AND plan_code = @mutual_plan_code
                            END
                    END
                --IF @plan_type ='B'
                --BEGIN
                --	IF EXISTS(SELECT plan_code FROM ref_tillustration_plan WHERE illustration_id=@illustration_id AND plan_code <> @plan_plan_id)
                --	BEGIN
                --		DELETE FROM ref_tillustration_plan WHERE illustration_id=@illustration_id AND plan_code <> @plan_plan_id
                --	END
                --END

                IF @process_table = 'Y'
                    BEGIN
                        DECLARE @BASIC_PREMIUM_PLAN DECIMAL(18, 2) = @BASIC_PREMIUM;
                        DECLARE @MODAL_PREMIUM_PLAN DECIMAL(18, 2) = @MODAL_PREMIUM;
                        DECLARE @ANNUALIZED_PREMIUM_PLAN DECIMAL(18, 2) = @ANNUALIZED_PREMIUM;
                        DECLARE @SUM_INSURED_PLAN DECIMAL(18, 2) = @SUM_INSURED;

                        IF EXISTS(SELECT PLAN_ID
                                  FROM #TempRiderCalculation
                                  WHERE PLAN_ID = @plan_plan_id AND PRODUCT_ID = @product_id)
                            BEGIN
                                SELECT @BASIC_PREMIUM_PLAN = 0,
                                       @MODAL_PREMIUM_PLAN = MODAL_PREMIUM_RIDER,
                                       @ANNUALIZED_PREMIUM_PLAN = ANNUALIZED_PREMIUM_RIDER,
                                       @SUM_INSURED_PLAN = SUM_INSURED_RIDER
                                FROM #TempRiderCalculation
                                WHERE PLAN_ID = @plan_plan_id
                                  AND PRODUCT_ID = @product_id

                            END

                        IF EXISTS(SELECT plan_code, illustration_id
                                  FROM ref_tillustration_plan
                                  WHERE plan_code = @plan_plan_id
                                    AND created_by = @partner_code
                                    AND plan_type = @plan_type
                                    AND illustration_id = @illustration_id)
                            BEGIN
                                --	CREATE TABLE #TempRiderCalculation (
                                --	TempRiderCalculationId int,
                                --	PRODUCT_ID VARCHAR(20),
                                --	PLAN_ID VARCHAR(20),
                                --	SUM_INSURED_RIDER DECIMAL(18,2) DEFAULT 0,
                                --	ANNUALIZED_PREMIUM_RIDER DECIMAL(18,2) DEFAULT 0,
                                --	MODAL_PREMIUM_RIDER DECIMAL(18,2) DEFAULT 0
                                --);

                                UPDATE ref_tillustration_plan
                                SET sum_insured=COALESCE(@SUM_INSURED_PLAN, 0),
                                    benefit_amount=COALESCE(@plan_default_benefit_amount, 0),
                                    plan_option=@plan_option,
                                    premium_amount=@BASIC_PREMIUM_PLAN,
                                    modal_premium=@MODAL_PREMIUM_PLAN,
                                    annualized_premium=@ANNUALIZED_PREMIUM_PLAN,
                                    life_premium_amount=@life_premium_amount,
                                    plan_member_type=@plan_member_type,
                                    coverage_period=@coverage_period
                                WHERE plan_code = @plan_plan_id
                                  AND created_by = @partner_code
                                  AND plan_type = @plan_type
                                  AND illustration_id = @illustration_id

                            END
                        ELSE
                            BEGIN
                                INSERT INTO ref_tillustration_plan
                                (illustration_id, client_id, plan_type, plan_code, plan_member_type, sum_insured,
                                 plan_option, premium_amount, modal_premium, annualized_premium, reguler_top_up,
                                 coverage_period, life_premium_amount,
                                 created_date, created_by, updated_date, updated_by)
                                SELECT @illustration_id,
                                       0,
                                       @plan_type,
                                       @plan_plan_id,
                                       @plan_member_type,
                                       @SUM_INSURED_PLAN,
                                       @plan_option,
                                       @BASIC_PREMIUM_PLAN,
                                       @MODAL_PREMIUM_PLAN,
                                       @ANNUALIZED_PREMIUM_PLAN,
                                       0 reguler_top_up,
                                       @coverage_period,
                                       @life_premium_amount,
                                       getdate(),
                                       @partner_code,
                                       getdate(),
                                       @partner_code;
                            END
                    END

                --IF @mode<>'' and @mode = 'D'
                --BEGIN
                --	DELETE ref_tillustration where illustration_id = @input_id
                --	DELETE ref_tillustration_plan where illustration_id = @input_id
                --END

                FETCH NEXT FROM plan_cursor INTO @plan_plan_id, @plan_product_id, @plan_coverage_period,
                    @plan_payment_period, @plan_charge_period, @plan_charge_year, @plan_coverage_year,
                    @plan_rider_list, @plan_source_plan_code, @plan_source_plan_option, @plan_destination_plan_code,
                    @plan_map_plan_code, @plan_service_code, @plan_parameter, @plan_status, @plan_plan_name,
                    @plan_plan_type, @plan_isFormula, @plan_default_benefit_amount, @plan_default_sum_insured,
                    @mutual_plan_code, @plan_base;
            END

        CLOSE plan_cursor;
        DEALLOCATE plan_cursor;

        -- Output
        SELECT 'CALCULATE_ILLUS'                AS MODEL,
               @illustration_id                 AS LOG_ID,
               COALESCE(@SUM_INSURED, 0)        AS SUM_INSURED_BASIC,
               COALESCE(@BASIC_PREMIUM, 0)      AS PREMIUM_BASIC,
               COALESCE(@MODAL_PREMIUM, 0)      AS MODAL_PREMIUM,
               COALESCE(@ANNUALIZED_PREMIUM, 0) AS ANNUALIZED_PREMIUM,
               COALESCE(@TOTAL_PREMIUM, 0)      AS TOTAL_PREMIUM,
               @plan_option                     AS PLAN_OPTION,
               @coverage_period                 AS COVERAGE_PERIOD,
               COALESCE(@premium_period, 0)        PREMIUM_PERIOD;

        SELECT 'CALCULATE_RIDER' AS MODEL,
               PRODUCT_ID,
               PLAN_ID,
               SUM_INSURED_RIDER,
               ANNUALIZED_PREMIUM_RIDER,
               MODAL_PREMIUM_RIDER
        FROM #TempRiderCalculation
        DROP TABLE #dataProducts
        DROP TABLE #dataPlans
        DROP TABLE #TempRiderCalculation
    END


