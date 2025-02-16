1. Store-Level Weekly Sales Analytics

DROP TABLE IF EXISTS retail_analytics_temp.store_weekly_sales;

CREATE TABLE retail_analytics_temp.store_weekly_sales AS
SELECT DISTINCT
    a.store_id, 
    a.week_date,
    c.store_name,
    d.address, d.city, d.country, d.zip_code, d.state,
    e.territory_name, e.region_name,
    f.customer_segment,
    SUM(a.units_sold) AS total_units_sold
FROM retail_analytics_temp.weekly_sales_data a
LEFT JOIN retail_analytics_tier1.store_master c ON a.store_id = c.store_id
LEFT JOIN retail_analytics_tier1.store_address d ON a.store_id = d.store_id
LEFT JOIN (SELECT DISTINCT zip, territory_name, region_name FROM retail_analytics_tier1.store_territory_mapping) e 
ON d.zip_code = e.zip
LEFT JOIN retail_analytics_temp.customer_segments f ON a.customer_id = f.customer_id
WHERE a.product_name LIKE 'HIGH-DEMAND PRODUCT X'
GROUP BY 1,2,3,4,5,6,7,8,9,10,11;

2. Monthly Store-Level Sales Analytics

DROP TABLE IF EXISTS retail_analytics_temp.store_monthly_sales;

CREATE TABLE retail_analytics_temp.store_monthly_sales AS
SELECT DISTINCT
    a.store_id, 
    a.month_date,
    c.store_name,
    d.address, d.city, d.country, d.zip_code, d.state,
    e.territory_name, e.region_name,
    f.customer_segment,
    SUM(a.units_sold) AS total_units_sold
FROM retail_analytics_temp.monthly_sales_data a
LEFT JOIN retail_analytics_tier1.store_master c ON a.store_id = c.store_id
LEFT JOIN retail_analytics_tier1.store_address d ON a.store_id = d.store_id
LEFT JOIN (SELECT DISTINCT zip, territory_name, region_name FROM retail_analytics_tier1.store_territory_mapping) e 
ON d.zip_code = e.zip
LEFT JOIN retail_analytics_temp.customer_segments f ON a.customer_id = f.customer_id
WHERE a.product_name LIKE 'HIGH-DEMAND PRODUCT X'
GROUP BY 1,2,3,4,5,6,7,8,9,10,11;

3. Aggregated Weekly Sales Performance

DROP TABLE IF EXISTS retail_analytics_temp.aggregated_weekly_sales;

CREATE TABLE retail_analytics_temp.aggregated_weekly_sales AS
SELECT 
    a.week_date,
    SUM(a.units_sold) AS units_sold, 
    ABS(SUM(a.units_returned)) AS units_returned,
    SUM(a.units_sold) - ABS(SUM(a.units_returned)) AS net_sales,
    COUNT(DISTINCT a.store_id) AS total_stores,
    b.ordering_stores,
    c.returning_stores,
    d.new_stores
FROM
(SELECT *, 
    CASE WHEN units < 0 THEN units ELSE 0 END AS units_returned,
    CASE WHEN units > 0 THEN units ELSE 0 END AS units_sold
 FROM retail_analytics_temp.weekly_sales_data) a
LEFT JOIN 
(SELECT COUNT(DISTINCT store_id) AS ordering_stores, week_date
 FROM retail_analytics_temp.weekly_sales_data
 WHERE units_sold > 0
 GROUP BY week_date) b 
ON a.week_date = b.week_date
LEFT JOIN 
(SELECT COUNT(DISTINCT store_id) AS returning_stores, week_date
 FROM retail_analytics_temp.weekly_sales_data
 WHERE units_returned > 0
 GROUP BY week_date) c 
ON a.week_date = c.week_date
LEFT JOIN 
(SELECT week_date, COUNT(DISTINCT store_id) AS new_stores
 FROM 
 (SELECT store_id, MIN(week_date) AS first_purchase_week
 FROM retail_analytics_temp.weekly_sales_data
 GROUP BY store_id) new_stores_data
 GROUP BY week_date) d 
ON a.week_date = d.week_date;


4. Identifying New Customers

DROP TABLE IF EXISTS retail_analytics_temp.new_customers_weekly;

CREATE TABLE retail_analytics_temp.new_customers_weekly AS
SELECT DISTINCT 
    a.customer_id,
    c.customer_name,
    d.customer_address,
    f.customer_segment
FROM
(SELECT customer_id, MIN(week_date) AS first_purchase_week
 FROM retail_analytics_temp.weekly_sales_data
 GROUP BY customer_id
 HAVING first_purchase_week = (SELECT MAX(week_date) FROM retail_analytics_temp.weekly_sales_data)) a
LEFT JOIN retail_analytics_tier1.customer_master c ON a.customer_id = c.customer_id
LEFT JOIN retail_analytics_tier1.customer_address d ON a.customer_id = d.customer_id
LEFT JOIN retail_analytics_temp.customer_segments f ON a.customer_id = f.customer_id;


5. Overall Sales Performance (Combining Weekly & Monthly)

DROP TABLE IF EXISTS retail_analytics_temp.store_sales_performance;

CREATE TABLE retail_analytics_temp.store_sales_performance AS
SELECT 
    COALESCE(a.store_id, b.store_id) AS store_id,
    COALESCE(a.week_date, b.month_date) AS sales_date,
    COALESCE(a.store_name, b.store_name) AS store_name,
    COALESCE(a.address, b.address) AS address,
    COALESCE(a.city, b.city) AS city,
    COALESCE(a.zip_code, b.zip_code) AS zip_code,
    COALESCE(a.state, b.state) AS state,
    COALESCE(a.territory_name, b.territory_name) AS territory_name,
    COALESCE(a.region_name, b.region_name) AS region_name,
    COALESCE(a.customer_segment, b.customer_segment) AS customer_segment,
    a.total_units_sold AS weekly_units,
    b.total_units_sold AS monthly_units
FROM retail_analytics_temp.store_weekly_sales a
FULL OUTER JOIN retail_analytics_temp.store_monthly_sales b 
ON a.store_id = b.store_id
AND a.week_date = b.month_date;
