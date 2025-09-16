SELECT
    rf.field_name,
    rf.key_no,
    r.rule_condition,
    r.rule_name,
    r.error_message,
    rf.variable_name
FROM rules r
LEFT JOIN rule_field rf ON rf.rules_id = r.rule_id
WHERE r.product_id = 'DIGILIFE'
  AND (r.plan_id = NULL OR r.plan_id IS NULL)
  AND (r.rider_id = NULL OR r.rider_id IS NULL)
  AND r.isActive = 'AC'
  AND r.type_rules = 'isValidate'
  AND rf.is_rule  = 1

-- Usia Pemilik Polis
DECLARE
    @owner_dob varchar(max) = '2001-01-01'
SELECT
    'test' AS field_name,
    'DIGILIFE' AS product_id,
    NULL AS plan_id,
    NULL AS rider_id,
    CASE WHEN (dbo.fAge('NB', @owner_dob) < ) THEN 1 ELSE 0 END AS result,
    'test error msg' AS error_message,
    'Usia Pemilik Polis' AS rule_name;



