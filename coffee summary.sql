SELECT * FROM COFFEE;

--TOTAL ORDERS:

SELECT COUNT(transaction_id) as total_orders
FROM COFFEE;

--TOTAL REVENUE:

SELECT ROUND(SUM(unit_price*transaction_qty)) AS total_REVENUE
FROM COFFEE;

--ORDERS IN EACH STORE LOCATION:

SELECT store_location AS location,
		COUNT(transaction_id) as total_orders
FROM COFFEE
GROUP BY 1;

--QUANTITY SOLD IN EACH STORE:

SELECT store_id, store_location AS location,
		SUM(transaction_qty) as total_quantity_sold
FROM COFFEE
GROUP BY 1,2
ORDER BY 3 DESC;

--QUANTITY SOLD ON EACH DAY IN EACH STORE:

SELECT store_id, store_location AS location, 
		transaction_date AS date,
		SUM(transaction_qty) as total_quantity_sold
FROM COFFEE
GROUP BY 1,2,3
ORDER BY 3,4 DESC;

--PRODUCT SUMMARY:

SELECT PRODUCT_ID, product_category, product_type,
		COUNT(transaction_id) as total_orders,
		SUM(transaction_qty) as total_quantity_sold
FROM COFFEE
GROUP BY 1,2,3
ORDER BY 5 DESC;

--REVENUE BY EACH PRODUCT:

SELECT PRODUCT_ID, product_category, product_type,
		SUM(transaction_qty) as total_quantity_sold,
		ROUND(SUM(unit_price*transaction_qty)) as revenue
FROM COFFEE
GROUP BY 1,2,3
ORDER BY 5 DESC;

--PRODUCT THAT HAS LOWEST PRICE:

SELECT distinct(product_id), product_category, product_type, unit_price
FROM COFFEE
WHERE unit_price = (SELECT MIN(unit_price) FROM coffee);

--PRODUCT THAT HAS HIGHEST PRICE:

SELECT distinct(product_id), product_category, product_type, unit_price
FROM COFFEE
WHERE unit_price = (SELECT MAX(unit_price) FROM coffee);

--REVENUE GENERATE IN EACH MONTH IN EACH STORE:

SELECT  store_ID, store_location,  EXTRACT(MONTH FROM transaction_date) AS month,
		TO_CHAR(transaction_date, 'Month') as month_name,
		ROUND(SUM(unit_price*transaction_qty)) as revenue
FROM COFFEE
GROUP BY 1,2,3,4
ORDER BY 3,1,5 DESC;

--QUANTITY DISTRIBUTION BY HOUR ON 1 JAN, 2023:

SELECT EXTRACT(HOUR FROM transaction_time) AS hour,
		SUM(transaction_qty) AS total_quantity_sold
FROM COFFEE
WHERE transaction_date = '2023-01-01'
GROUP BY 1
ORDER BY 2 DESC;

--PREFERRED CATEGORY ORDERED IN EACH STORE:

WITH category_rank AS(
	SELECT store_location AS location,
			product_category AS category,
			product_type as type,
			COUNT(transaction_id) AS total_orders,
			DENSE_RANK() OVER(PARTITION BY store_location ORDER BY COUNT(transaction_id) DESC) as rank
	FROM COFFEE
	GROUP BY 1,2,3
)
SELECT location, category,type, total_orders
FROM category_rank
WHERE rank = 1;
