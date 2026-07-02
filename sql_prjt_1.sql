create database sql_project_p2;

-- create table
drop table if exists retail_sales;
create table retail_sales (
           transactions_id int primary key,	
		   sale_date date,	
		   sale_time time,	
		   customer_id int,	
		   gender varchar(15),	
		   age int,
		   category varchar(15),	
		   quantiy	int,
		   price_per_unit	float,
		   cogs	float,
		   total_sale float

);

select * from retail_sales
limit 10;

select count(*) from retail_sales;

-- DATA CLEANING
select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where customer_id is null;

select * from retail_sales
where gender is null;

select * from retail_sales
where age is null 
or
 category is null
or
 quantiy is null
or
 price_per_unit is null
or
 cogs is null
or
 total_sale is null;


delete from retail_sales 
where age is null 
or
 category is null
or
 quantiy is null
or
 price_per_unit is null
or
 cogs is null
or
 total_sale is null;


-- DATA EXPLORATION 

-- How many sales we have ?
select count(*) as total_sale from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id ) as total_customers from retail_sales;

-- How many categories do we have ?
select distinct(category) from retail_sales;



-- DATA ANALYSIS PROBLEMS AND ANSWERS 

-- Q1 Write a sql query to retrieve all columns for sales made no '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- Q2  Write a sql query to retrieve all transactions where the category is 'Clothing'
-- 	   and the quantity sold is more than 4 in the month of nov 2022?
select * from retail_sales 
where category = 'Clothing'
and to_char(sale_date,'YYYY-MM')='2022-11'
AND quantiy >=4;

-- Q3 Write the sql query to caculate the total sales for each category?
select category,sum(total_sale)
from retail_sales 
group by category;

-- Q4 Write a sql query to find the average age of customers who purchased items from 
--	  from the beauty category.
select avg(age) as avg_age
from retail_sales
where category='Beauty';

-- Q5 Write a sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000;

--Q6 Write a sql query to find the total number of transactions made by each gender 
--   in each category?
select category,gender,count(transactions_id)
from retail_sales
group by gender,category; 

-- Q7 Write a sql query to calculate the average sale of each month,
--    find out best selling month in each year?
select 
		year,
		month,
		avg_total_sale
from
(
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_total_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc ) as rank
from retail_sales 
group by 1,2
) as t1
where rank=1;

-- Q8 Write a sql query to find the top 5 customers based on the highest total sales.
select customer_id,
	   sum(total_sale) as total_sales
	   from retail_sales
	   group by customer_id
	   order by 2 desc limit 5;

-- Q9 Write a sql query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id) as unique_cust,
	   category
	   from retail_sales
	   group by 2;

-- Q10 Write a sql query to each shift and number of orders ( Example Morning <12 , Afternoon between 12 and 17 , Evening >17)
WITH hourly_sale AS
(
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

------------------------END OF PROJECT-----------------------------------------