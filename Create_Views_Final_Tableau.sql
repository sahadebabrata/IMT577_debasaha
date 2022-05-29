
CREATE OR REPLACE SECURE VIEW VW_SALES_AMT_TARGET_YEARLY AS
SELECT
	ds."SourceStoreID" , ds."StoreNumber" , dd.YEAR , SUM(fsst."SalesTargetAmount") AS "StoreSalesTargetAmount"
FROM VW_FACT_SRCSALESTARGET fsst, VW_DIM_STORE ds, VW_DIM_CHANNEL dc,DIM_DATE dd
WHERE
	fsst."DimStoreID" = ds."DimStoreID"
	AND dc."DimChannelID" = fsst."DimChannelID" 
	AND dd.DATE_PKEY = fsst."DimTargetDateID" 
	AND ds."StoreNumber" <> '-1'
GROUP BY ds."SourceStoreID" , ds."StoreNumber" , dd.YEAR;


CREATE OR REPLACE SECURE VIEW VW_SALES_ACTUAL_YEARLY AS 
SELECT dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , dp."ProductType" , ds."SourceStoreID",  ds."StoreNumber" , dd.YEAR , 
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM VW_FACT_SALESACTUAL fsa, VW_DIM_STORE ds, VW_DIM_DATE dd, VW_DIM_PRODUCT dp, VW_DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" <> '-1'
GROUP BY dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dp."ProductType" , ds."SourceStoreID",  ds."StoreNumber" , dd.YEAR ;


CREATE OR REPLACE SECURE VIEW  VW_PRODUCT_SALES_QUANTITY_YEARLY AS 
SELECT dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dd.YEAR , 
SUM(fsa."SaleQuantity") AS TotalSaleQuantity
FROM VW_FACT_SALESACTUAL fsa, VW_DIM_STORE ds, VW_DIM_DATE dd, VW_DIM_PRODUCT dp, VW_DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" <> '-1'
GROUP BY dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dd.YEAR ;


CREATE OR REPLACE SECURE VIEW VW_TOTAL_REVENUE_MENS_WOMENS_CASUAL_YEARLY AS 
SELECT  YEAR, SUM("TotalSaleAmount") as "TotalYearlyRevenue"
FROM VW_SALES_ACTUAL_YEARLY  
WHERE "ProductType" in ('Men''s Casual', 'Women''s Casual')
GROUP BY YEAR;


CREATE OR REPLACE SECURE VIEW  VW_STORE_REVENUE_MENS_WOMENS_CASUAL_YEARLY AS 
SELECT "StoreNumber", YEAR, SUM("TotalSaleAmount") as "TotalCasualMenWomenSales"
FROM VW_SALES_ACTUAL_YEARLY  
WHERE "ProductType" in ('Men''s Casual', 'Women''s Casual')
GROUP BY "StoreNumber", YEAR;


CREATE OR REPLACE SECURE VIEW  VW_STORE_BONUS_ALLOCATION_YEARLY AS
SELECT a.* , ROUND((CASE WHEN a.YEAR = '2013' THEN a."PercentageRevenueContribution" * 500000
				  WHEN a.YEAR = '2014' THEN a."PercentageRevenueContribution" * 400000
				  END) , 2) as "BonusAllocation"
FROM 					
(select c2."StoreNumber", c2.YEAR, c2."TotalCasualMenWomenSales", c2."TotalCasualMenWomenSales" / c1."TotalYearlyRevenue" as "PercentageRevenueContribution"
FROM VW_TOTAL_REVENUE_MENS_WOMENS_CASUAL_YEARLY c1 JOIN VW_STORE_REVENUE_MENS_WOMENS_CASUAL_YEARLY c2 on c1.YEAR = c2.YEAR)a 
;


CREATE OR REPLACE SECURE VIEW VW_STORE_PRODUCT_SALES_TARGET_YEARLY AS
SELECT dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dd.YEAR , SUM(fpst."ProductTargetSalesQuanity") AS "TotalProductSalesTargetQuantity"
FROM VW_FACT_PRODUCTSALESTARGET fpst, VW_DIM_PRODUCT dp, VW_DIM_DATE dd
WHERE dp."DimProductID" = fpst."DimProductID" 
AND dd.DATE_PKEY = fpst."DimTargetDateID" 
GROUP BY dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dd.YEAR 
ORDER BY dd.YEAR ;


