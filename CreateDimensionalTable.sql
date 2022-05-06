--First Create the DIM_DATE.DDL to Create the Date Dimension Table
-- Post creation of DIM_DATE table, execute the below query:


CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_PRODUCT(
  "DimProductID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimProductID" PRIMARY KEY NOT NULL,
  "SourceProductID" INTEGER, 
  "SourceProductTypeID" INTEGER, 
  "SourceProductCategoryID" INTEGER, 
  "ProductName" VARCHAR(255),
  "ProductType" VARCHAR (255), 
  "ProductCategory" VARCHAR (255),
  "ProductRetailPrice" FLOAT,
  "ProductWholesalePrice" FLOAT, 
  "ProductCost" FLOAT, 
  "ProductRetailProfit" FLOAT, 
  "ProductWholesaleUnitProfit" FLOAT, 
  "ProductProfitMarginUnitPercent" FLOAT
);



CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_LOCATION(
  "DimLocationID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimLocationID" PRIMARY KEY NOT NULL,
  "SourceLocationID" INTEGER, 
  "PostalCode" VARCHAR(255),
  "Address" VARCHAR (255), 
  "City" VARCHAR (255),
  "Region" VARCHAR (255), 
  "Country" VARCHAR (255)
);


CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_CHANNEL(
  "DimChannelID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimChannelID" PRIMARY KEY NOT NULL,
  "SourceChannelID" INTEGER, 
  "SourceChannelCategoryID" INTEGER, 
  "ChannelName" VARCHAR (255), 
  "ChannelCategory" VARCHAR (255)
);


SELECT * FROM IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_LOCATION

CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_STORE(
  "DimStoreID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimStoreID" PRIMARY KEY NOT NULL,
  "DimLocationID" INTEGER CONSTRAINT "FK_DimLocationIDStore" FOREIGN KEY REFERENCES DIM_LOCATION("DimLocationID") NOT NULL, 
  "SourceStoreID" INTEGER,
  "StoreNumber" VARCHAR (255), 
  "StoreManager" VARCHAR (255)
);


CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_RESELLER(
  "DimResellerID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimResellerID" PRIMARY KEY NOT NULL,
  "DimLocationID" INTEGER CONSTRAINT "FK_DimLocationIDReseller" FOREIGN KEY REFERENCES DIM_LOCATION("DimLocationID") NOT NULL, 
  "SourceResellerID" VARCHAR (255),
  "ResellerName" VARCHAR (255), 
  "ContactName" VARCHAR (255),
  "PhoneNumber" VARCHAR (255), 
  "Email" VARCHAR (255)
);


CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_CUSTOMER(
  "DimCustomerID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimCustomerID" PRIMARY KEY NOT NULL,
  "DimLocationID" INTEGER CONSTRAINT "FK_DimLocationIDCustomer" FOREIGN KEY REFERENCES DIM_LOCATION("DimLocationID") NOT NULL, 
  "SourceCustomerID" VARCHAR (255),
  "FullName" VARCHAR (255), 
  "FirstName" VARCHAR (255),
  "LastName" VARCHAR (255),
  "Gender" VARCHAR (255),
  "EmailAddress" VARCHAR (255),
  "PhoneNumber" VARCHAR (255)
);


----Fact Tables Now-----

CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.FACT_SALESACTUAL(
  "DimProductID" INTEGER CONSTRAINT "FK_DimProductIDSalesActual" FOREIGN KEY REFERENCES DIM_PRODUCT("DimProductID") NOT NULL,
  "DimStoreID" INTEGER CONSTRAINT "FK_DimStoreIDSalesActual" FOREIGN KEY REFERENCES DIM_PRODUCT("DimProductID") NOT NULL,
  "DimResellerID" INTEGER CONSTRAINT "FK_DimResellerIDSalesActual" FOREIGN KEY REFERENCES DIM_RESELLER("DimResellerID") NOT NULL,
  "DimCustomerID" INTEGER CONSTRAINT "FK_DimCustomerIDSalesActual" FOREIGN KEY REFERENCES DIM_CUSTOMER("DimCustomerID") NOT NULL,
  "DimChannelID" INTEGER CONSTRAINT "FK_DimChannelIDSalesActual" FOREIGN KEY REFERENCES DIM_CHANNEL("DimChannelID") NOT NULL,
  "DimSaleDateID" NUMBER(9,0) CONSTRAINT "FK_DATE_PKEYSalesActual" FOREIGN KEY REFERENCES DIM_DATE("DATE_PKEY") NOT NULL,
  "DimLocationID" INTEGER CONSTRAINT "FK_DimLocationIDSalesActual" FOREIGN KEY REFERENCES DIM_LOCATION("DimLocationID") NOT NULL,
  "SourceSalesHeaderID" INTEGER,
  "SourcesSalesDetailID" INTEGER, 
  "SaleAmount" FLOAT,
  "SaleQuantity" INTEGER,
  "SaleUnitPrice" FLOAT,
  "SaleExtendedCost" FLOAT,
  "SaleTotalProfit" FLOAT
);



CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.FACT_SRCSALESTARGET(
  "DimStoreID" INTEGER CONSTRAINT "FK_DimStoreIDSalesTarget" FOREIGN KEY REFERENCES DIM_PRODUCT("DimProductID") NOT NULL,
  "DimResellerID" INTEGER CONSTRAINT "FK_DimResellerIDSalesTarget" FOREIGN KEY REFERENCES DIM_RESELLER("DimResellerID") NOT NULL,
  "DimChannelID" INTEGER CONSTRAINT "FK_DimChannelIDSalesTarget" FOREIGN KEY REFERENCES DIM_CHANNEL("DimChannelID") NOT NULL,
  "DimTargetDateID" NUMBER(9,0) CONSTRAINT "FK_DATE_PKEYSalesTarget" FOREIGN KEY REFERENCES DIM_DATE("DATE_PKEY") NOT NULL,
  "SalesTargetAmount" FLOAT
);


CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.FACT_PRODUCTSALESTARGET(
  "DimProductID" INTEGER CONSTRAINT "FK_DimProductIDProductTarget" FOREIGN KEY REFERENCES DIM_PRODUCT("DimProductID") NOT NULL,
  "DimTargetDateID" NUMBER(9,0) CONSTRAINT "FK_DATE_PKEYProductTarget" FOREIGN KEY REFERENCES DIM_DATE("DATE_PKEY") NOT NULL,
  "ProductTargetSalesQuanity" INTEGER
);






























































