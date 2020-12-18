-- create table
CREATE TABLE abc_retail.ABC_Retail(
OrderID int,
OrderDate date default null,
Order_ShippedDate date default null,
Order_Freight numeric(20,2),
Order_ShipCity varchar(255),
Order_ShipCountry varchar(255),
Order_UnitPrice numeric(20,2),
Order_Quantity numeric(20,2),
Order_Amount numeric(20,2),
ProductName varchar(255),
Employee_LastName varchar(255),
Employee_FirstName varchar(255),
Employee_Title varchar(255),
CompanyName varchar(255),
Customer_ContactName varchar(255),
Customer_City varchar(255),
Customer_Country varchar(255),
Customer_Phone varchar(255)
);

-- denormalize tables into table ABC_Retail
INSERT INTO abc_retail.ABC_Retail
(
    OrderID, OrderDate, Order_ShippedDate, Order_Freight, Order_ShipCity,
    Order_ShipCountry, Order_UnitPrice, Order_Quantity, Order_Amount,
    ProductName, Employee_LastName, Employee_FirstName, Employee_Title,
    CompanyName, Customer_ContactName, Customer_City, Customer_Country,
    Customer_Phone
)
(
    SELECT DISTINCT
        o.order_id, o.order_date, o.order_shippeddate, o.order_freight,
        o.order_shipcity, o.order_shipcountry,
        opp.order_unitprice, opp.order_quantity, opp.order_amount,
        opp.product_name,
        e.employee_lastname, e.employee_firstname, e.employee_title,
        cocu.company_name,
        cocu.customer_contactname, cocu.customer_city, cocu.customer_country,
        cocu.customer_phone
    FROM abc_retail.orders AS o
    JOIN abc_retail.employees as e
    ON o.employee_id = e.employee_id
    JOIN
    (
        SELECT DISTINCT
            cu.customer_id,
            co.company_name,
            cu.customer_contactname, cu.customer_city, cu.customer_country,
            cu.customer_phone
        FROM abc_retail.companys AS co
        JOIN abc_retail.customers AS cu
        ON co.company_id = cu.company_id
    ) AS cocu
    ON o.customer_id = cocu.customer_id
    JOIN 
    (
        SELECT DISTINCT
            op.order_id, op.order_unitprice, op.order_quantity, op.order_amount,
            p.product_name
        FROM abc_retail.order_products AS op
        JOIN abc_retail.products AS p
        ON op.product_id = p.product_id
    ) AS opp
    ON o.order_id = opp.order_id
);
