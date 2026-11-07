-- LAB2 — zapytania na bazie sklepu: złączenia, agregacje, podzapytania, funkcje okna, indeks i plan
-- Wersja: 79752ab z 2026-11-07
-- K3 Systemy baz danych, hurtownie danych i Big Data · laboratorium 2 (temat L2)
--
-- Jak pracować: instrukcja w README.md obok. Fragmenty tego pliku uruchamiacie
-- po kolei — w psql (`\i lab/LAB2/LAB2.sql` uruchamia cały plik) albo zaznaczając
-- fragment w VS Code (SQLTools: Ctrl+E Ctrl+E). Miejsca do uzupełnienia:
-- `-- uzupełnijcie`. Punkt 5 robicie w psql (potrzebne `\timing` i `EXPLAIN`).

\set ON_ERROR_STOP off
\timing off

-- ===========================================================================
-- 0. Sprawdzenie bazy (z LAB1)
-- ===========================================================================
-- Powinno wyjść: orders 99441, order_items 112650, order_reviews 99224.
-- Jeśli czegoś brakuje albo liczby są inne: `\i lab/LAB2/odbudowa.sql`.

SELECT 'orders' AS tabela, count(*) AS wierszy FROM orders
UNION ALL SELECT 'order_items', count(*) FROM order_items
UNION ALL SELECT 'order_reviews', count(*) FROM order_reviews;

-- ===========================================================================
-- 1. Złączenia (wykład S2, slajdy 8–11)
-- ===========================================================================
-- ĆWICZENIE a: zapiszcie przewidywanie, potem policzcie. Ile wierszy da złączenie
-- orders (A) z order_items (B) — INNER, LEFT, RIGHT i FULL OUTER JOIN po order_id?
-- Jedno zapytanie z czterema liczbami (UNION ALL).
-- uzupełnijcie
-- Pytanie 1: czemu RIGHT JOIN daje tyle samo co INNER JOIN? Co to mówi o kluczu obcym?

-- ĆWICZENIE b: ile zamówień NIE MA żadnej recenzji (tabela order_reviews)?
-- (Wskazówka: LEFT JOIN i warunek na brakujący wiersz po prawej stronie.)
-- uzupełnijcie

-- Pytanie 2: ile wierszy da zwykły JOIN orders z order_reviews i ile różnych
-- zamówień ma recenzję? Dlaczego te liczby się różnią?
SELECT count(*) AS wierszy_join, count(DISTINCT o.order_id) AS roznych_zamowien
FROM orders o JOIN order_reviews r ON r.order_id = o.order_id;

-- ĆWICZENIE c: cztery tabele naraz. Dla ilu pozycji klient i sprzedawca są
-- z tego samego stanu (customer_state = seller_state)? Podajcie liczbę i odsetek.
-- (Ścieżka: order_items → orders → customers oraz order_items → sellers.)
-- uzupełnijcie
-- Pytanie 3: co oznacza ten odsetek dla dostaw (hipoteza, nie wniosek z danych)?

-- ===========================================================================
-- 2. Agregacje: GROUP BY, HAVING, NULL
-- ===========================================================================
-- ĆWICZENIE a: pięć miesięcy o największej sprzedaży (suma price), tylko
-- zamówienia dostarczone. Miesiąc: date_trunc('month', order_purchase_timestamp).
-- Pokażcie też liczbę zamówień (DISTINCT!).
-- uzupełnijcie

-- ĆWICZENIE b: pięć kategorii produktów (product_category_name) o największej
-- sprzedaży; liczba pozycji i suma zaokrąglona do całości. Część produktów nie
-- ma kategorii (NULL) — pokażcie je jako „(brak)” (coalesce) i podajcie, ile
-- pozycji ich dotyczy.
-- uzupełnijcie
-- Pytanie 4: co robić z produktami bez kategorii — pominąć, oznaczyć, uzupełnić?

-- ĆWICZENIE c: HAVING filtruje GRUPY. Ilu sprzedawców ma co najmniej 1000 pozycji?
-- Pokażcie trzech największych: liczba pozycji i średnia cena.
-- uzupełnijcie

-- ĆWICZENIE d: NULL w agregatach. count(*) liczy wiersze, count(kolumna) —
-- tylko wypełnione. Ile zamówień ma order_delivered_customer_date, a ile nie?
-- Ile jest zamówień o statusie 'delivered' BEZ daty dostawy?
-- uzupełnijcie
-- Pytanie 5: dlaczego count(*) i count(kolumna) dają różne liczby? Jak policzyć
-- średni czas dostawy i co robi z NULL funkcja avg()?

-- ===========================================================================
-- 3. Podzapytania i CTE
-- ===========================================================================
-- ĆWICZENIE a: wartość zamówienia = suma price jego pozycji. Ile zamówień ma
-- wartość WYŻSZĄ niż średnia wartość zamówienia? Podajcie też samą średnią.
-- Użyjcie CTE (WITH ... AS), żeby nie liczyć wartości dwa razy.
-- uzupełnijcie
-- Pytanie 6: dlaczego powyżej średniej wartości jest mniej niż połowa zamówień?

-- ĆWICZENIE b: ile zamówień dostało co najmniej jedną recenzję z oceną 1
-- (review_score = 1)? Napiszcie dwa razy: z EXISTS i z IN. Wyniki mają być równe.
-- uzupełnijcie

