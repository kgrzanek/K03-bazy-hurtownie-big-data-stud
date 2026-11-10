-- Odbudowa bazy z LAB1: pięć tabel Olist (customers, sellers, products, orders,
-- Wersja: b0ac06a z 2026-11-10
-- order_items) i order_reviews. Uruchamiacie TYLKO wtedy, gdy po LAB1 w bazie
-- brakuje tabel albo wierszy (sprawdzenie: punkt 0 w LAB2.sql). Kasuje i ładuje od nowa.
-- Z głównego katalogu repozytorium:  psql -f lab/LAB2/odbudowa.sql
-- (ścieżki do danych względne, jak w LAB1)

\set ON_ERROR_STOP on

DROP TABLE IF EXISTS order_reviews, order_payments, order_items, orders,
                     products, sellers, customers CASCADE;

CREATE TABLE customers (
    customer_id              text PRIMARY KEY,
    customer_unique_id       text NOT NULL,
    customer_zip_code_prefix text NOT NULL,
    customer_city            text NOT NULL,
    customer_state           char(2) NOT NULL
);
CREATE TABLE sellers (
    seller_id              text PRIMARY KEY,
    seller_zip_code_prefix text NOT NULL,
    seller_city            text NOT NULL,
    seller_state           char(2) NOT NULL
);
CREATE TABLE products (
    product_id                 text PRIMARY KEY,
    product_category_name      text,
    product_name_lenght        integer,
    product_description_lenght integer,
    product_photos_qty         integer,
    product_weight_g           integer,
    product_length_cm          integer,
    product_height_cm          integer,
    product_width_cm           integer
);
CREATE TABLE orders (
    order_id                      text PRIMARY KEY,
    customer_id                   text NOT NULL REFERENCES customers,
    order_status                  text NOT NULL,
    order_purchase_timestamp      timestamp NOT NULL,
    order_approved_at             timestamp,
    order_delivered_carrier_date  timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp NOT NULL
);
CREATE TABLE order_items (
    order_id            text NOT NULL REFERENCES orders,
    order_item_id       integer NOT NULL,
    product_id          text NOT NULL REFERENCES products,
    seller_id           text NOT NULL REFERENCES sellers,
    shipping_limit_date timestamp NOT NULL,
    price               numeric(10, 2) NOT NULL CHECK (price > 0),
    freight_value       numeric(10, 2) NOT NULL CHECK (freight_value >= 0),
    PRIMARY KEY (order_id, order_item_id)
);
CREATE TABLE order_reviews (
    review_id               text NOT NULL,
    order_id                text NOT NULL REFERENCES orders,
    review_score            smallint NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title    text,
    review_comment_message  text,
    review_creation_date    timestamp NOT NULL,
    review_answer_timestamp timestamp NOT NULL,
    PRIMARY KEY (review_id, order_id)
);

\copy customers   FROM PROGRAM 'gzip -dc dane/olist/customers.csv.gz'   WITH (FORMAT csv, HEADER true)
\copy sellers     FROM PROGRAM 'gzip -dc dane/olist/sellers.csv.gz'     WITH (FORMAT csv, HEADER true)
\copy products    FROM PROGRAM 'gzip -dc dane/olist/products.csv.gz'    WITH (FORMAT csv, HEADER true)
\copy orders      FROM PROGRAM 'gzip -dc dane/olist/orders.csv.gz'      WITH (FORMAT csv, HEADER true)
\copy order_items FROM PROGRAM 'gzip -dc dane/olist/order_items.csv.gz' WITH (FORMAT csv, HEADER true)
\copy order_reviews FROM PROGRAM 'gzip -dc dane/olist/order_reviews.csv.gz' WITH (FORMAT csv, HEADER true)

ANALYZE;
SELECT 'customers' AS tabela, count(*) AS wierszy FROM customers
UNION ALL SELECT 'sellers', count(*) FROM sellers
UNION ALL SELECT 'products', count(*) FROM products
UNION ALL SELECT 'orders', count(*) FROM orders
UNION ALL SELECT 'order_items', count(*) FROM order_items
UNION ALL SELECT 'order_reviews', count(*) FROM order_reviews;
