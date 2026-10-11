/*
==================================================================================
  DDL Script : Craete Gold Views 
==================================================================================
  Script Purpose :
      This script creates views for the Gold Layer in the data warehouse.
      The Gold layer represents the final dimension and fact tables (Star Schema )

      Each view performs transformations and combines data from the Silver layer 
      to produce a clean , enriched, and business- erady dataset.
  Usage :
      - These views can be queried directly for analytics and reporting.
==================================================================================
*/



--===================================================================
--	Create Dimension : 		GOLD_LAYER gold.dim.customer
--===================================================================



IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
  DROP VIEW gold.dim_customers:
GO
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER ( ORDER BY cst_id) AS customer_key,
	ci.cst_id AS Customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_material_status AS marital_status,
	CASE 
		WHEN ci.cst_gndr!='N/A' THEN ci.cst_gndr
		ELSE Coalesce(ca.gen,'N/A') END AS gender,
	ci.cst_create_date AS create_date,
	ca.bdate AS birth_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
on ci.cst_key=ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
on ci.cst_key=la.cid









--===================================================================
--	Create Dimenstion:		GOLD_LAYER gold.dim.product
--===================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
  DROP VIEW gold.dim_products:
GO
CREATE VIEW gold.dim_products as 
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key ) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
	
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
on pn.cat_id=pc.id
WHERE prd_end_dt IS NULL -- Filter out all historical data




--===================================================================
-- Create Dimension:			GOLD_LAYER gold.fact.sales
--===================================================================



IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
  DROP VIEW gold.fact_sales:
GO
CREATE VIEW gold.fact_sales as 
SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key ,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sls_price as price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
on sd.sls_prd_key=pr.product_number
LEFT JOIN gold.dim_customers AS cu
on sd.sls_cust_id=cu.Customer_id


