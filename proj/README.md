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
| **E2** | model wymiarowy hurtowni w DuckDB z uzasadnieniem ziarna | [`E2.md`](E2.md) | LAB6 (model wymiarowy) |
| **E3** | potok ETL z PostgreSQL do DuckDB, z regułami jakości, idempotentny | [`E3.md`](E3.md) | LAB7 (potok ETL) |
| **E4** | analizy, dokumentacja, prezentacja i obrona | [`E4.md`](E4.md) | ostatnie zajęcia projektowe |

Pojęcia z tabeli — model wymiarowy (ang. *dimensional model*), ziarno (ang. *grain*),
ETL (ang. *extract, transform, load* — pobranie, przekształcenie, załadowanie),
idempotencja — wyjaśniamy na wykładach S3, S5 i S6. Opisy wszystkich etapów są już
tutaj, ale każdy etap wymaga wykładu i laboratorium z ostatniej kolumny tabeli — zaczynaj
go po tych zajęciach.

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
  `gzip`, **razem do 10 MB** — tak, żeby całość zmieściła się w archiwum
  końcowym wysyłanym pocztą (niżej). Przy większych danych wybierz podzbiór i opisz,
  jak powstał, albo dołącz skrypt, który pobiera dane z podanego źródła.

## Oddanie etapu

Każdy etap **pokazujesz prowadzącemu** w formie, która jest dla Ciebie wygodna:
na zajęciach, na konsultacjach albo w spotkaniu w Teams z udostępnionym ekranem.
Pokazujesz działający wynik — uruchomienie od zera i liczby z dokumentacji — oraz
odpowiadasz na pytania o decyzje. Prowadzący mówi, czy etap jest **przyjęty**,
i co poprawić. Wszystko zapisuj w swoim repozytorium (`git add -A`, `git commit`,
`git push`).

## Oddanie całości — archiwum na koniec semestru

Na koniec semestru wysyłasz **całość projektu jako jedno archiwum** pocztą na adres
**kgrzanek@san.edu.pl**:

- archiwum `.zip` o nazwie `K03-Nazwisko-Imie.zip`, w temacie wiadomości
  „K03 projekt — Nazwisko Imię”;
- w środku cały katalog `projekt/`: dokumentacja, SQL, programy w Pythonie, dane
  albo skrypt, który je pobiera — wszystko, czego potrzeba, żeby uruchomić projekt
  od zera poleceniem z `projekt/README.md`;
- rozmiar **do 15 MB**: typowe skrzynki pocztowe przyjmują wiadomości do 20–25 MB,
  a załącznik po zakodowaniu rośnie o około jedną trzecią.

W Codespace archiwum z zatwierdzonej wersji tworzy polecenie
`git archive --format=zip -o K03-Nazwisko-Imie.zip HEAD projekt`; plik pobierasz
z panelu plików (prawy przycisk myszy → *Download*).

**Terminy.** Ostateczny termin dla wszystkich etapów to koniec semestru. Zalecany:
każdy etap przed zajęciami, po których zaczyna się następny (tabela wyżej).
Kolejność jest obowiązkowa: następny etap pokazujesz dopiero po **przyjęciu**
poprzedniego, bo każdy etap korzysta z poprzedniego. Pokazywanie wszystkiego
w ostatnim tygodniu oznacza kolejkę i brak czasu na poprawki. Archiwum końcowe
wysyłasz po przyjęciu E4.

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

**Obrona** (zajęcia projektowe albo spotkanie w Teams): pokazujesz działający system od zera, odpowiadasz
na pytania o każdy jego fragment i o decyzje z dokumentacji. Fragmentu, którego
nie potrafisz wyjaśnić, nie traktuje się jako Twojej pracy. Zasady korzystania
z modeli językowych prowadzący poda osobno.
