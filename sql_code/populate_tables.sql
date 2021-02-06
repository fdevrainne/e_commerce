
\c pg_db;

CREATE TABLE e_commerce.customers_unduplicated(
id VARCHAR(50),  
customer_unique_id VARCHAR(50),
customer_zip_code_prefix DECIMAL,
customer_city VARCHAR(50), 
customer_state VARCHAR(2));

COPY e_commerce.customers_unduplicated
FROM '/data/customer.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO e_commerce.customers
SELECT DISTINCT ON (customers_unduplicated.id) *
FROM e_commerce.customers_unduplicated
ORDER BY customers_unduplicated.id;

DROP TABLE e_commerce.customers_unduplicated;



CREATE TABLE e_commerce.products_uncast(
id VARCHAR(50),
product_category_name VARCHAR(50),
product_name_lenght DECIMAL,
product_description_lenght DECIMAL, 
product_photos_qty DECIMAL, 
product_weight_g DECIMAL,
product_length_cm DECIMAL, 
product_height_cm DECIMAL, 
product_width_cm DECIMAL,
product_category_name_english VARCHAR(50) NULL);

COPY e_commerce.products_uncast
FROM '/data/products.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO e_commerce.products
SELECT 
id, product_category_name, product_name_lenght, product_description_lenght, 
CAST(product_photos_qty AS INTEGER),
product_weight_g, product_length_cm, product_height_cm, product_width_cm, product_category_name_english
FROM e_commerce.products_uncast;

DROP TABLE e_commerce.products_uncast;


COPY e_commerce.orders
FROM '/data/orders.csv'
DELIMITER ','
CSV HEADER;

COPY e_commerce.items
FROM '/data/items.csv'
DELIMITER ','
CSV HEADER;
