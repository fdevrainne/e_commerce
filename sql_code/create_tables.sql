
\c pg_db;

DROP SCHEMA IF EXISTS e_commerce CASCADE;
CREATE SCHEMA e_commerce;


CREATE TABLE e_commerce.customers(
id VARCHAR(50) PRIMARY KEY,    -- customer_id from customer.csv
customer_unique_id VARCHAR(50),
customer_zip_code_prefix DECIMAL,
customer_city VARCHAR(50), 
customer_state VARCHAR(2)
);

CREATE TABLE e_commerce.products(
id VARCHAR(50) PRIMARY KEY,    -- product_id from products.csv
product_category_name VARCHAR(50),
product_name_lenght DECIMAL,
product_description_lenght DECIMAL, 
product_photos_qty INT, 
product_weight_g DECIMAL,
product_length_cm DECIMAL, 
product_height_cm DECIMAL, 
product_width_cm DECIMAL,
product_category_name_english VARCHAR(50)
);

CREATE TABLE e_commerce.orders(
id VARCHAR(50)  PRIMARY KEY,    -- order_id from orders.csv
customer_id VARCHAR(50) REFERENCES e_commerce.customers(id) ,
order_status VARCHAR(30),
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date VARCHAR(50) NULL
);


CREATE TABLE e_commerce.items(
order_id VARCHAR(50) REFERENCES e_commerce.orders(id), 
order_item_id INT,
product_id VARCHAR(50) REFERENCES e_commerce.products(id) ,
seller_id VARCHAR(50),
shipping_limit_date TIMESTAMP,
price DECIMAL, 
freight_value DECIMAL
);

CREATE TABLE e_commerce.customers_stats(
id int PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
customer_id VARCHAR(50),    -- customer_id from customer.csv
day DATE,
amount_spent DECIMAL,
number_order INT
);
CREATE UNIQUE INDEX customer_id_day on e_commerce.customers_stats (customer_id, day);
