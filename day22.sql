--- II. Tạo metrics
with cte1 as (
select 
format_date ("%Y-%m", t1.created_at) as month_year,
t3.category AS product_categories,
SUM(t2.sale_price * t1.num_of_item) AS tpv,
sum(t1.num_of_item) as tpo,
sum(t1.num_of_item * t3.cost) as total_cost,
SUM(t2.sale_price * t1.num_of_item) - SUM(t3.cost * t1.num_of_item) AS total_profit
FROM bigquery-public-data.thelook_ecommerce.orders as t1
JOIN bigquery-public-data.thelook_ecommerce.order_items as t2 ON t1.order_id = t2.order_id
JOIN bigquery-public-data.thelook_ecommerce.products as t3 ON t2.product_id = t3.id
group by format_date ("%Y-%m", t1.created_at), t3.category)

select *,
(tpv - lag (tpv) over (partition by product_categories order by month_year))/lag (tpv) over (partition by product_categories order by month_year) as revenue_growth,
(tpo - lag (tpo) over (partition by product_categories order by month_year))/lag (tpo) over (partition by product_categories order by month_year) as order_growth,
total_profit/total_cost as profit_to_cost_ratio
from cte1
