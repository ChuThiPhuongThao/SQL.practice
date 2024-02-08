--ex1
SELECT extract (year from transaction_date) as year,
product_id, spend as curr_year_spend,
lag (spend) over (partition by product_id order by extract (year from transaction_date)) as prev_year_spend,
round((100*spend/lag (spend) over (partition by product_id order by extract (year from transaction_date))-100),2) as yoy_rate
FROM user_transactions;

--ex2
SELECT DISTINCT card_name,
first_value(issued_amount) over (partition by card_name order by issue_year asc, issue_month asc) as issued_amount
FROM monthly_cards_issued
order by issued_amount desc;

--ex3
SELECT user_id, spend, transaction_date
FROM (SELECT
user_id, spend, transaction_date,
RANK() over (partition by user_id order by transaction_date) as stt
from transactions) as new_transactions
where stt = 3;

--ex4
with cte1 as (SELECT transaction_date, user_id, product_id,
rank () over(partition by user_id order by transaction_date desc) as transactions_date_rank
FROM user_transactions)
select transaction_date, user_id,
count(product_id) as purchase_count
from cte1
where transactions_date_rank =1
group by transaction_date, user_id
order by first_value(transaction_date) over(partition by user_id order by transaction_date desc);

--ex5
with cte1 as (SELECT 
user_id, tweet_date,tweet_count,
LAG(tweet_count, 1, 0) OVER(PARTITION BY user_id ORDER BY tweet_date) AS lag1,
LAG(tweet_count, 2, 0) OVER(PARTITION BY user_id ORDER BY tweet_date) AS lag2
from tweets)
SELECT 
user_id, tweet_date,
round(1.0*(tweet_count +  lag1 + lag2)/(1 + 
CASE WHEN lag1 > 0 THEN 1 ELSE 0 END +
CASE WHEN lag2 > 0 THEN 1 ELSE 0 END),2) AS rolling_avg_3d
from cte1;

--ex6
with cte1 as(SELECT transaction_id, merchant_id, credit_card_id, amount
transaction_timestamp,
lag (transaction_timestamp) over (partition by merchant_id order by transaction_timestamp) as prev_timestamp,
transaction_timestamp - (lag (transaction_timestamp) over (partition by merchant_id order by transaction_timestamp)) as diff
FROM transactions)
select count (diff) as payment_count
from cte1
where diff < '10 minute';

--ex7
with cte1 as (select category, product,
sum(spend) as total_spend,
rank() over(partition by category order by sum(spend) desc) as ranking_spend
from product_spend
where extract (year from transaction_date) = 2022
group by category, product)
select category, product, total_spend
from cte1
where ranking_spend<=2
order by category, ranking_spend;

--ex8
with cte1 as(
select t1.artist_name,
dense_rank() over(
order by count(t2.song_id) desc) as artist_rank
from artists as t1
join songs as t2
on t1.artist_id = t2.artist_id
join global_song_rank as t3
on t2.song_id = t3.song_id
where t3.rank <= 10
group by t1.artist_name)
select artist_name, artist_rank
from cte1 
WHERE artist_rank <= 5;
