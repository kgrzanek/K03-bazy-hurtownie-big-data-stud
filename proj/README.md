# Projekt — mini-system analityczny

**K3 Systemy baz danych, hurtownie danych i Big Data** · Twój indywidualny projekt
semestralny (sylabus: PW1, laboratorium L8; efekty P_U01–P_U05, P_K01)

Twój indywidualny projekt semestralny przeprowadza dane wybranej przez Ciebie
dziedziny przez cały system analityczny, który poznajesz na wykładach
i laboratoriach:

```
źródło (PostgreSQL) ──► potok ETL (Python + SQL) ──► hurtownia (DuckDB) ──► analizy (SQL)
   E1: baza transakcyjna      E3: ładowanie z regułami jakości    E2: model wymiarowy     E4: odpowiedzi na pytania
```

Projekt powstaje w czterech etapach. Każdy etap jest osobno oceniany i każdy
buduje na poprzednim.

| etap | co powstaje | opis | po zajęciach |
|---|---|---|---|
| **E1** | dziedzina, schemat transakcyjny w PostgreSQL, dane załadowane | [`E1.md`](E1.md) | LAB4 (model encja–związek, normalizacja) |
| **E2** | model wymiarowy hurtowni w DuckDB z uzasadnieniem ziarna | `E2.md` (później) | LAB6 (model wymiarowy) |
| **E3** | potok ETL z PostgreSQL do DuckDB, z regułami jakości, idempotentny | `E3.md` (później) | LAB7 (potok ETL) |
| **E4** | analizy, dokumentacja, prezentacja i obrona | `E4.md` (później) | ostatnie zajęcia projektowe |

Pojęcia z tabeli — model wymiarowy (ang. *dimensional model*), ziarno (ang. *grain*),
ETL (ang. *extract, transform, load* — pobranie, przekształcenie, załadowanie),
idempotencja — wyjaśniamy na wykładach S3, S5 i S6. Opis każdego etapu ukazuje się
tutaj przed zajęciami, na których zaczyna się jego materiał.

## Dziedzina i dane

Dziedzinę wybierasz sam: dowolny proces, który zostawia ślad w danych —
sprzedaż, wypożyczenia, przejazdy, pomiary, zgłoszenia. Dane muszą spełniać
warunki z [`E1.md`](E1.md) (punkt „Warunki dla danych”). W skrócie:

- **prawdziwe i otwarte**, ze znanym źródłem i licencją, która pozwala na użycie
  w projekcie;
- **co najmniej trzy powiązane tabele** po normalizacji i co najmniej 10 000 wierszy
  w największej z nich;
- **kolumna daty lub czasu**, bo hurtownia odpowiada na pytania o zmiany w czasie.

Olist z laboratoriów jest dozwolony **w innym przekroju** niż na zajęciach: na
laboratoriach jeden wiersz faktów to pozycja zamówienia, więc w projekcie wybierasz
inne zdarzenie, np. dostawę, płatność albo recenzję, i inne pytania.

## Gdzie i jak pracujesz

- W **swoim** repozytorium (tym z szablonu, z laboratoriów), w katalogu **`projekt/`**.
  Katalog `proj/` zawiera tylko opisy etapów — nie zapisuj w nim swojej pracy.
- W Codespace, tymi samymi narzędziami co na laboratoriach: PostgreSQL, DuckDB,
  Python, SQL. Projekt korzysta z **osobnej bazy** `projekt` (`createdb projekt`),
  nie z bazy `olist` z laboratoriów.
- **Wszystko uruchamia się od zera jednym poleceniem**, opisanym w `projekt/README.md`.
  Etap, którego nie da się odtworzyć w czystym Codespace, nie działa.
- Dane, z których korzystasz, leżą w repozytorium (`projekt/dane/`), spakowane
  `gzip`. GitHub odrzuca pliki większe niż 100 MB — przy większych danych wybierz
  podzbiór i opisz, jak powstał.

## Oddanie etapu

1. Zatwierdź i wypchnij pracę (`git add -A`, `git commit`, `git push`).
2. Oznacz oddawaną wersję etykietą etapu: `git tag e1 && git push --tags`.
   Poprawioną wersję oznaczasz `e1-v2`, `e1-v3`.
3. Raz na semestr: w swoim repozytorium **Settings → Collaborators → Add people**
   dodaj prowadzącego, **`kgrzanek`**, żeby mógł czytać prywatne repozytorium.
4. W swoim repozytorium otwórz zgłoszenie (**Issues → New issue**) o tytule
   „E1 do oceny” i wspomnij w nim prowadzącego (`@kgrzanek`). Ocena i uwagi
   pojawią się w tym zgłoszeniu.

**Terminy.** Ostateczny termin dla wszystkich etapów to koniec semestru. Zalecany:
każdy etap przed zajęciami, po których zaczyna się następny (tabela wyżej).
Kolejność jest obowiązkowa: następny etap oddajesz dopiero po **przyjęciu**
poprzedniego, bo każdy etap korzysta z poprzedniego. Oddanie wszystkiego
w ostatnim tygodniu oznacza kolejkę do oceny i brak czasu na poprawki.

## Ocena

Każdy etap ocenia się w czterech kryteriach, na dwóch poziomach — **wystarczającym**
i **dobrym**. Co oznaczają w danym etapie, mówi jego opis.

| kryterium | pytanie |
|---|---|
| **działa** | czy całość uruchamia się od zera, bez błędów i bez ręcznych poprawek? |
| **mierzy** | czy podajesz liczby (wierszy, odrzuconych rekordów, czasów) z rzeczywistego uruchomienia i czy z nich korzystasz? |
| **uzasadnia** | czy każda decyzja projektowa ma zapisany argument, odwołujący się do danych albo do wykładu? |
| **prezentuje** | czy osoba spoza projektu zrozumie z dokumentacji, co zbudowałeś, po co i jak to sprawdzić? |

| ocena | warunek |
|---:|---|
| 3,0 | E1–E4 przyjęte, każde kryterium każdego etapu co najmniej na poziomie wystarczającym, obrona zaliczona |
| 3,5 | jak 3,0 i co najmniej 4 z 16 kryteriów (4 etapy × 4 kryteria) na poziomie dobrym |
| 4,0 | jak 3,0 i co najmniej 8 z 16 kryteriów na poziomie dobrym |
| 4,5 | jak 3,0 i co najmniej 12 z 16 kryteriów na poziomie dobrym |
| 5,0 | jak 4,5 i **rozszerzenie**: przetwarzanie danych projektu w Sparku albo jako strumień zdarzeń (wykład S7) |

**Obrona** (zajęcia projektowe): pokazujesz działający system od zera, odpowiadasz
na pytania o każdy jego fragment i o decyzje z dokumentacji. Fragmentu, którego
nie potrafisz wyjaśnić, nie traktuje się jako Twojej pracy. Zasady korzystania
z modeli językowych prowadzący poda osobno.