-- ĆWICZENIE c: to samo pytanie co 1b (zamówienia bez recenzji), ale z NOT EXISTS.
-- uzupełnijcie
-- Pytanie 7: czym różnią się EXISTS, IN i NOT EXISTS (i porównanie z LEFT JOIN
-- z ćwiczenia 1b)? Kiedy wolicie które?

-- ===========================================================================
-- 4. Funkcje okna
-- ===========================================================================
-- Funkcja okna liczy wartość „po sąsiadach” w obrębie PARTYCJI, ale NIE zwija
-- wierszy (w przeciwieństwie do GROUP BY). Składnia: funkcja() OVER (PARTITION BY … ORDER BY …).

-- ĆWICZENIE a: trzech sprzedawców o największej sprzedaży w stanach SP i RJ
-- (seller_state z tabeli sellers). Użyjcie rank() OVER (PARTITION BY stan ORDER BY sprzedaz DESC).
-- Okno nie może stać w WHERE — potrzebne CTE albo podzapytanie.
-- uzupełnijcie
-- Pytanie 8: usuńcie PARTITION BY stan z funkcji rank() — co się zmieni i dlaczego?

-- ĆWICZENIE b: sprzedaż miesięczna w 2017 roku (zamówienia dostarczone):
-- sprzedaż, SUMA NARASTAJĄCA od początku roku (sum() OVER (ORDER BY miesiac))
-- i zmiana procentowa względem poprzedniego miesiąca (lag()).
-- uzupełnijcie

-- ĆWICZENIE c (w domu): najdroższa pozycja KAŻDEGO zamówienia — row_number()
-- OVER (PARTITION BY order_id ORDER BY price DESC, order_item_id). Pokażcie trzy
-- zamówienia o najdroższych takich pozycjach i policzcie wszystkie wiersze wyniku.
-- uzupełnijcie

-- ===========================================================================
-- 5. Indeks i plan zapytania (wykład S2, slajdy 13–24) — TYLKO w psql
-- ===========================================================================
\timing on

-- 5.1. Zapytanie skorelowane: dla każdej pozycji liczy średnią cenę JEJ produktu.
-- Ile pozycji kosztuje więcej niż średnia ich produktu? Ustawiamy limit 10 s —
-- na tym etapie baza nie ma indeksu po product_id.
SET statement_timeout = '10s';
SELECT count(*) AS powyzej_sredniej_produktu
FROM order_items i
WHERE i.price > (SELECT avg(price) FROM order_items i2 WHERE i2.product_id = i.product_id);
RESET statement_timeout;
-- Pytanie 9: co się stało i dlaczego? (Ile razy baza musiałaby czytać tabelę?)

-- 5.2. Plan jednego produktu. Najpierw bez indeksu na product_id (jest tylko
-- klucz główny po (order_id, order_item_id)). Co wybiera baza? Ile stron czyta
-- (Buffers: shared hit=…)?
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM order_items WHERE product_id = '00905d58c87afcbce21420b3712cacaa';

-- ĆWICZENIE: załóżcie indeks na order_items(product_id), powtórzcie EXPLAIN
-- (ANALYZE, BUFFERS) i porównajcie: węzeł planu, liczba stron, czas. Potem
-- sprawdźcie rozmiary: pg_size_pretty(pg_relation_size(...)) tabeli i indeksu.
-- uzupełnijcie
-- Pytanie 10: o ile spadła liczba stron i czas? Ile miejsca zajmuje indeks?

-- Teraz ponówcie zapytanie z 5.1 (limit 10 s zostaje wyłączony):
SELECT count(*) AS powyzej_sredniej_produktu
FROM order_items i
WHERE i.price > (SELECT avg(price) FROM order_items i2 WHERE i2.product_id = i.product_id);

-- 5.3. Selektywność. Indeks na status zamówienia — i dwa zapytania: o status
-- 'delivered' (97% wierszy) i 'approved' (kilka wierszy). Porównajcie PLANY (sam
-- EXPLAIN, bez ANALYZE).
CREATE INDEX orders_status ON orders (order_status);
ANALYZE orders;
EXPLAIN SELECT max(order_estimated_delivery_date) FROM orders WHERE order_status = 'delivered';
EXPLAIN SELECT max(order_estimated_delivery_date) FROM orders WHERE order_status = 'approved';
-- Pytanie 11: który plan wybrała baza w każdym przypadku i dlaczego?

-- 5.4. Indeks złożony. Założenie: zapytania o pozycje jednego sprzedawcy
-- w przedziale dat wysyłki.
CREATE INDEX order_items_seller_data ON order_items (seller_id, shipping_limit_date);

-- ĆWICZENIE: sprawdźcie PLAN (EXPLAIN) trzech zapytań i zapiszcie, które
-- używają indeksu złożonego: (i) sam sprzedawca, (ii) sam przedział dat
-- (1.08.2018, jeden dzień), (iii) sprzedawca i sierpień 2018.
-- Sprzedawca: '6560211a19b47992c3666cc44a7e94c0'.
-- uzupełnijcie
-- Pytanie 12: dlaczego (ii) nie używa indeksu, choć kolumna jest w jego składzie?

-- 5.5. Sprzątanie: usuwamy indeksy z tego laboratorium, żeby baza wróciła do
-- stanu z LAB1 (każdy indeks spowalnia zapis i zajmuje miejsce).
DROP INDEX order_items_product, orders_status, order_items_seller_data;
\timing off
