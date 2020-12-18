-- sql from sakai
select 
    year(OrderDate) as ThisYear
    ,[Order_ShipCountry] as Region
    ,[ProductName] as Product
    ,[Order_Amount] as Sales
into
    MyCube
from 
    ABC_Retail
where
    [Order_ShipCountry] in ('USA','Canada','UK')
    and [ProductName] in ('Chai','Tofu','Chocolade');
    

-- create table
CREATE TABLE abc_retail.MyCube(
    ThisYear year default null,
    Region varchar(255),
    Product varchar(255),
    Sales numeric(20,2)
);

-- Create MyCube table from the denormalized table
INSERT INTO abc_retail.MyCube
(
    ThisYear, Region, Product, Sales
)
SELECT
    year(OrderDate) as ThisYear
    ,Order_ShipCountry as Region
    ,ProductName as Product
    ,Order_Amount as Sales
FROM
    abc_retail.ABC_Retail
WHERE
    Order_ShipCountry in ('USA','Canada','UK')
    and ProductName in ('Chai','Tofu','Chocolade');
