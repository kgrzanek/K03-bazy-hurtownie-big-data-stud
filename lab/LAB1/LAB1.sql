-- LAB1 — baza transakcyjna sklepu: tabele, klucze, ładowanie, pierwsze zapytania
-- Wersja: 87da236 z 2026-10-06
-- K3 Systemy baz danych, hurtownie danych i Big Data · laboratorium 1 (temat L1)
--
-- Jak pracować: instrukcja w README.md obok. Fragmenty tego pliku uruchamiacie
-- po kolei — w psql (`\i lab/LAB1/LAB1.sql` uruchamia cały plik) albo zaznaczając
-- fragment w VS Code (SQLTools: Ctrl+E Ctrl+E). Miejsca do uzupełnienia:
-- `-- uzupełnijcie`. Psql uruchamiajcie z katalogu głównego repozytorium —
-- ścieżki do danych (`dane/olist/...`) są względne.

\set ON_ERROR_STOP off
\timing off

-- ===========================================================================
-- 1. Tabele podane: klienci, sprzedawcy, produkty
-- ===========================================================================
-- Identyfikatory w Olist to 32-znakowe napisy szesnastkowe — typ text.
-- UWAGA na klientów: customer_id to klient W JEDNYM ZAMÓWIENIU; ta sama osoba
-- składająca drugie zamówienie dostaje nowy customer_id, a wspólne ma tylko
-- customer_unique_id. Wrócimy do tego w punkcie 6.

DROP TABLE IF EXISTS order_reviews, order_payments, order_items, orders,
                     products, sellers, customers CASCADE;

CREATE TABLE customers (
    customer_id              text PRIMARY KEY,
    customer_unique_id       text NOT NULL,
    customer_zip_code_prefix text NOT NULL,   -- kod jako napis: wiodące zera
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
    product_category_name      text,          -- bywa puste
    product_name_lenght        integer,       -- literówka „lenght” jest w oryginale
    product_description_lenght integer,
    product_photos_qty         integer,
    product_weight_g           integer,
    product_length_cm          integer,
    product_height_cm          integer,
    product_width_cm           integer
);

-- ===========================================================================
-- 2. ĆWICZENIE: zamówienia i ich pozycje
-- ===========================================================================
-- orders: klucz główny order_id; customer_id wskazuje klienta (klucz obcy);
-- order_status zawsze wypełniony; pięć znaczników czasu (timestamp), z których
-- tylko order_purchase_timestamp i order_estimated_delivery_date są zawsze
-- wypełnione. Kolejność kolumn jak w pliku CSV:
--   order_id, customer_id, order_status, order_purchase_timestamp,
--   order_approved_at, order_delivered_carrier_date,
--   order_delivered_customer_date, order_estimated_delivery_date

-- uzupełnijcie

-- order_items: jedna pozycja zamówienia. Pozycje numerowane od 1 w obrębie
-- zamówienia (order_item_id), więc klucz główny jest ZŁOŻONY z dwóch kolumn.
-- Trzy klucze obce: do orders, products, sellers. Kwoty w realach — typ
-- numeric(10,2), nie float (pieniądze liczymy dokładnie). Kolumny jak w CSV:
--   order_id, order_item_id, product_id, seller_id, shipping_limit_date,
--   price, freight_value

-- uzupełnijcie

\d order_items

-- ===========================================================================
-- 3. Ładowanie danych
-- ===========================================================================
-- \copy czyta plik po stronie klienta (psql) i wysyła go do serwera.
-- FROM PROGRAM: rozpakowuje gzip w locie. HEADER: pierwszy wiersz to nazwy.

\copy customers FROM PROGRAM 'gzip -dc dane/olist/customers.csv.gz' WITH (FORMAT csv, HEADER true)
\copy sellers   FROM PROGRAM 'gzip -dc dane/olist/sellers.csv.gz'   WITH (FORMAT csv, HEADER true)
\copy products  FROM PROGRAM 'gzip -dc dane/olist/products.csv.gz'  WITH (FORMAT csv, HEADER true)

-- Pytanie 1: spróbujcie załadować POZYCJE przed ZAMÓWIENIAMI. Co się dzieje
-- i dlaczego? Ile wierszy trafiło do tabeli?
\copy order_items FROM PROGRAM 'gzip -dc dane/olist/order_items.csv.gz' WITH (FORMAT csv, HEADER true)
SELECT count(*) AS order_items_po_nieudanej_probie FROM order_items;

-- Teraz we właściwej kolejności:
\copy orders      FROM PROGRAM 'gzip -dc dane/olist/orders.csv.gz'      WITH (FORMAT csv, HEADER true)
\copy order_items FROM PROGRAM 'gzip -dc dane/olist/order_items.csv.gz' WITH (FORMAT csv, HEADER true)

