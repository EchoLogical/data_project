SELECT * from dbo.product_benefits  --faisal
/**
    Basic_Premium x
    Sum_Insured_Basic x
    Modal_Premium x
    Annualized_Premium x
    Total_Premium
 */
SELECT * from dbo.formulas WHERE product_id = 'MLC'  --faisal & anggih
SELECT * from dbo.plans  WHERE product_id = 'MLC'
SELECT * from dbo.benefits --faisal
SELECT * from dbo.product_media -- faisal
SELECT * from dbo.product_parameters  --faisal
SELECT * from dbo.rate_tables  WHERE product_id = 'MLC' --faisal
SELECT * from dbo.ref_trate where product_id = 'MLC' --faisal
SELECT * from dbo.ref_trate_detail
where rate_code like '%MLC%' --faisal
SELECT * from dbo.riders  --faisal

SELECT * from dbo.rules   --faisal
SELECT * from dbo.rule_field   -- ini kita ga perlu setting lagi,, karena setiap product baru form ui tetap harus buat.

select * from rule_field
where field_name = 'r_premi_tahunan'


SELECT
    product_id,
    field_name,
    variable_name,
    COUNT(*) AS duplicate_count
FROM rule_field
GROUP BY
    product_id,
    field_name,
    variable_name
HAVING COUNT(*) > 1;

select * from ref_trate_detail;
select * from formulas
where product_id = 'MLC';

EXEC sp_calculate_premium_fix
     @input_id			=0,
     @product_id		= 'MLC',
     @plan_id			= 'MLC_PLATINUM',
     @plan_type			= 'B',	--BASIC  --RIDER
     @plan_option		= '',
     @age				= 0,
     @dob				='2007-01-20',
     @gender			= '',
     @payment_method	= '',
     @premium_period	=0,
     @premium_mode		='',
     @coverage_period	=0,
     @up				=0,
     @currency			= '',
     @plan_member_type	= '',
     @occupation_class	='',
     @mode				=NULL,
     @partner_code		='ECCOMERCE'
