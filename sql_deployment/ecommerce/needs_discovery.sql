CREATE TABLE dbo.product_discovery_category (
    id INT identity CONSTRAINT product_discovery_category_pk PRIMARY KEY
    ,category VARCHAR(255)
    ,is_range BIT DEFAULT 0 NOT NULL
    ,created_at DATETIME
    ,created_by VARCHAR(255)
    ,updated_at DATETIME
    ,updated_by VARCHAR(255)
    ,STATUS BIT DEFAULT 1 NOT NULL
    ,field_type VARCHAR(255)
    ,ref_tcode VARCHAR(255)
)
GO

CREATE TABLE dbo.product_discovery_value (
    id INT identity CONSTRAINT product_discovery_value_pk PRIMARY KEY
    ,value VARCHAR(255)
    ,created_at DATETIME
    ,created_by VARCHAR(255)
    ,updated_at DATETIME
    ,updated_by VARCHAR(255)
    ,STATUS BIT DEFAULT 1 NOT NULL
    ,product_discovery_category_id INT NOT NULL CONSTRAINT product_discovery_value_product_discovery_category_id_fk REFERENCES dbo.product_discovery_category ON UPDATE CASCADE ON DELETE CASCADE
    ,value_min FLOAT
    ,value_max FLOAT
)
GO

CREATE TABLE dbo.product_discovery_parameter (
    id INT identity CONSTRAINT product_discovery_parameter_pk PRIMARY KEY
    ,product_id VARCHAR(20) NOT NULL CONSTRAINT product_discovery_parameter_products_product_id_fk REFERENCES dbo.products
    ,STATUS BIT DEFAULT 1
    ,created_at DATETIME
    ,created_by VARCHAR(255)
    ,updated_at DATETIME
    ,updated_by VARCHAR(255)
    ,product_discovery_value_id INT CONSTRAINT product_discovery_parameter_product_discovery_value_id_fk REFERENCES dbo.product_discovery_value ON UPDATE CASCADE ON DELETE CASCADE
)
GO