SELECT 'customers' AS tabela, count(*) AS wierszy FROM customers
UNION ALL SELECT 'sellers', count(*) FROM sellers
UNION ALL SELECT 'products', count(*) FROM products
UNION ALL SELECT 'orders', count(*) FROM orders
UNION ALL SELECT 'order_items', count(*) FROM order_items;

-- ===========================================================================
-- 4. Klucze w działaniu
-- ===========================================================================
-- Pozycja do zamówienia, którego nie ma:
INSERT INTO order_items VALUES
    ('brak-takiego-zamowienia', 1, (SELECT min(product_id) FROM products),
     (SELECT min(seller_id) FROM sellers), now(), 10.00, 0.00);

-- Usunięcie klienta, który ma zamówienie:
DELETE FROM customers
WHERE customer_id = (SELECT customer_id FROM orders ORDER BY order_id LIMIT 1);

-- Druga pozycja o tym samym numerze w tym samym zamówieniu:
INSERT INTO order_items
SELECT order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value
FROM order_items ORDER BY order_id, order_item_id LIMIT 1;

-- Pytanie 2: który mechanizm zatrzymał każdą z trzech operacji? Podajcie nazwę
-- ograniczenia z komunikatu błędu.

-- ===========================================================================
-- 5. Nowe zamówienie w transakcji
-- ===========================================================================
-- BEGIN … ROLLBACK: wszystko w środku albo zostanie zatwierdzone (COMMIT),
-- albo wycofane w całości (ROLLBACK). Tu wycofujemy — baza wraca do stanu
-- sprzed BEGIN.

BEGIN;
INSERT INTO orders (order_id, customer_id, order_status, order_purchase_timestamp,
                    order_estimated_delivery_date)
VALUES ('lab1-zamowienie', (SELECT min(customer_id) FROM customers), 'created',
        '2018-09-01 12:00', '2018-09-15 12:00');
INSERT INTO order_items VALUES
    ('lab1-zamowienie', 1, (SELECT min(product_id) FROM products),
     (SELECT min(seller_id) FROM sellers), '2018-09-03 12:00', 29.90, 7.50),
    ('lab1-zamowienie', 2, (SELECT max(product_id) FROM products),
     (SELECT max(seller_id) FROM sellers), '2018-09-03 12:00', 149.00, 12.00);
SELECT order_id, sum(price) AS wartosc, count(*) AS pozycji
FROM order_items WHERE order_id = 'lab1-zamowienie' GROUP BY order_id;
ROLLBACK;

SELECT count(*) AS po_rollback FROM orders WHERE order_id = 'lab1-zamowienie';

-- ===========================================================================
-- 6. Pierwsze zapytania
-- ===========================================================================
-- Zamówienia według statusu:
SELECT order_status, count(*) AS zamowien
FROM orders GROUP BY order_status ORDER BY zamowien DESC;

-- ĆWICZENIE a: ile zamówień NIE MA żadnej pozycji — w podziale na status?
-- (Wskazówka: LEFT JOIN i warunek na brakujący wiersz po prawej stronie.)
-- uzupełnijcie

-- ĆWICZENIE b: pięć stanów (customer_state) o największej wartości sprzedaży
-- (suma price z pozycji), tylko zamówienia dostarczone (order_status = 'delivered').
-- uzupełnijcie

-- ĆWICZENIE c: ile jest identyfikatorów customer_id, a ile różnych osób
-- (customer_unique_id)? Ile osób złożyło więcej niż jedno zamówienie?
-- uzupełnijcie

-- ===========================================================================
-- 7. Zrób to sam: recenzje
-- ===========================================================================
-- Plik order_reviews.csv.gz, kolumny: review_id, order_id, review_score (1–5),
-- review_comment_title, review_comment_message, review_creation_date,
-- review_answer_timestamp. Załóżcie tabelę z kluczem głównym review_id
-- i kluczem obcym do orders, załadujcie dane. Co się dzieje?

CREATE TABLE order_reviews (
    review_id               text PRIMARY KEY,
    order_id                text NOT NULL REFERENCES orders,
    review_score            smallint NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title    text,
    review_comment_message  text,
    review_creation_date    timestamp NOT NULL,
    review_answer_timestamp timestamp NOT NULL
);
\copy order_reviews FROM PROGRAM 'gzip -dc dane/olist/order_reviews.csv.gz' WITH (FORMAT csv, HEADER true)

-- Pytanie 3: znajdźcie review_id, które występują w pliku więcej niż raz
-- (wczytajcie plik do tabeli bez klucza głównego), i zaproponujcie klucz
-- główny, który dane spełniają. Załóżcie tabelę z tym kluczem i załadujcie.
-- uzupełnijcie
