# RetailX Sales and Customer Insights: Store Performance Analytics 
Project Overview  

RetailX, a growing retail chain, aims to analyze store performance, track customer purchases, and identify new customer trends across multiple locations. The goal is to create aggregated reports for:  

•	Weekly and monthly sales performance  
•	Identifying returning vs. new customers  
•	Assessing territory-based sales trends  
•	Tracking high-demand products  

This project uses SQL to extract, transform, and analyze sales data for decision-making.  

Dataset Description  

The dataset consists of multiple tables representing sales, store information, customer details, and location-based mapping. The key tables include:  

•	weekly_sales_data: Contains sales transactions at the store level on a weekly basis. 
•	monthly_sales_data: Aggregated monthly sales records per store.  
•	store_master: Store metadata including store ID, name, and contact details.  
•	store_address: Location details for each store.  
•	store_territory_mapping: Mapping of stores to regions and territories.  
•	customer_segments: Categorization of customers based on their purchasing behavior.  

Key SQL Queries and Their Purpose  

1. **Store-Level Weekly Sales Analytics** - Extracts weekly sales performance per store, including location details and customer segmentation.
2. **Monthly Store-Level Sales Analytics** - Aggregates sales at a monthly level to analyze broader sales trends.  
3. **Aggregated Weekly Sales Performance** - Computes total units sold and returned. - Identifies ordering stores, returning stores, and newly onboarded stores.  
4. **Identifying New Customers** - Finds new customers based on their first recorded purchase week.  
5. **Overall Store Sales Performance (Weekly & Monthly Combined)** - Creates a holistic view of store sales, combining weekly and monthly records.
   
Expected Outcomes  
•	Trend Analysis: Identify best-performing stores and products.  
•	Customer Insights: Track repeat purchases vs. new customers.  
•	Region-Based Performance: Understand which territories drive the most sales.  
•	Data-Driven Decision Making: Improve inventory planning and sales strategy.  
