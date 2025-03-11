create table coffee(
transaction_id int,
transaction_date date,
transaction_time time,
transaction_qty	int,
store_id int,
store_location text,
product_id int,
unit_price double precision,
product_category text,
product_type text,
product_detail text
);

select * from coffee;