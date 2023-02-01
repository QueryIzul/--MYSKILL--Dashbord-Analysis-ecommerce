--Query Analysis E-Commerce with SQL

--Analysis of total users and prices other than Apple and Samsung brands based on views

Select 
	count(distinct user_session) as total_unique_user_session,
    min(price) as harga_terendah,
	max(price) as harga_tertinggi,
	round(avg(price),2) as rata_rata_harga
From ecommerce_event
Where event_type = 'view' and brand not in ('apple', 'samsung');

--Analysis of total product id based on brands starting with the letters A and K from the date after October 04, 2019

Select 
	count(distinct product_id) as total_product_id
From ecommerce_event
Where (brand like 'a%' or brand like 'k%') and event_date > '2019-10-04';

--Analysis of total products and total users for each order date

Select 
	event_date as tanggal,
	count(distinct product_id) as total_unique_product_id,
	count(distinct user_id) as total_unique_user_id
From ecommerce_event
Where event_date >  '2019-08-04'
Group by 1
Order by 1 desc;

--Analysis of total products and total users for each date whose bookings exceed 500

Select 
	event_date as tanggal ,
	count(distinct product_id) as total_unique_product_id ,
	count(distinct user_id) as total_unique_user_id
From ecommerce_event
Where event_date >  '2019-08-04'
Group by 1
Having count(distinct product_id) > 500
Order by 1 desc;

--Gender analysis of which is more sessions in October

Select 
	gender,
	count(distinct user_session) as total_unique_user_session
From ecommerce_event t1
Join user_profile t2 on t1.user_id = t2.user_id
Where event_date between '2019-10-01' and '2019-10-31'
Group by 1;

--Iphone and Samsung brand analysis by gender

Select 
	gender,
	count(distinct case when brand = 'apple' then t1.user_id end) as apple,
	count(distinct case when brand = 'samsung' then t1.user_id end) as samsung 
From ecommerce_event t1
Join user_profile t2 ON t1.user_id = t2.user_id 
Group by 1;

--Analysis of total product, total users and total sessions based on age with total users more than 320

Select 
	age,
	count(distinct t1.user_id) as total_unique_user_id,
	count(distinct product_id) as total_unique_product_id,
	count(distinct user_session) as total_unique_user_session
From ecommerce_event t1
Join user_profile t2 on t1.user_id = t2.user_id
Group by 1
Having count(distinct t1.user_id) > 320;

--Calculate revenue per day per user

Select 
	event_date as daily,
	round(sum(price),2) as revenue,
	count(distinct user_id) as total_unique_user_id
From ecommerce_event
Where event_type = 'purchase'
Group by 1
Order by 1;

--Calculates daily income and unique men-only users for each date

Select
	event_date as daily,
	round(sum(price),2) as revenue,
	count(distinct t1.user_id) as total_unique_user_id
From ecommerce_event t1
Join user_profile t2 on t1.user_id = t2.user_id
Where event_type = 'purchase' and gender = 'Male'
Group by 1
Order by 1;

--Calculates average daily revenue per user for each date with revenue above 3000

with 
tmt as 
(
	Select 
		event_date as daily,
	    round(sum(price),2) as revenue,
	    count(distinct user_id) as total_unique_user_id
	From ecommerce_event
	Where event_type = 'purchase'
	Group by 1
	Having round(sum(price),2) > 3000
	Order by 1
)

Select 
	daily, 
	revenue, 
	round((revenue/total_unique_user_id),2) as ARPU
From tmt
Group by 1, 2, 3
Order by 1;
