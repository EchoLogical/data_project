select
    pb.product_id,
    b.benefit_id,
    b.benefit_name,
    pb.plan_id,
    pb.rider_id,
    pb.metadata
from product_benefits pb, benefits b
where pb.benefit_id = b.benefit_id
and product_id = 'MLC'
and pb.plan_id = 'MLC_PLATINUM'
order by b.benefit_name desc

update product_benefits
set metadata = '{"desc":"Rp 10.000.000"}'
where product_id = 'MLC'
  and plan_id = 'MLC_SILVER'
  and benefit_id in (5, 2011, 6)

update product_benefits
set metadata = '{"desc":"Rp 25.000.000"}'
where product_id = 'MLC'
  and plan_id = 'MLC_GOLD'
  and benefit_id in (5, 2011, 6)

update product_benefits
set metadata = '{"desc":"Rp 50.000.000"}'
where product_id = 'MLC'
and plan_id = 'MLC_PLATINUM'
and benefit_id in (5, 2011, 6)

update product_benefits
set metadata = '{"desc":"Rp 1.000.000/hari, maksimum 7 hari (per-perawatan) dan maksimum Rp 10.000.000 dalam 1 tahun"}'
where product_id = 'MLC'
  and plan_id = 'MLC_PLATINUM'
  and benefit_id in (7)

