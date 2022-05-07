-- LOAD THE DIMENSIONAL TABLES:

--LOAD DIM_PRODUCT
INSERT
	INTO
	DIM_PRODUCT(
	"SourceProductID",
	"SourceProductTypeID",
	"SourceProductCategoryID",
	"ProductName",
	"ProductType",
	"ProductCategory",
	"ProductRetailPrice",
	"ProductWholesalePrice",
	"ProductCost",
	"ProductRetailProfit",
	"ProductWholesaleUnitProfit",
	"ProductProfitMarginUnitPercent")
(SELECT
	sp.PRODUCTID ,
	sp.PRODUCTTYPEID ,
	spc.PRODUCTCATEGORYID,
	sp.PRODUCT ,
	spt.PRODUCTTYPE ,
	spc.PRODUCTCATEGORY ,
	sp.PRICE ,
	sp.WHOLESALEPRICE ,
	sp.COST ,
	(sp.PRICE - sp.COST) AS "ProductRetailProfit",
	(sp.WHOLESALEPRICE - sp.COST) AS "ProductWholesaleUnitProfit",
	((sp.WHOLESALEPRICE - sp.COST) / sp.WHOLESALEPRICE) * 100 AS "ProductProfitMarginUnitPercent"
FROM
	STAGE_PRODUCT sp,
	STAGE_PRODUCT_TYPE spt,
	STAGE_PRODUCT_CATEGORY spc
WHERE
	sp.PRODUCTTYPEID = spt.PRODUCTTYPEID
	AND spt.PRODUCTCATEGORYID = spc.PRODUCTCATEGORYID);


--LOAD DIM_LOCATION
INSERT
	INTO
	DIM_LOCATION (
  "SourceLocationID" ,
	"PostalCode" ,
	"Address" ,
	"City" ,
	"Region" ,
	"Country")
	(
	SELECT
		CUSTOMERID AS "SourceLocationID",
		POSTALCODE,
		ADDRESS,
		CITY,
		STATEPROVINCE ,
		COUNTRY
	FROM
		STAGE_CUSTOMER
UNION
	SELECT
		'STORE' || STOREID AS "SourceLocationID",
		POSTALCODE,
		ADDRESS,
		CITY,
		STATEPROVINCE,
		COUNTRY
	FROM
		STAGE_STORE
UNION
	SELECT
		RESELLERID AS "SourceLocationID",
		POSTALCODE,
		ADDRESS,
		CITY,
		STATEPROVINCE ,
		COUNTRY
	FROM
		STAGE_RESELLER);


--LOAD DIM_RESELLER
INSERT
	INTO
	DIM_RESELLER(
  "DimLocationID",
	"SourceResellerID" ,
	"ResellerName",
	"ContactName",
	"PhoneNumber",
	"Email")
  (
	SELECT
		dl."DimLocationID" AS "DimLocationID",
		RESELLERID ,
		RESELLERNAME ,
		CONTACT ,
		PHONENUMBER ,
		EMAILADDRESS
	FROM
		STAGE_RESELLER sr,
		DIM_LOCATION dl
	WHERE
		sr.RESELLERID = dl."SourceLocationID" 
  );


-- LOAD DIM_CUSTOMER
INSERT
	INTO
	DIM_CUSTOMER(
  "DimLocationID" ,
	"SourceCustomerID",
	"FullName" ,
	"FirstName",
	"LastName" ,
	"Gender",
	"EmailAddress",
	"PhoneNumber"
)
(
	SELECT
		dl."DimLocationID" AS "DimLocationID",
		CUSTOMERID ,
		FIRSTNAME || ' ' || LASTNAME ,
		FIRSTNAME ,
		LASTNAME ,
		GENDER ,
		EMAILADDRESS ,
		PHONENUMBER
	FROM
		STAGE_CUSTOMER sc,
		DIM_LOCATION dl
	WHERE
		sc.CUSTOMERID = dl."SourceLocationID"
);

--LOAD DIM_STORE
INSERT
	INTO
	DIM_STORE(
  "DimLocationID" ,
	"SourceStoreID" ,
	"StoreNumber" ,
	"StoreManager" 
)
(
	SELECT
		dl."DimLocationID" ,
		STOREID ,
		STORENUMBER ,
		STOREMANAGER
	FROM
		STAGE_STORE ss,
		DIM_LOCATION dl
	WHERE
		dl."SourceLocationID" = ('STORE' || ss.STOREID))


--LOAD DIM_CHANNEL
INSERT
	INTO
	DIM_CHANNEL(
  "SourceChannelID" ,
	"SourceChannelCategoryID" ,
	"ChannelName" ,
	"ChannelCategory"
	)
(
	SELECT
		sc.CHANNELID ,
		sc.CHANNELCATEGORYID ,
		sc.CHANNEL,
		scc.CHANNELCATEGORY
	FROM
		STAGE_CHANNEL sc,
		STAGE_CHANNEL_CATEGORY scc
	WHERE
		sc.CHANNELCATEGORYID = scc.CHANNELCATEGORYID
);






