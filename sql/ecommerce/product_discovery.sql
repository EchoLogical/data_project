select * from product_discovery_category;
select * from product_discovery_value;
select * from product_discovery_parameter;


select * from product_discovery_category
where category = 'Usia'

SELECT
    value,
    COUNT(*) as duplicate_count
FROM product_discovery_value
WHERE value is not null
GROUP BY value
HAVING COUNT(*) > 1;

SELECT
    value_min,
    value_max,
    COUNT(*) as duplicate_count
FROM product_discovery_value
WHERE value_min is not null
AND value_max is not null
GROUP BY value_min, value_max
HAVING COUNT(*) > 1;