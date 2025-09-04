select
    pdv.id,
    pdv.value
from product_discovery_value pdv
join product_discovery_category pdc on pdv.product_discovery_category_id = pdc.id
where pdc.id = 3
order by value asc;

select * from ref_tcode
where code_type = 'FILTER_PREF_DISCOVERY'
order by sequence_no asc;


select
    pdv.id,
    pdv.value,
    pdp.product_id,
    p.product_name
from product_discovery_parameter pdp
left join product_discovery_value pdv on pdp.product_discovery_value_id = pdv.id
left join product_discovery_category pdc on pdv.product_discovery_category_id = pdc.id
left join products p on pdp.product_id = p.product_id
where pdc.id = 3
order by product_id asc;

select
    value
from product_discovery_value pdv
left join product_discovery_category pdc on pdv.product_discovery_category_id = pdc.id
where pdv.id not in (
    select
        pdv.id
    from product_discovery_parameter pdp
    join product_discovery_value pdv on pdp.product_discovery_value_id = pdv.id
    join product_discovery_category pdc on pdv.product_discovery_category_id = pdc.id
    where pdc.id = 3
) and value is not null
and pdc.id = 3

/**
  Santunan Kematian: av simple life, MLC, ADL
 */

select * from product_discovery_value pdv
where pdv.value like '%santunan kematian%'
