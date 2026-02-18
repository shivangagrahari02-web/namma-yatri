-- total trips

select count(distinct tripid) as cnt from trips_details4;

select tripid, count(tripid) as cnt from trips_details4 group by tripid having count(tripid) > 1;

-- total drivers
select count(distinct driverid) as total_driver from trips;

-- total earnings
select sum(fare) as total_earnings from trips;

-- total completed trips
select count(tripid) as trip_count from trips;

-- total searches 
select sum(searches) as searches from trips_details4;

-- total searches which got estimate 
select sum(searches_got_estimate) as estimate from trips_details4;

-- total searches for quotes 
select sum(searches_for_quotes) as searches_for_quotes from trips_details4;

-- total searches got quotes
select sum(searches_got_quotes) as searches_got_quotes from trips_details4;

-- total driver cancelled
select count(*) - sum(driver_not_cancelled) as cncl_trips from trips_details4;

-- total otp entered 
select sum(otp_entered) as otp_generated from trips_details4;

-- total end ride 
select sum( end_ride) as otp_generated from trips_details4;

-- average distance per trip
select avg(distance) from trips;

-- average fare per trip 
select avg(fare) from trips;

-- distance travelled 
select sum(distance) from trips;

-- most used payment method

select P.id, P.method from payment as P inner join
(select faremethod, count(distinct tripid) as cnt from trips
group by faremethod order by count(distinct tripid) desc limit 1) as F
on P.id = F.faremethod;

-- highest payment mode

select P.id, P.method from payment as P inner join
(select * from trips
order by fare desc limit 1) as F
on P.id = F.faremethod;

-- the highest payment was made through which mode

select P.id, P.method from payment as P inner join
(select faremethod, sum(fare) from trips
group by faremethod 
order by sum(fare) desc limit 1) as F
on P.id = F.faremethod;

-- which two locations had the most trips
select loc_from, loc_to, count(distinct tripid) from trips
group by loc_from, loc_to
order by count(distinct tripid) desc;

-- top 5 earning drivers
select driverid, sum(fare) as fare from trips 
group by driverid order by sum(fare) desc;

-- which duration had more trips
select * from
(select *, rank() over(order by cnt desc) as rnk from
(select duration, count(distinct tripid) as cnt from trips
group by duration)b)c;

-- which driver customer pair had more orders
select * from
(select *, rank() over (order by cnt desc) as rnk from
(select driverid, custid, count(distinct tripid) as cnt from trips
group by driverid, custid)b)c
where rnk = 1;

-- search to estimate rate

select sum(searches_got_estimate)*100/sum(searches) from trips_details4;

-- estimate to search for quotes rates
select * from trips_details4;
select sum(searches_for_quotes)*100/sum(searches_got_estimate) from trips_details4;

-- quote acceptance rate 
select sum(searches_got_quotes)*100/sum(searches_for_quotes) from trips_details4;

-- quote to booking rate 
select sum(customer_not_cancelled)*100/ sum(searches_got_quotes) from trips_details4;

-- success rate
select sum(driver_not_cancelled)*100/sum(customer_not_cancelled) from trips_details4;

-- conversion rate
select sum(end_ride)*100/sum(searches) from trips_details4;

-- which area got highest number of trips in each duration present 

select * from
(select *, rank() over(partition by duration order by cnt desc) as rnk from
(select duration, loc_from, count(distinct tripid) as cnt from trips
group by duration, loc_from)b)c
where rnk = 1;

-- which duration got the highest number of trips in each location present 

select * from
(select *, rank() over(partition by loc_from order by cnt desc) as rnk from
(select duration, loc_from, count(distinct tripid) as cnt from trips
group by duration, loc_from)b)c
where rnk = 1;

-- which area got the highest fares
select * from
(select *, rank() over(order by fare desc) as rnk from
(select loc_from, sum(fare) as fare from trips
group by loc_from)b)c
where rnk = 1;

-- which area got the highest customer cancellations
select * from
( select *, rank() over(order by CNL desc) as rnk from
(select loc_from, count(*)-sum(customer_not_cancelled) as CNL from trips_details4
group by loc_from)b)c
where rnk = 1;

-- which area got the highest driver cancellations
select * from
( select *, rank() over(order by CNL desc) as rnk from
(select loc_from, count(*)-sum(driver_not_cancelled) as CNL from trips_details4
group by loc_from)b)c
where rnk = 1;

-- which duration got the highest trips and fares
select * from 
(select *, rank() over ( order by fare desc) as rnk from
(select duration, count(distinct tripid), sum(fare) as fare from trips
group by duration)b)c
where rnk = 1;
