create database task;
use task;

-- task 1

create or replace table shopping_history(
product varchar(30),
quantity int,
unit_price int);

insert into shopping_history 
values('bread',3,20),
('milk',2,50),
('egg',12,6),
('flour',3,50),
('vegis',5,30),
('fruits',6,70),
('rice',8,60),
('spices',3,40),
('coconut',4,20),
('oil',2,100);

select * from shopping_history;

select product , (quantity * unit_price) as total_price from shopping_history;
-----------------------------------------------------------------------------------------------------------

 -- task 2
 
create or replace table phones(
  name varchar(30) not null unique,
  phone_number int not null unique
);


create or replace table calls
(
 id int not null,
  caller int  not null,
  callee int not null,
  duration int not null,
  unique(id)
);

insert into phones
values('mark',1234),
('lena',2345),
('johan',3456),
('jonny',4567),
('janardhan',5678),
('rock',6789),
('khali',7890),
('cristiano',8901),
('tania',9012),
('robert',4321);

select * from phones;

insert into calls
values(25,8901,6789,4),
(10,4321,3456,3),
(13,6789,2345,4),
(23,5678,7890,2),
(34,1234,4567,4),
(42,3456,5678,4),
(12,6789,4321,6),
(51,6789,3456,2),
(24,2345,3456,2),
(56,2345,4321,5),
(46,4567,7890,2),
(234,1234,4321,2),
(43,9012,8901,1);

select * from calls;

with output (name,duration) as 
(SELECT name,c.duration from phones p join calls c on p.phone_number = c.callee
union all
select name,c.duration from phones p join calls c on p.phone_number = c.caller)
select name from output group by name having sum(duration)>10;
--------------------------------------------------------------------------------------------------------------------------------------
-- task 3

create or replace table transactions
(Amount INT NOT NULL,
Date DATE NOT NULL);

select * from transactions;

INSERT INTO transactions (Amount, Date)
VALUES
(1000, '2020-01-06'),
(-10, '2020-01-14'),
(-75, '2020-01-20'),
(-5, '2020-01-25'),
(-4,'2020-01-29'),
(2000, '2020-03-10'),
(-75, '2020-03-12'),
(-20, '2020-03-15'),
(40, '2020-03-15'),
(-50, '2020-03-17'),
(200, '2020-10-10'),
(-200, '2020-10-10');

select * from transactions where amount < 0;

SELECT EXTRACT(MONTH FROM Date) as month ,count(EXTRACT(MONTH FROM Date)) as count_of_txn, sum(- amount) as total_amount_of_month 
from (select * from transactions where amount < 0) group by month ;

create or replace table extension(Date Date); --- reference table
insert into extension 
values('2020-01-10'),
('2020-02-10'),
('2020-03-10'),
('2020-04-10'),
('2020-05-10'),
('2020-06-10'),
('2020-07-10'),
('2020-08-10'),
('2020-09-10'),
('2020-10-12'),
('2020-11-10'),
('2020-12-10');

create table M1 as
SELECT EXTRACT(MONTH FROM Date) as month ,count(EXTRACT(MONTH FROM Date)) as count_of_txn, sum(- amount) as total_amount_of_month 
from (select * from transactions where amount < 0) group by month;

create table M2 as
select extract(month from Date) as month from extension;


select M2.*,count_of_txn,total_amount_of_month from M1 right join M2 on M1.month= M2.month;


create or replace table master as
select (count(charge_flag) * 5) as charge_amount from
  (select *,
      case
      when count_of_txn < 3 or count_of_txn is null or total_amount_of_month < 100 then 'charge'
      else 'no charge'
      end as charge_flag
   from (select M2.*,count_of_txn,total_amount_of_month from M1 right join M2 on M1.month= M2.month))
where charge_flag = 'charge';

select * from master; ---> charge_amount = 55

select sum(balance) as balance from
(select sum(amount) as balance from transactions 
union
select - (charge_amount) as balance from master); ---> balance = 2746