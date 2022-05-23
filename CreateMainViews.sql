--VIEW FOR STORE-CHANNEL TARGETS 
CREATE OR REPLACE SECURE VIEW VW_STORE_SALES_TARGET AS
SELECT
	ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" , dd."YEAR" , SUM(fsst."SalesTargetAmount") AS "StoreSalesTargetAmount"
	--ChannelID is necessary since we are measuring Store sales, which means we need to exclude Reseller targets 
FROM
	FACT_SRCSALESTARGET fsst,
	DIM_STORE ds, DIM_CHANNEL dc,
	DIM_DATE dd
WHERE
	fsst."DimStoreID" = ds."DimStoreID"
	AND dc."DimChannelID" = fsst."DimChannelID" 
	AND ds."StoreNumber" IN ('5', '8')
	AND dd.DATE_PKEY = fsst."DimTargetDateID" 
GROUP BY ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" , dd."YEAR";

-- VIEW FOR AGGREGATE SALES DATA  
CREATE OR REPLACE SECURE VIEW VW_STORE_AGG_SALES_DATA AS
SELECT  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" , dd.YEAR, 
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM FACT_SALESACTUAL fsa, DIM_STORE ds, DIM_DATE dd, DIM_PRODUCT dp, DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" IN ('5', '8')
GROUP BY  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" , dd.YEAR;



---VIEW FOR PRODUCT SALES TARGET
CREATE OR REPLACE SECURE VIEW VW_STORE_PRODUCT_SALES_TARGET AS
SELECT dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dd."YEAR" , SUM(fpst."ProductTargetSalesQuanity") AS "TotalProductSalesTargetQuantity"
FROM FACT_PRODUCTSALESTARGET fpst, DIM_PRODUCT dp, DIM_DATE dd
WHERE dp."DimProductID" = fpst."DimProductID" 
AND dd.DATE_PKEY = fpst."DimTargetDateID" 
GROUP BY dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory", dd."YEAR" 
ORDER BY dd."YEAR" ;


-- VIEW FOR PRODUCT AGGREGATE SALES BY DAY OF WEEK   
CREATE OR REPLACE SECURE VIEW VW_STORE_AGG_SALES_BY_DAY AS
SELECT  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" , dd.DAY_NUM_IN_WEEK, dd.DAY_NAME , dd.DAY_ABBREV , 
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM FACT_SALESACTUAL fsa, DIM_STORE ds, DIM_DATE dd, DIM_PRODUCT dp, DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" IN ('5', '8')
GROUP BY  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."StoreNumber" , 
dc."SourceChannelID" , dc."ChannelName" , dd.DAY_NUM_IN_WEEK, dd.DAY_NAME , dd.DAY_ABBREV;


-- VIEW FOR PRODUCT SALES DAILY
CREATE OR REPLACE SECURE VIEW VW_STORE_SALES_DAILY AS
SELECT  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."StoreNumber" , dc."SourceChannelID" , dc."ChannelName" ,
dd."DATE", dd.FULL_DATE_DESC, dd.DAY_NUM_IN_WEEK, dd.DAY_NUM_IN_MONTH, dd.DAY_NUM_IN_YEAR, dd.DAY_NAME, dd.DAY_ABBREV, dd.WEEKDAY_IND, dd.US_HOLIDAY_IND, dd."_HOLIDAY_IND", dd.MONTH_END_IND, dd.WEEK_BEGIN_DATE_NKEY, dd.WEEK_BEGIN_DATE, dd.WEEK_END_DATE_NKEY, dd.WEEK_END_DATE, dd.WEEK_NUM_IN_YEAR, dd.MONTH_NAME, dd.MONTH_ABBREV, dd.MONTH_NUM_IN_YEAR, dd.YEARMONTH, dd.QUARTER, dd.YEARQUARTER, dd."YEAR", dd.FISCAL_WEEK_NUM, dd.FISCAL_MONTH_NUM, dd.FISCAL_YEARMONTH, dd.FISCAL_QUARTER, dd.FISCAL_YEARQUARTER, dd.FISCAL_HALFYEAR, dd.FISCAL_YEAR ,
SUM(fsa."SaleQuantity") AS "TotalSaleQuantity", SUM(fsa."SaleAmount") AS "TotalSaleAmount", SUM(fsa."SaleExtendedCost") AS "TotalSaleExtendedCost", 
SUM(fsa."SaleTotalProfit") AS "TotalSaleProfit"
FROM FACT_SALESACTUAL fsa, DIM_STORE ds, DIM_DATE dd, DIM_PRODUCT dp, DIM_CHANNEL dc
WHERE fsa."DimStoreID" = ds."DimStoreID" 
AND fsa."DimSaleDateID" = dd.DATE_PKEY 
AND dp."DimProductID" = fsa."DimProductID" 
AND dc."DimChannelID" = fsa."DimChannelID" 
AND ds."StoreNumber" IN ('5', '8')
GROUP BY  dp."SourceProductID" , dp."ProductName", dp."SourceProductCategoryID" , dp."ProductCategory" , ds."StoreNumber" , 
dc."SourceChannelID" , dc."ChannelName" , dd."DATE", dd.FULL_DATE_DESC, dd.DAY_NUM_IN_WEEK, dd.DAY_NUM_IN_MONTH, dd.DAY_NUM_IN_YEAR, dd.DAY_NAME, dd.DAY_ABBREV, dd.WEEKDAY_IND, dd.US_HOLIDAY_IND, dd."_HOLIDAY_IND", dd.MONTH_END_IND, dd.WEEK_BEGIN_DATE_NKEY, dd.WEEK_BEGIN_DATE, dd.WEEK_END_DATE_NKEY, dd.WEEK_END_DATE, dd.WEEK_NUM_IN_YEAR, dd.MONTH_NAME, dd.MONTH_ABBREV, dd.MONTH_NUM_IN_YEAR, dd.YEARMONTH, dd.QUARTER, dd.YEARQUARTER, dd."YEAR", dd.FISCAL_WEEK_NUM, dd.FISCAL_MONTH_NUM, dd.FISCAL_YEARMONTH, dd.FISCAL_QUARTER, dd.FISCAL_YEARQUARTER, dd.FISCAL_HALFYEAR, dd.FISCAL_YEAR;
