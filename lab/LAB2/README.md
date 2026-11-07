# LAB2 — zapytania na bazie sklepu

**K3 Systemy baz danych, hurtownie danych i Big Data** · laboratorium 2 (temat L2:
zapytania SQL — złączenia, agregacje, podzapytania, funkcje okna, indeks i plan zapytania)

Dziś **pytacie** bazę, którą zbudowaliście w LAB1: zamówienia, pozycje, klienci,
sprzedawcy i recenzje sklepu Olist. Cztery rodzaje złączeń, agregaty z `HAVING`,
podzapytania i CTE, funkcje okna — a na końcu zapytanie, które **nie kończy się**,
i indeks, który je ratuje. Wszystko to z wykładu S2 (slajdy 8–11 i 13–24).

## 0. Start (5 min)

1. Wróćcie do **swojego** Codespace (`github.com/codespaces`) — baza z LAB1 w nim
   została. Nowe laboratorium: `make pobierz L=LAB2`, potem
   `git commit -m "pobrane LAB2" && git push`.
2. `psql` — konsola bazy `olist`. Punkt 0 pliku `LAB2.sql` sprawdza, czy są dane:
   `orders` 99 441, `order_items` 112 650, `order_reviews` 99 224.
3. Jeśli czegoś brakuje (np. nie skończyliście LAB1 albo zaczynacie w nowym
   Codespace): `\i lab/LAB2/odbudowa.sql` — kasuje i ładuje wszystko od nowa
   (ok. 10 s). Psql uruchamiajcie z **głównego katalogu** repozytorium.

Plik `LAB2.sql` uruchamiacie fragmentami (psql albo SQLTools, jak w LAB1).
**Punkt 5 robicie w psql** — potrzebne `\timing` i `EXPLAIN`.

## 1. Złączenia (15 min)

Cztery rodzaje złączeń z wykładu: `INNER`, `LEFT`, `RIGHT`, `FULL OUTER`.
**Najpierw zapiszcie przewidywanie, potem policzcie:** ile wierszy da każde z nich
dla `orders` i `order_items`? Dalej: zamówienia **bez recenzji** (`LEFT JOIN` +
warunek na brak pary) i złączenie czterech tabel naraz.

**Pytanie 1:** czemu `RIGHT JOIN` daje tyle samo co `INNER JOIN`?
**Pytanie 2:** ile wierszy daje `orders JOIN order_reviews`, a ile różnych zamówień
ma recenzję? Skąd różnica? **Pytanie 3:** dla jakiego odsetka pozycji klient
i sprzedawca są z tego samego stanu?

## 2. Agregacje (15 min)

`GROUP BY`, `HAVING` (filtruje **grupy**, nie wiersze), `NULL` w agregatach:
najlepsze miesiące, kategorie produktów, najwięksi sprzedawcy, `count(*)` kontra
`count(kolumna)`.

**Pytanie 4:** co robić z produktami bez kategorii? **Pytanie 5:** dlaczego
`count(*)` i `count(order_delivered_customer_date)` dają różne liczby i ile
zamówień „dostarczonych” nie ma daty dostawy?

## 3. Podzapytania i CTE (15 min)

Wartość zamówienia i zamówienia powyżej średniej (`WITH … AS`), `EXISTS`, `IN`,
`NOT EXISTS`.

**Pytanie 6:** dlaczego powyżej średniej wartości jest mniej niż połowa zamówień?
**Pytanie 7:** czym różnią się `EXISTS`, `IN` i `NOT EXISTS` — kiedy wolimy które?

## 4. Funkcje okna (15 min)

`rank() OVER (PARTITION BY … ORDER BY …)`, suma narastająca, `lag()`. Funkcja okna
liczy „po sąsiadach” w obrębie **partycji**, ale **nie zwija** wierszy jak
`GROUP BY`.

**Pytanie 8:** usuńcie `PARTITION BY` z rankingu sprzedawców — co się zmieni
i dlaczego? Ćwiczenie c zróbcie w domu.

## 5. Indeks i plan zapytania (25 min) — w psql

1. **Zapytanie, które nie kończy się:** dla każdej pozycji — średnia cena jej
   produktu. Limit 10 s. **Pytanie 9:** co się stało i dlaczego?
2. **Indeks na `product_id`** i `EXPLAIN (ANALYZE, BUFFERS)` przed i po. **Pytanie 10:**
   o ile spadła liczba stron i czas; ile miejsca zajmuje indeks? Potem to samo
   zapytanie z punktu 1 — już się kończy.
3. **Selektywność:** indeks na statusie zamówienia i dwa plany. **Pytanie 11:**
   który plan wybrała baza dla `'delivered'` (97% wierszy), a który dla `'approved'`?
4. **Indeks złożony** `(seller_id, shipping_limit_date)` i trzy zapytania.
   **Pytanie 12:** dlaczego zapytanie tylko po dacie nie używa tego indeksu?
5. **Sprzątanie:** usuwamy indeksy z tego laboratorium.

Czasy na waszym Codespace będą **inne** niż na wykładzie (mniej rdzeni) —
porównujcie **plany i liczby stron**, nie milisekundy.

## Przed wyjściem

`git add -A`, `git commit -m "LAB2"`, `git push`. Codespace zatrzyma się sam po
30 minutach bezczynności; baza z danymi zostanie na następne zajęcia.

---

*Dane: Olist, Brazilian E-Commerce Public Dataset, CC BY-NC-SA 4.0 —
szczegóły w `dane/olist/ZRODLO.md`.*
