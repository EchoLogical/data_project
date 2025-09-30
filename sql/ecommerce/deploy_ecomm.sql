alter table dbo.trx_product_policy_master
    add log_illus_id int
go

alter table dbo.trx_product_policy_master
    alter column product_plan_code varchar(51) null
go

