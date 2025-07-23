# By Syeda Sania Bokhari
# Ecommerce Customer Behavior and Marketing Analytics:
# This project simulates an ecommerce database with realistic tables 
# and data to analyze customer behavior, marketing campaign effectiveness, and sales performance. 
# It showcases practical queries that a business or data analyst would use to generate actionable insights.

create database ecommerce;
use ecommerce;
# Creating tables and adding data:
create table customers (customer_id VARCHAR (10) PRIMARY KEY,
signup_date DATE, 
channel VARCHAR(50));

insert into customers (customer_id, signup_date, channel) values
('CU001', '2024-01-12', 'Email'),
('CU002', '2024-02-01', 'Google Ads'),
('CU003', '2024-03-15', 'Social Media'),
('CU004', '2024-04-08', 'Referral'),
('CU005', '2024-04-25', 'Direct');

create table campaigns( campaign_id VARCHAR(10) PRIMARY KEY,
channel VARCHAR(50),
budget INT);

insert into campaigns (campaign_id, channel, budget) values
('C1', 'Email', 3000),
('C2', 'Social Media', 4000),
('C3', 'Google Ads', 5000),
('C4', 'Referral', 2000),
('C5', 'Direct', 1000);

create table events ( event_id VARCHAR(10) PRIMARY KEY,
customer_id VARCHAR(10),
page_type VARCHAR(50),
timestamp DATETIME);

insert into events (event_id, customer_id, page_type, timestamp) values
('EV1001', 'CU001', 'homepage', '2024-04-10 10:30:00'),
('EV1002', 'CU002', 'product_page', '2024-04-11 11:45:00'),
('EV1003', 'CU003', 'search', '2024-04-12 09:00:00'),
('EV1004', 'CU004', 'checkout_page', '2024-04-13 15:20:00'),
('EV1005', 'CU005', 'homepage', '2024-04-14 16:10:00');

create table carts (cart_id VARCHAR(10) PRIMARY KEY,
customer_id VARCHAR(10),
items INT,
created_time DATETIME);

insert into carts (cart_id, customer_id, items, created_time) values
('CA001', 'CU001', 3, '2024-04-10 11:00:00'),
('CA002', 'CU002', 2, '2024-04-11 12:00:00'),
('CA003', 'CU003', 4, '2024-04-12 10:00:00'),
('CA004', 'CU004', 1, '2024-04-13 16:00:00'),
('CA005', 'CU005', 2, '2024-04-14 17:00:00');

create table orders ( order_id VARCHAR(10) PRIMARY KEY,
customer_id VARCHAR(10),
cart_id VARCHAR(10),
order_amount DECIMAL(10,2),
order_time DATETIME);

insert into orders (order_id, customer_id, cart_id, order_amount, order_time) values
('OR001', 'CU001', 'CA001', 120.50, '2024-04-10 12:00:00'),
('OR002', 'CU002', 'CA002', 80.00, '2024-04-11 13:00:00'),
('OR003', 'CU003', 'CA003', 150.25, '2024-04-12 11:00:00');

# Modifying some tables to add foreign key
alter table campaigns
add constraint unique_channel UNIQUE (channel);
alter table customers
add constraint fk_customer_channel
foreign key (channel) REFERENCES campaigns(channel);

# Starting with Queries:
# How many customers signed up from each marketing channel?”
select channel, count(customer_id) as total_customers
from customers
group by channel;

# How many times was each page type visited per day?
select page_type, date (timestamp) as date_visited,
count(*) as total_visits
from events
group by page_type, date_visited
order by page_type, date_visited;

# What percentage of customers added items to their cart but didn’t place an order?
select count(*) as total_carts,
(select count(distinct cart_id) from orders) as total_orders,
(count(*) - (select count(distinct cart_id) from orders))
/ count(*) * 100 as carts_abonndoned_rate
from carts;

# Which marketing channel generated the highest number of orders and revenue?
select c.channel, sum(o.order_amount) as revenue,
count(o.order_id) as highest_orders
from customers as c
join orders as o on c.customer_id = o.customer_id
group by c.channel;

# How long it takes customers to place an order after signing up.
select c.customer_id, c.signup_date, o.order_time,
timestampdiff(day, c.signup_date, o.order_time) as time_takes
from customers as c
join orders as o on c.customer_id = o.customer_id;

# What is the average cart size and corresponding order value per customer?
select c.customer_id, avg(a.items) as avg_items_added,
avg(o.order_amount) as avg_order_value
from customers as c
join carts as a on c.customer_id = a.customer_id
join orders as o on a.cart_id = o.cart_id
group by c.customer_id;

# How does order volume and revenue trend over time (daily or weekly)?
select date(o.order_time) as order_date, count(*) as total_orders,
sum(o.order_amount) as total_revenue
from orders as o
group by order_date
order by order_date;

# How many users dropped off at each stage of the funnel (homepage → product → cart → order)?
select (select count(distinct customer_id) from events where page_type = 'homepage') as homepage_visitors,
(select count(distinct customer_id) from events where page_type = 'product_page') as product_page_visitors,
(select count(distinct customer_id) from carts) as cart_creators,
(select count(distinct customer_id) from orders) as purchasers;

# Which marketing campaign channel has the highest average order value?
select c.channel, avg(o.order_amount) as avg_order_value,
count(o.order_id) as total_orders
from customers as c
join orders as o on c.customer_id = o.customer_id
group by c.channel
order by avg_order_value desc;

# Which customers are the most valuable based on their total order amount and how many orders they placed?
select c.customer_id, count(o.order_id) as total_orders,
sum(o.order_amount) as total_revenue
from customers as c
join orders as o on c.customer_id = o.customer_id
group by c.customer_id
order by total_revenue desc;

   # END 



