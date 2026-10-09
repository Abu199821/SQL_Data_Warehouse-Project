/*
========================================================================
Quality Checks
========================================================================
*/
-- Data Standardization & Consistency 
SELECT DISTINCT
  gen
FROM silver.erp_cust_az12;

--==============================================================
--  Checking 'silver.erp_loc_a101'
--==============================================================
-- Data Standardization & Consistency
SELECT DISTINCT
  cntry
FROM silver.erp
