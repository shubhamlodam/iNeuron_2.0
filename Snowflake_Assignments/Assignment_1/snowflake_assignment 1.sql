use database demo_database;

# 1. Load the given dataset into snowflake with a primary key to Order Date column.

CREATE or Replace TABLE sales_data_final (
	order_id VARCHAR(15), 
	order_date date primary key, 
	ship_date date, 
	ship_mode VARCHAR(14), 
	customer_name VARCHAR(22), 
	segment VARCHAR(11), 
	state VARCHAR(36), 
	country VARCHAR(32), 
	market VARCHAR(6), 
	region VARCHAR(14), 
	product_id VARCHAR(16), 
	category VARCHAR(15), 
	sub_category VARCHAR(11), 
	product_name VARCHAR(127), 
	sales DECIMAL(38, 0), 
	quantity DECIMAL(38, 0), 
	discount DECIMAL(38, 3), 
	profit DECIMAL(38, 5) , 
	shipping_cost DECIMAL(38, 2), 
	order_priority VARCHAR(8), 
	year DECIMAL(38, 0) 
);

describe table sales_data_final;
select * from sales_data_final;

--------------------------------------------------------------------------------------------
# 2. Change the Primary key to Order Id Column.

alter table sales_data_final
drop primary key;               -- drop the primary key


alter table sales_data_final
add primary key(order_id);      -- add primary key to order id

----------------------------------------------------------------------------------------------------
# 3. Check the data type for Order date and Ship date and mention in what data type it should be?

    describe table sales_data_final; -- data type is in date formate
    
 ------------------------------------------------------------------------------------------------------
 #4. Create a new column called order_extract and extract the number after the last ‘–‘from Order ID column.
 
alter table sales_data_final
add column order_extract number(38,0); -- created the new column order_extract
 
select split_part(order_id,'-',3)from sales_data_final;

update sales_data_final
set order_extract = split_part(order_id,'-',3);

select order_extract from sales_data_final;

-----------------------------------------------------------------------------------------------------------------------------------------
#5. Create a new column called Discount Flag and categorize it based on discount.Use ‘Yes’ if the discount is greater than zero else ‘No’.

alter table sales_data_final
add column Discount_Flag varchar(20);  -- add column discount flag

select *,
        case
            when discount > 0 then 'Yes'
            else 'No'
        end as discount_flag
from sales_data_final;

update sales_data_final
set Discount_Flag =  case
                        when discount > 0 then 'Yes'
                        else 'No'
                     end;
                     
  select * from sales_data_final;
  
------------------------------------------------------------------------------------------------------------------------------------------------------------
# 6. Create a new column called process days and calculate how many days it takes for each order id to process from the order to its shipment.

alter table sales_data_final
add column Process_Days number(38,0); -- add column process days

select datediff('day',ORDER_DATE,SHIP_DATE)from sales_data_final;

update sales_data_final
set Process_Days = datediff('day',ORDER_DATE,SHIP_DATE);

---------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 7. Create a new column called Rating and then based on the Process dates give
rating like given below.
        a. If process days less than or equal to 3days then rating should be 5
        b. If process days are greater than 3 and less than or equal to 6 then rating
           should be 4
        c. If process days are greater than 6 and less than or equal to 10 then rating
           should be 3
        d. If process days are greater than 10 then the rating should be 2. */
 
 
 alter table sales_data_final
add column Rating number(38,0); -- add column Rating
        
 select PROCESS_DAYS from sales_data_final;       
        
 select *,
        case
            when PROCESS_DAYS <= 3 then 5
            when PROCESS_DAYS > 3 and PROCESS_DAYS <= 6 then 4
            when PROCESS_DAYS >6 and PROCESS_DAYS <= 10 then 3
            else 2
        end as Rating
from sales_data_final;

update sales_data_final
 set Rating = case
              when PROCESS_DAYS <= 3 then 5
              when PROCESS_DAYS > 3 and PROCESS_DAYS <= 6 then 4
              when PROCESS_DAYS >6 and PROCESS_DAYS <= 10 then 3
              else 2
              end;
  

select * from sales_data_final;