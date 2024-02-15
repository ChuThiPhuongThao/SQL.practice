--ex1
alter table SALES_DATASET_RFM_PRJ
alter ordernumber type smallint, 
alter quantityordered type smallint USING quantityordered::smallint,
alter priceeach type numeric USING priceeach::numeric,
alter orderlinenumber type smallint USING orderlinenumber::smallint,
alter sales type numeric USING sales::numeric,
alter orderdate type timestamp USING orderdate::timestamp,
alter status type text USING status::text,
alter productline type text USING productline::text,
alter msrp type smallint USING msrp::smallint,
alter productcode type varchar USING productcode::varchar,
alter customername type text USING customername::text,
alter phone type text USING phone::text,
alter addressline1 type text USING addressline1::text,
alter addressline2 type text USING addressline2::text,
alter city type text USING city::text,
alter state type text USING state::text,
alter postalcode type text USING postalcode::text,
alter country type text USING country::text,
alter territory type text USING territory::text,
alter contactfullname type text USING contactfullname::text,
alter dealsize type text USING dealsize::text
  
--ex2
select * from sales_dataset_rfm_prj
where ordernumber is NULL or quantityordered is NULL or priceeach is NULL or orderlinenumber is NULL or sales is NULL or orderdate is NULL;

--ex3
alter table SALES_DATASET_RFM_PRJ
add column contactfirstname text,
add column contactlastname text;

UPDATE SALES_DATASET_RFM_PRJ
SET contactfirstname = left (contactfullname, position ('-' in contactfullname) -1);

UPDATE SALES_DATASET_RFM_PRJ
SET contactlastname = right (contactfullname, length (contactfullname) - position ('-' in contactfullname));

UPDATE SALES_DATASET_RFM_PRJ
SET contactfirstname = CONCAT(Upper(left(contactfirstname,1)), lower(right(contactfirstname,length(contactfirstname)-1)));

UPDATE SALES_DATASET_RFM_PRJ
SET contactlastname = CONCAT(Upper(left(contactlastname,1)), lower(right(contactlastname,length(contactlastname)-1)));

--ex4
alter table SALES_DATASET_RFM_PRJ
add column qtr_id numeric,
add column month_id numeric,
add column year_id numeric;

UPDATE SALES_DATASET_RFM_PRJ
SET qtr_id = extract (quarter from orderdate),
 month_id = extract (month from orderdate),
 year_id = extract (year from orderdate);

--ex5
with cte as (
select *,
(select avg(quantityordered) from sales_dataset_rfm_prj) as avg,
(select stddev (quantityordered) from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj),
cte_outlier as (
select *, 
(quantityordered-avg)/cte.stddev as z_score
from cte
where abs((quantityordered-avg)/cte.stddev) >2)
      --cách xử lý 1: thay Outlier = avg
update sales_dataset_rfm_prj
set quantityordered =  (select avg(quantityordered) from sales_dataset_rfm_prj)
where quantityordered in (select quantityordered from cte_outlier)
      --cách xử lý 2: xóa dữ liệu Outlier
delete from sales_dataset_rfm_prj
where quantityordered in (select quantityordered from cte_outlier)

--ex6
select * into SALES_DATASET_RFM_PRJ_CLEAN
from sales_dataset_rfm_prj;

