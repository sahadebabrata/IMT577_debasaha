/*****************************************
Course: IMT 577
Student: Debabrata Saha
Assignment: Module 6
Date: 05/07/2022
Description: Create Table DDL scripts for Dimensional Tables

*****************************************/

--First Create the DIM_DATE.DDL to Create the Date Dimension Table
-- Post creation of DIM_DATE table, execute the below query:

-- Create table script for Dimension DIM_PRODUCT
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

-- Create table script for Dimension DIM_LOCATION
CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_LOCATION(
  "DimLocationID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimLocationID" PRIMARY KEY NOT NULL,
  "SourceLocationID" VARCHAR(255), 
  "PostalCode" VARCHAR(255),
  "Address" VARCHAR (255), 
  "City" VARCHAR (255),
  "Region" VARCHAR (255), 
  "Country" VARCHAR (255)
);

-- Create table script for Dimension DIM_CHANNEL
CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_CHANNEL(
  "DimChannelID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimChannelID" PRIMARY KEY NOT NULL,
  "SourceChannelID" INTEGER, 
  "SourceChannelCategoryID" INTEGER, 
  "ChannelName" VARCHAR (255), 
  "ChannelCategory" VARCHAR (255)
);


-- Create table script for Dimension DIM_STORE
CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_STORE(
  "DimStoreID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimStoreID" PRIMARY KEY NOT NULL,
  "DimLocationID" INTEGER CONSTRAINT "FK_DimLocationIDStore" FOREIGN KEY REFERENCES DIM_LOCATION("DimLocationID") NOT NULL, 
  "SourceStoreID" INTEGER,
  "StoreNumber" VARCHAR (255), 
  "StoreManager" VARCHAR (255)
);

-- Create table script for Dimension DIM_RESELLER
CREATE OR REPLACE TABLE IMT577_DW_DEBABRATA_SAHA.PUBLIC.DIM_RESELLER(
  "DimResellerID" INTEGER IDENTITY(1,1) CONSTRAINT "PK_DimResellerID" PRIMARY KEY NOT NULL,
  "DimLocationID" INTEGER CONSTRAINT "FK_DimLocationIDReseller" FOREIGN KEY REFERENCES DIM_LOCATION("DimLocationID") NOT NULL, 
  "SourceResellerID" VARCHAR (255),
  "ResellerName" VARCHAR (255), 
  "ContactName" VARCHAR (255),
  "PhoneNumber" VARCHAR (255), 
  "Email" VARCHAR (255)
);

-- Create table script for Dimension DIM_CUSTOMER
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