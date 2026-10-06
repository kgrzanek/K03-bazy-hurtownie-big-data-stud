# K03 — Systemy baz danych, hurtownie danych i Big Data

Materiały laboratoryjne do przedmiotu **Systemy baz danych, hurtownie danych
i Big Data** (Sztuczna inteligencja w zastosowaniach, II st., semestr 1).

## Jak zacząć — raz, na początku semestru

1. Załóżcie darmowe konto GitHub (jeśli go nie macie).
2. Na tej stronie: **Use this template → Create a new repository**. Właściciel:
   **wasze konto**; nazwa np. `K03`; widoczność **Private**. Powstaje **wasze
   własne repozytorium** — tam zapisujecie pracę z laboratoriów i projektu.
3. W **waszym** repozytorium: **Code → Codespaces → Create codespace on master**.
   Pierwsze uruchomienie trwa kilka minut; kolejne — kilkanaście sekund.
4. W terminalu: `psql` — konsola bazy `olist`.

Codespace tworzycie zawsze z **waszego** repozytorium, nie z tego. Jeden
Codespace na cały przedmiot — wracajcie do istniejącego
(`github.com/codespaces`). Zatrzymuje się sam po 30 minutach bezczynności;
baza z danymi zostaje na następne zajęcia.

## Zapisywanie pracy

Po każdych zajęciach, w terminalu Codespace:

```bash
git add -A
git commit -m "LAB1"
git push
```

Praca trafia do waszego repozytorium na GitHubie. Niezatwierdzone zmiany
istnieją tylko w Codespace — a nieużywany Codespace GitHub po pewnym czasie
usuwa.

## Nowe laboratoria

Przed każdymi zajęciami w Codespace:

```bash
make pobierz L=LAB2      # numer laboratorium z zajęć
git commit -m "pobrane LAB2" && git push
```

Polecenie kopiuje z repozytorium prowadzącego tylko katalog nowego
laboratorium i pliki środowiska — wasze rozwiązania wcześniejszych laboratoriów
zostają nietknięte. **Nie używajcie `git pull` z tego repozytorium** — wasze
repozytorium ma osobną historię i git odmówi połączenia.

## Laboratoria

- [`lab/LAB1`](lab/LAB1/README.md)

Dane: Olist, *Brazilian E-Commerce Public Dataset*, CC BY-NC-SA 4.0 —
`dane/olist/ZRODLO.md`.
