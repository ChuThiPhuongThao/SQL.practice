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
