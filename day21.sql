--- task 1:
select
format_date ("%Y/%m", created_at) as month_year,
count (order_id) as total_order,
count ( distinct user_id) as total_user
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete' and created_at between '2019-01-01' and '2022-05-01'
group by month_year 
order by month_year
/* Nhận xét:
1. Số lượng đơn hàng và người mua tăng dần theo thời gian
2. Trong mỗi năm, số lượng đơn hàng và người mua đều tăng dần theo các tháng và đạt đỉnh vào 3 tháng cuối năm
3. Số lượng khách mua nhiều đơn trong 1 tháng hầu như không đang kể và vẫn chưa có dấu hiệu tăng trưởng*/

--- task 2:
select 
format_date ("%Y/%m", t1.created_at) as month_year,
count ( distinct t1.user_id) as distinct_users,
SUM(t1.num_of_item * t2.sale_price)/ count (t1.order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.orders as t1
join bigquery-public-data.thelook_ecommerce.order_items as t2
on t1.order_id = t2.order_id
where t1.created_at between '2019-01-01' and '2022-05-01'
group by month_year
order by month_year
/* Nhận xét:
1. SỐ lương người mua hàng đã có sự tăng dần và tăng trưởng ổn định theo thời gian 
2. Giá trị trung bình đơn hàng trong khoảng thời gian theo dõi nhìn chung đã có gia tăng, nhưng dao động ổn định ở quanh mốc 110 trong phần lớn các tháng */

--- task 3:
with youngest_table as 
(select first_name, last_name, gender, age,
'youngest' as tag
from bigquery-public-data.thelook_ecommerce.users
where age = (select min(age) from bigquery-public-data.thelook_ecommerce.users)
order by gender asc),

oldest_table as 
(select first_name, last_name, gender, age,
'oldest' as tag
from bigquery-public-data.thelook_ecommerce.users
where age = (select max(age) from bigquery-public-data.thelook_ecommerce.users)
order by gender asc),

cte as (
select * from youngest_table 
union all select * from oldest_table)

select 
sum(case when tag = 'youngest' then 1 else 0 end) as cnt_youngest,
sum(case when tag = 'oldest' then 1 else 0 end) as cnt_oldest
from cte;

*/ Nhận xét: 
có 1703 khách hàng trẻ nhất ở độ tuổi 12 và 1646 khách hàng lớn tuổi nhất ở độ tuổi 70 */

-- task 4
with cte1 as (
SELECT 
format_date ("%Y/%m", t1.created_at) as month_year,
t2.product_id,
t3.name AS product_name,
SUM(t2.sale_price * t1.num_of_item) AS sales,
SUM(t2.sale_price * t1.num_of_item) - SUM(t3.cost * t1.num_of_item) AS profit,
from bigquery-public-data.thelook_ecommerce.orders as t1
join bigquery-public-data.thelook_ecommerce.order_items as t2 on t1.order_id = t2.order_id 
join bigquery-public-data.thelook_ecommerce.products as t3 on t2.product_id = t3.id
GROUP BY 
format_date ("%Y/%m", t1.created_at),
t2.product_id,
t3.name),

cte2 as (
select *,
DENSE_RANK() OVER (PARTITION BY month_year ORDER BY cte1.profit DESC) AS rank_per_month
from cte1
order by month_year, rank_per_month)

select * from cte2
Where
rank_per_month <= 5;

--task 5
SELECT 
format_date ("%Y-%m-%d", t1.delivered_at) as dates,
t3.category AS product_categories,
sum(t2.sale_price * t1.num_of_item) as revenue
FROM bigquery-public-data.thelook_ecommerce.orders as t1
JOIN bigquery-public-data.thelook_ecommerce.order_items as t2 ON t1.order_id = t2.order_id
JOIN bigquery-public-data.thelook_ecommerce.products as t3 ON t2.product_id = t3.id
where format_date ("%Y-%m-%d", t1.delivered_at) >= "2022-01-15" AND format_date ("%Y-%m-%d", t1.delivered_at) <= "2022-04-15" 
GROUP BY dates,t3.category
ORDER BY dates, product_categories;





