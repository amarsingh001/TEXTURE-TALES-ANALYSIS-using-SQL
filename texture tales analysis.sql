create database texture_tales;
use texture_tales;
# 1 What was the total quantity sold for all products?
select product_details.product_name , sum( sales.qty) as 'total quantity sold'
from sales
inner join product_details
on sales.prod_id =  product_details.product_id
group by product_name
order by 'total quantity sold' desc;

# 2. What is the total generated revenue for all products before discounts?
select sum(price*qty) as 'total generated revenue before discount'
from sales;
# 3. What was the total discount amount for all products?
select (sum(price*qty*discount)/100) as 'total discount'
from sales;

#4. How many unique transactions were there?
select count(distinct txn_id) as 'total unique transactions'
from sales;

#5. What are the average unique products purchased in each transaction?
with cte_txn_count as (
select txn_id,
count(distinct prod_id) as product_count
from sales
group by txn_id)
select round(avg(product_count)) as 'avg_qty'
from  cte_txn_count;

# 6. What is the average discount value per transaction?
with cte_txn_discount as (
select txn_id,
sum(price*discount*qty)/100 as total_discount
from sales
group by txn_id)
select round(avg(total_discount)) as 'avg_discount'
from  cte_txn_discount;

#7. What is the average revenue for member transactions and non- member transactions?
with cte_member_revenue as(
select member, txn_id, sum(price*qty) as revenue 
from sales 
group by member, txn_id)
select member, round(avg(revenue),2) as avg_revenue
from  cte_member_revenue
group by member;

# 8. What are the top 3 products by total revenue before discount?
select product_details.product_name, sum(sales.price*sales.qty) as no_discount_revenue
from sales 
inner join product_details
on sales.prod_id = product_details.product_id
group by product_details.product_name
order by no_discount_revenue desc
limit 3;

#9. What are the total quantity, revenue and discount for each segment?
select product_details.segment_id, product_details.segment_name , sum(sales.qty) as quantity , sum(sales.price*sales.qty) as revenue, (sum(sales.discount*sales.qty*sales.price)/100) as total_discount
from sales
inner join product_details
on sales.prod_id = product_details.product_id
group by product_details.segment_name
order by revenue desc;

# 10. What is the top selling product for each segment?
select product_details.segment_id, product_details.segment_name , product_details.product_id, product_details. product_name, sum(sales.qty) as quantity
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by product_details.segment_name
order by quantity desc
limit 5;

# 11. What are the total quantity, revenue and discount for each category?
select product_details.category_name, sum(sales.qty) as quantity, sum(sales.price*sales.qty) as revenue , round(sum(sales.price*discount*qty)/100,2) as total_discount
from sales inner join product_details
on sales.prod_id = product_details.product_id
group by product_details.category_name;

# 12. What is the top selling product for each category?
select  product_details.product_name, product_details.category_name, sum(sales.qty) as quantity
from sales
inner join product_details
on sales.prod_id = product_details.product_id
group by product_details.product_name
order by quantity desc
limit 5;