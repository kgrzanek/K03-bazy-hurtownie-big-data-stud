# LAB1 — baza transakcyjna sklepu

**K3 Systemy baz danych, hurtownie danych i Big Data** · laboratorium 1 (temat L1:
projektowanie i implementacja relacyjnej bazy danych — modelowanie, SQL DDL/DML)

Dziś budujecie **bazę transakcyjną** sklepu internetowego Olist — tę z lewej
strony schematu z wykładu S1: tabele, klucze, ładowanie prawdziwych danych
(99 441 zamówień z lat 2016–2018), transakcja i pierwsze zapytania. Przy okazji
zobaczycie, że prawdziwe dane łamią założenia, które wydają się oczywiste.

## 0. Start (10 min)

1. Na stronie repozytorium: **Code → Codespaces → Create codespace on main**.
   Pierwsze uruchomienie trwa kilka minut (instalacja narzędzi, start
   PostgreSQL). Kolejne — kilkanaście sekund.
2. W terminalu na dole okna: `psql`. Powinniście zobaczyć znak zachęty
   `olist=#`. Połączenie jest skonfigurowane — hasło nie jest potrzebne.
3. Sprawdźcie: `\conninfo` (z kim i gdzie jesteście połączeni) i `\q` (wyjście).

**Dwa sposoby pracy z plikiem `LAB1.sql`** — wybierzcie wygodniejszy:

- **psql:** `\i lab/LAB1/LAB1.sql` uruchamia cały plik; fragment — skopiujcie
  do psql;
- **VS Code:** otwórzcie `LAB1.sql`, zaznaczcie fragment i **Ctrl+E Ctrl+E**
  (rozszerzenie SQLTools, połączenie „olist (PostgreSQL)” — wybrać przy
  pierwszym użyciu); wynik pojawia się w tabelce obok.

Psql uruchamiajcie z **głównego katalogu** repozytorium — ścieżki do danych
(`dane/olist/...`) są względne.

## 1. Model (10 min)

Pięć tabel i powiązania między nimi:

```
customers 1 ── * orders 1 ── * order_items * ── 1 products
                                      *
                                      └──────── 1 sellers
```

Czytamy: jeden klient (`customers`) ma wiele zamówień (`orders`), jedno
zamówienie — wiele pozycji (`order_items`); każda pozycja to jeden produkt
od jednego sprzedawcy.

Odpowiedzcie (bez pisania SQL): **który atrybut jednoznacznie wskazuje pozycję
zamówienia?** Pozycje są numerowane od 1 w każdym zamówieniu.

## 2. Tabele zamówień i pozycji (25 min)

Tabele `customers`, `sellers`, `products` są gotowe w pliku. Napiszcie
`CREATE TABLE` dla **`orders`** i **`order_items`** — w pliku są opisy kolumn
i miejsca `-- uzupełnijcie`. Pamiętajcie o:

- **kluczu głównym** (`PRIMARY KEY`) — w `order_items` złożonym z dwóch kolumn;
- **kluczach obcych** (`REFERENCES`) — skąd dokąd wskazują;
- `NOT NULL` tam, gdzie wartość musi być;
- typach: identyfikatory `text`, daty `timestamp`, kwoty `numeric(10, 2)`.

Sprawdźcie efekt: `\d orders`, `\d order_items`.

## 3. Ładowanie (10 min)

Polecenie `\copy` z pliku. **Pytanie 1:** spróbujcie załadować pozycje
**przed** zamówieniami. Co się dzieje i dlaczego? Ile wierszy trafiło do
tabeli? Potem ładujcie we właściwej kolejności i sprawdźcie liczby wierszy.

## 4. Klucze w działaniu (10 min)

Trzy operacje, które baza powinna odrzucić. **Pytanie 2:** który mechanizm
zatrzymał każdą z nich? Podajcie nazwę ograniczenia z komunikatu błędu.

## 5. Transakcja (10 min)

Nowe zamówienie z dwiema pozycjami między `BEGIN` a `ROLLBACK`. Sprawdźcie
wartość zamówienia przed wycofaniem i to, że po `ROLLBACK` zamówienia nie ma.

## 6. Pierwsze zapytania (15 min)

Trzy ćwiczenia w pliku: (a) zamówienia **bez** pozycji — w podziale na status;
(b) pięć stanów Brazylii o największej sprzedaży; (c) ile jest `customer_id`,
a ile różnych osób (`customer_unique_id`).

**Pytanie 3** (do ćwiczenia c): co w tym zbiorze naprawdę oznacza „klient”?
Jak to wpływa na pytanie „ilu klientów wróciło po drugie zakupy”?

## 7. Zrób to sam: recenzje

Tabela `order_reviews` z kluczem głównym `review_id`. Załadujcie dane.
**Pytanie 4:** co się stało? Znajdźcie przyczynę i zaproponujcie klucz główny,
który dane rzeczywiście spełniają. To, czego nie skończycie w sali —
dokończcie w domu, w tym samym Codespace.

## Przed wyjściem

Nic nie musicie wyłączać — Codespace zatrzyma się sam po 30 minutach
bezczynności, a baza z danymi zostanie na następne zajęcia. Jeśli zmienialiście
pliki: `git add`, `git commit`, `git push`.

---

*Dane: Olist, Brazilian E-Commerce Public Dataset, CC BY-NC-SA 4.0 —
szczegóły w `dane/olist/ZRODLO.md`.*
