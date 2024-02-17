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
2. Giá trị trung bình đơn hàng trong khoảng thời gian theo dõi nhìn chung đã có gia tăng, nhưng dao động ổn định ở quanh mốc 110 trong phần lớn các tháng






