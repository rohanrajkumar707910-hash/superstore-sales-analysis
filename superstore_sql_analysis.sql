create database superstore;

USE superstore;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
  row_id        INT,
  order_id      VARCHAR(20),
  order_date    DATE,
  ship_date     DATE,
  ship_mode     VARCHAR(20),
  customer_id   VARCHAR(15),
  customer_name VARCHAR(50),
  segment       VARCHAR(15),
  country       VARCHAR(30),
  city          VARCHAR(30),
  state         VARCHAR(30),
  postal_code   VARCHAR(10),
  region        VARCHAR(10),
  product_id    VARCHAR(20),
  category      VARCHAR(20),
  sub_category  VARCHAR(20),
  product_name  VARCHAR(200),
  sales         DECIMAL(10,4),
  quantity      INT,
  discount      DECIMAL(4,2),
  profit        DECIMAL(10,4)
);

-- 1. View Sample Data
select * from orders limit 10;

-- 2. Get Overall Business Summary
select
count(*) as Total_orders,
round(sum(sales),2) as Total_sales,
round(sum(profit),2) as Total_profit,
round(avg(sales), 2) as Avg_sales
from orders;

-- 3. Find All Unique Categories and Regions
select distinct region from orders;
select distinct category from orders;
select distinct segment from orders;
select distinct ship_mode from orders;

-- 4. Filter Orders by a Specific Region
select * from orders
where region = 'west'
limit 10;

-- 5. Identify Top Loss-Making Orders
select
order_id,
product_name,
sales,
profit 
from orders
where profit < 0
order by profit asc
limit 10 ; 

-- 6. Find Orders with High Discount
select
order_id,
product_name,
profit,
discount
from orders
where discount > 0.4
order by discount desc
limit 10 ; 

-- 7. Get All Orders from a Specific Year
select * from orders
where year(order_date) = 2023;

-- 8. Compare Sales and Profit Across All Regions
select 
Region,
count(*) as Total_orders,
round(sum(sales), 2) as Total_sales,
round(sum(profit), 2) as Total_profit
from orders
group by region
order by Total_sales desc;

-- 9. Analyze Performance of Each Product Category
select
category,
count(*) Total_orders,
round(sum(sales),2) Total_sales,
round(sum(profit),2) Total_profit,
round(sum(profit)/sum(sales)*100, 2) as Total_profit_margin
from orders
group by category
order by Total_Profit desc;

-- 10. Rank Sub-Categories from Most Loss to Most Profit
select 
sub_category,
round(sum(sales),2) Total_sales,
round(sum(profit),2) Total_profit
from orders
group by sub_category
order by Total_profit asc;

-- 11. Track Monthly Sales Trend Over the Year
select 
year(order_date) as year,
month(order_date) as Month_num,
monthname(order_date) as Month_name,
round(sum(sales),2) as total_sales
from orders
group by year, month_num, Month_name
order by year, month_num;

-- 12. Find Top 10 Customers by Total Sales
select
customer_name,
segment,
round(sum(sales),2) as Total_sales,
round(sum(profit),2) as Total_profit
from orders
group by customer_name, segment
order by Total_sales desc
limit 10;

-- 13. Show Only Regions with Profit Above 50K
select
region,
round(sum(profit),2) as Total_profit
from orders
group by region
having Total_profit > 50000
order by Total_profit desc;

-- 14. Measure How Discount Affects Profit
SELECT 
  CASE 
    WHEN discount = 0     THEN '0 - No Discount'
    WHEN discount <= 0.20 THEN '1 - Low (1-20%)'
    WHEN discount <= 0.40 THEN '2 - Medium (21-40%)'
    ELSE                       '3 - High (40%+)'
  END                    AS Discount_Range,
  COUNT(*)               AS Total_Orders,
  ROUND(AVG(profit), 2)  AS Avg_Profit,
  ROUND(SUM(profit), 2)  AS Total_Profit
FROM orders
GROUP BY Discount_Range
ORDER BY Discount_Range;

-- 15. Compare Delivery Speed Across Shipping Modes
SELECT 
  ship_mode,
  COUNT(*)                                        AS Total_Orders,
  ROUND(AVG(DATEDIFF(ship_date, order_date)), 1)  AS Avg_Delivery_Days,
  ROUND(SUM(sales), 2)                            AS Total_Sales
FROM orders
GROUP BY ship_mode
ORDER BY Avg_Delivery_Days;
