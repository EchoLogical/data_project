select p.id AS product_discovery_parameter_id,
       v.id AS product_discovery_value_id,
       c.id AS product_discovery_category_id,
       p.product_id,
       p2.product_name,
       c.is_range,
       v.value,
       v.value_min,
       v.value_max,
       c.category
from product_discovery_parameter p
         join product_discovery_value v on v.id = p.product_discovery_value_id
         join product_discovery_category c on c.id = v.product_discovery_category_id
         join products p2 on p.product_id = p2.product_id
where p.status = 1


and p.product_id = 'AVRSS'
