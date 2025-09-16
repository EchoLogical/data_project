SELECT product_id,
       plan_id,
       plan_name,
       plan_type,
       NULL AS plan_base,
       NULL AS plan_premium_base,
       [status],
       NULL AS sequence_no
FROM dbo.plans
WHERE (plan_type = 'R')


select
    plan_id,
    plan_type
from plans
where product_id = 'MLC'

update plans
set plan_type = ''


select
    distinct benefit_name
from benefits
where benefit_id in (
    select pb.benefit_id from product_benefits pb where product_id = 'MLC'
)