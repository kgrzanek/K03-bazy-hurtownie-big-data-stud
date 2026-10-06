SHELL := /bin/bash

# Repozytorium prowadzącego, z którego przychodzą nowe laboratoria.
UPSTREAM ?= https://github.com/kgrzanek/K03-bazy-hurtownie-big-data-stud.git
INFRA := .devcontainer compose.yaml Makefile pyproject.toml uv.lock .python-version dane

.PHONY: pg psql stop pobierz

## pg — uruchamia PostgreSQL (w Codespace robi to sam przy starcie)
pg:
	@docker compose --profile pg up -d --wait

## psql — konsola bazy olist
psql:
	@psql

## stop — zatrzymuje serwery (dane zostają)
stop:
	@docker compose --profile pg down

## pobierz L=LAB2 — nowe laboratorium (i aktualne środowisko) z repozytorium prowadzącego.
## Nie łączy historii: kopiuje tylko katalog laboratorium i pliki środowiska.
## Waszych zmian w innych laboratoriach nie rusza; istniejącego katalogu nie nadpisuje.
pobierz:
	@test -n "$(L)" || { echo "użycie: make pobierz L=LAB2"; exit 1; }
	@test ! -e lab/$(L) || { echo "lab/$(L) już jest — nie nadpisuję"; exit 1; }
	@git remote get-url upstream >/dev/null 2>&1 || git remote add upstream $(UPSTREAM)
	@git fetch -q upstream
	@git checkout upstream/master -- lab/$(L) $(INFRA)
	@echo "pobrano lab/$(L); zatwierdźcie: git commit -m 'pobrane $(L)' && git push"
