create database assignment;
use assignment;

#---------------------------complain_data------------------------------------------------------
create table sl_complains_data(
ID int,
ComplainDate Date,
CompletionDate Date,
CustomerID int,
BrokerID int,
ProductID int,
ComplainPriorityID int,
ComplainTypeID int,
ComplainSourceID int,
ComplainCategoryID int,
ComplainStatusID int,
AdministratorID int,
ClientSatisfaction varchar(20),
ExpectedReimbursement decimal(38,2)
);

load data local infile 'D:\complains_data.csv'
into table sl_complains_data
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_complains_data; 

#---------------------------customers-----------------------------------------------------

create table sl_customers(
  CustomerID int,
  LastName varchar(30),
  FirstName varchar(30),
  BirthDate Date,
  Gender varchar(30),
  ParticipantType varchar(30),
  RegionID int,
  MaritalStatus varchar(30)
);

load data local infile 'D:\customers.csv'
into table sl_customers
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_customers;

#--------------------------regions------------------------------------------------

create table sl_Regions(
 id	int,
  name varchar(50),
  county varchar(100),
  state_code varchar(30),
  state	varchar(50),
  type varchar(50),
  latitude decimal(38,5),
  longitude decimal(38,5),
  area_code int,
  population int,
  households int,
  median_income int,
  land_area int,
  water_area int,
  time_zone varchar(100)
);

load data local infile 'D:\Regions.csv'
into table sl_Regions
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_Regions; 

#---------------------------------state_region----------------------------------------------------
CREATE TABLE sl_STATE_REGION
(
  State_Code VARCHAR(20),	
  State	 VARCHAR(20),
  Region VARCHAR(20)
);

load data local infile "D:\State_Regions.csv"
into table sl_STATE_REGION
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_STATE_REGION; 

#-------------------------------priorities---------------------------------------------------
CREATE TABLE sl_PRIORITIES
(
ID	INT,
Description_Priorities VARCHAR(10)
);

load data local infile "D:\Priorities.csv"
into table sl_PRIORITIES
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_PRIORITIES; 

#--------------------------------statuses---------------------------------------------------
CREATE TABLE sl_STATUSES
(
  ID	INT,
  Description_Status VARCHAR(40));
  
load data local infile "D:\Statuses.csv"
into table sl_STATUSES
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;
  
  select * from sl_STATUSES; 
  
  #-------------------------------sources------------------------------------------------------
  CREATE TABLE sl_SOURCES
(
ID	INT,
Description_Source VARCHAR(20)
);

load data local infile "D:\Source.csv"
into table sl_SOURCES
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_SOURCES; 

#----------------------------------type---------------------------------------------------------
CREATE TABLE sl_TYPE
(
  ID INT	,
  Description_Type VARCHAR(20)
);

load data local infile "D:\Types.csv"
into table sl_type
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_type; 

#---------------------------------------Broker-------------------------------------------------------------------------
CREATE TABLE sl_BROKER
(
  BrokerID	INT,
  BrokerCode VARCHAR(70),
  BrokerFullName	VARCHAR(60),
  DistributionNetwork	VARCHAR(60),
  DistributionChannel	VARCHAR(60),
  CommissionScheme VARCHAR(50)

);

load data local infile "D:\Brokers.csv"
into table sl_BROKER
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_BROKER; 

#----------------------------product---------------------------------------------------
CREATE TABLE sl_PRODUCT
(
ProductID	INT,
ProductCategory	VARCHAR(60),
ProductSubCategory	VARCHAR(60),
Product VARCHAR(30)
);

load data local infile "D:\Products.csv"
into table sl_PRODUCT
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_PRODUCT; 

#---------------------------catagories------------------------------------------
CREATE TABLE sl_CATAGORIES
(
ID	INT,
Description_Categories VARCHAR(200),
Active INT
);

load data local infile "D:\categories.csv"
into table sl_CATAGORIES
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from sl_CATAGORIES; 

#---------------------------------status_history_data--------------------------------------------------------------------------
 
 create table sl_status_history_data(
 ID int,
 ComplaintID int,
 ComplaintStatusID int,
 StatusDate Date
 );
 
 load data local infile 'D:\status_history_data.csv'
into table sl_status_history_data
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

 select * from sl_status_history_data;
 
 #-------------------------------------------master_table-----------------------------------
 
CREATE TABLE sl_CUST_MASTER AS
SELECT COM.ID, COM.ComplainDate, COM.CompletionDate, CUS.LastName, CUS.FirstName,
CUS.Gender, BR.BrokerFullName, BR.CommissionScheme,
CAT.Description_Categories, SR.Region, ST.Description_Status, REG.state, PR.Product,
PRI.Description_Priorities, SUR.Description_Source, TY.Description_Type
FROM sl_complains_data COM 
LEFT OUTER JOIN sl_CUSTOMERS CUS ON COM.CustomerID = CUS.CustomerID
LEFT OUTER JOIN sl_status_history_data SH ON COM.ID = SH.ID
LEFT OUTER JOIN sl_REGIONS REG ON CUS.RegionID = REG.id
LEFT OUTER JOIN sl_STATE_REGION SR ON REG.state_code = SR.State_Code
LEFT OUTER JOIN sl_BROKER BR ON COM.BrokerID = BR.BrokerID
LEFT OUTER JOIN sl_CATAGORIES CAT ON COM.ComplainCategoryID = CAT.ID
LEFT OUTER JOIN sl_PRIORITIES PRI ON COM.ComplainPriorityID = PRI.ID
LEFT OUTER JOIN sl_PRODUCT PR ON COM.ProductID = PR.ProductID
LEFT OUTER JOIN sl_SOURCES SUR ON COM.ComplainSourceID = SUR.ID
LEFT OUTER JOIN sl_STATUSES ST ON COM.ComplainStatusID = ST.ID
LEFT OUTER JOIN sl_TYPE TY ON COM.ComplainTypeID = TY.ID;

select * from sl_cust_master;