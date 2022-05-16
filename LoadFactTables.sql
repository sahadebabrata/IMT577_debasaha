/*****************************************
Course: IMT 577
Student: Debabrata Saha
Assignment: Module 6
Date: 05/07/2022
Description: Script for Loading of Fact tables from Staging & Dimension tables. 

*****************************************/

-- LOAD FACT_PRODUCTSALESTARGET
INSERT
  INTO
  FACT_PRODUCTSALESTARGET("DimProductID",
  "DimTargetDateID",
  "ProductTargetSalesQuanity")
(
  SELECT
    dp."DimProductID" ,
    dd.DATE_PKEY ,
    CAST(STDP.SALESQUANTITYTARGET / 365 AS INT) AS "DailyTarget"
  FROM
    STAGE_TARGET_DATA_PRODUCT stdp
  RIGHT JOIN DIM_DATE dd
ON
    stdp."YEAR" = dd."YEAR"
  JOIN DIM_PRODUCT dp ON
    dp."SourceProductID" = stdp.PRODUCTID
)


-- LOAD FACT_SRCSALESTARGET
INSERT
	INTO
	FACT_SRCSALESTARGET("DimStoreID",
	"DimResellerID",
	"DimChannelID",
	"DimTargetDateID",
	"SalesTargetAmount")
(
	SELECT
		DISTINCT 
		NVL(ds."DimStoreID", -1) ,
		NVL(dr."DimResellerID", -1) ,
		NVL(dc."DimChannelID", -1) ,
		dd.DATE_PKEY AS "DimTargetDateID",
		ROUND(stdc.TARGETSALESAMOUNT / 365 , 2) AS "SalesTargetAmount"
	FROM
		STAGE_TARGET_DATA_CRS stdc
	RIGHT JOIN DIM_DATE dd
ON
		stdc."YEAR" = dd."YEAR"
	LEFT JOIN DIM_STORE ds ON
		('Store Number ' || ds."StoreNumber") = stdc.TARGETNAME
	LEFT JOIN DIM_RESELLER dr ON
		stdc.TARGETNAME = (CASE
			WHEN dr."ResellerName" = 'Mississipi Distributors' THEN 'Mississippi Distributors'
			ELSE dr."ResellerName"
		END)
	JOIN DIM_CHANNEL dc ON
		REPLACE(dc."ChannelName",
		'-',
		'') = stdc.CHANNELNAME
)


--LOAD FACT_SALESACTUAL 
INSERT INTO FACT_SALESACTUAL ("DimProductID", "DimStoreID", "DimResellerID", "DimCustomerID", "DimChannelID", "DimSaleDateID", "DimLocationID", 
"SourceSalesHeaderID", "SourcesSalesDetailID", "SaleAmount", "SaleQuantity", "SaleUnitPrice", "SaleExtendedCost", "SaleTotalProfit" )
(
SELECT
	dp."DimProductID",
	NVL(ds."DimStoreID", -1) AS "DimStoreID",
	NVL(dr."DimResellerID", -1) AS "DimResellerID",
	NVL(dc."DimCustomerID", -1) AS "DimCustomerID",
	NVL(dch."DimChannelID", -1) AS "DimChannelID",
	dd.DATE_PKEY AS "DimSaleDateID",
	NVL(dl."DimLocationID", -1) AS "DimLocationID",
	sh.SALESHEADERID AS "SourceSalesHeaderID",
	sd.SALEDDETAILID AS "SourcesSalesDetailID",
	sd.SALESAMOUNT AS "SaleAmount",
	sd.SALESQUANTITY AS "SaleQuantity",
	(sd.SALESAMOUNT / sd.SALESQUANTITY) AS "SalesUnitPrice",
    (dp."ProductCost"  * sd.SALESQUANTITY) AS "SalesExtendedCost",
    (sd.SALESAMOUNT- (dp."ProductCost" * sd.SALESQUANTITY)) AS "SalesTotalProfit"
FROM
	STAGE_SALESDETAIL sd
JOIN STAGE_SALESHEADER sh ON
	sd.SALESHEADERID = sh.SALESHEADERID
JOIN DIM_PRODUCT dp ON
	sd.PRODUCTID = dp."SourceProductID"
JOIN DIM_CHANNEL dch ON
	TO_CHAR(sh.CHANNELID) = dch."SourceChannelID"
JOIN DIM_DATE dd ON
	sh."DATE" = dd."DATE"
LEFT JOIN DIM_STORE ds ON
	TO_CHAR(sh.STOREID) = ds."SourceStoreID"
LEFT JOIN DIM_RESELLER dr ON
	sh.RESELLERID = dr."SourceResellerID"
LEFT JOIN DIM_CUSTOMER dc ON
	sh.CUSTOMERID = dc."SourceCustomerID"
JOIN DIM_LOCATION dl ON
	(TO_CHAR(sh.STOREID) = dl."SourceLocationID"
		OR sh.CUSTOMERID = dl."SourceLocationID"
		OR sh.RESELLERID = dl."SourceLocationID")
)