CREATE OR REPLACE SECURE VIEW VW_STORE_PERFORMANCE_LOC_WISE AS 
SELECT  dl."Region", dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."SourceStoreID",  ds."StoreNumber" , dd.YEAR , 
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM VW_FACT_SALESACTUAL fsa, VW_DIM_STORE ds, VW_DIM_DATE dd, VW_DIM_PRODUCT dp, VW_DIM_CHANNEL dc, VW_DIM_LOCATION dl 
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
and dl."DimLocationID" = ds."DimLocationID" 
AND ds."StoreNumber" <> '-1'
GROUP BY dl."Region" ,dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."SourceStoreID",  ds."StoreNumber" , dd.YEAR ;


CREATE OR REPLACE SECURE VIEW VW_STORE_AGG_SALES_BY_DAY AS
SELECT  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."SourceStoreID",  ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" ,dd.YEAR , dd.DAY_NUM_IN_WEEK, dd.DAY_NAME , dd.DAY_ABBREV , 
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM VW_FACT_SALESACTUAL fsa, VW_DIM_STORE ds, VW_DIM_DATE dd, VW_DIM_PRODUCT dp, VW_DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."SourceStoreID"  <> '-1'
GROUP BY  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."SourceStoreID", ds."StoreNumber" , 
dc."SourceChannelID" , dc."ChannelName" ,dd.YEAR , dd.DAY_NUM_IN_WEEK, dd.DAY_NAME , dd.DAY_ABBREV;


CREATE OR REPLACE SECURE VIEW VW_SALES_ACTUAL_MONTHLY AS 
SELECT ds."SourceStoreID",  ds."StoreNumber" , dd.MONTH_NUM_IN_YEAR, dd.MONTH_ABBREV, dd.DATE , 
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM VW_FACT_SALESACTUAL fsa, VW_DIM_STORE ds, VW_DIM_DATE dd, VW_DIM_PRODUCT dp, VW_DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" <> '-1'
GROUP BY ds."SourceStoreID",  ds."StoreNumber" , dd.MONTH_NUM_IN_YEAR, dd.MONTH_ABBREV, dd.DATE ;


CREATE OR REPLACE SECURE VIEW VW_STORE_SALES_DAILY AS
SELECT  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", ds."SourceStoreID" ,  ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" ,
dd.DATE, dd.FULL_DATE_DESC, dd.DAY_NUM_IN_WEEK, dd.DAY_NUM_IN_MONTH, dd.DAY_NUM_IN_YEAR, dd.DAY_NAME, dd.DAY_ABBREV, dd.WEEKDAY_IND, dd.US_HOLIDAY_IND, dd._HOLIDAY_IND, dd.MONTH_END_IND, dd.WEEK_BEGIN_DATE_NKEY, dd.WEEK_BEGIN_DATE, dd.WEEK_END_DATE_NKEY, dd.WEEK_END_DATE, dd.WEEK_NUM_IN_YEAR, dd.MONTH_NAME, dd.MONTH_ABBREV, dd.MONTH_NUM_IN_YEAR, dd.YEARMONTH, dd.QUARTER, dd.YEARQUARTER, dd.YEAR, dd.FISCAL_WEEK_NUM, dd.FISCAL_MONTH_NUM, dd.FISCAL_YEARMONTH, dd.FISCAL_QUARTER, dd.FISCAL_YEARQUARTER, dd.FISCAL_HALFYEAR, dd.FISCAL_YEAR ,
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM VW_FACT_SALESACTUAL fsa, VW_DIM_STORE ds, VW_DIM_DATE dd, VW_DIM_PRODUCT dp, VW_DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" <>'-1'
GROUP BY  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", ds."SourceStoreID" , ds."StoreNumber" , 
dc."SourceChannelID" , dc."ChannelName" , dd.DATE, dd.FULL_DATE_DESC, dd.DAY_NUM_IN_WEEK, dd.DAY_NUM_IN_MONTH, dd.DAY_NUM_IN_YEAR, dd.DAY_NAME, dd.DAY_ABBREV, dd.WEEKDAY_IND, dd.US_HOLIDAY_IND, dd._HOLIDAY_IND, dd.MONTH_END_IND, dd.WEEK_BEGIN_DATE_NKEY, dd.WEEK_BEGIN_DATE, dd.WEEK_END_DATE_NKEY, dd.WEEK_END_DATE, dd.WEEK_NUM_IN_YEAR, dd.MONTH_NAME, dd.MONTH_ABBREV, dd.MONTH_NUM_IN_YEAR, dd.YEARMONTH, dd.QUARTER, dd.YEARQUARTER, dd.YEAR, dd.FISCAL_WEEK_NUM, dd.FISCAL_MONTH_NUM, dd.FISCAL_YEARMONTH, dd.FISCAL_QUARTER, dd.FISCAL_YEARQUARTER, dd.FISCAL_HALFYEAR, dd.FISCAL_YEAR;



