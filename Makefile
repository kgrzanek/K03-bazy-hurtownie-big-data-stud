SHELL := /bin/bash

.PHONY: pg psql stop

## pg — uruchamia PostgreSQL (w Codespace robi to sam przy starcie)
pg:
	@docker compose --profile pg up -d --wait

## psql — konsola bazy olist
psql:
	@psql

## stop — zatrzymuje serwery (dane zostają)
stop:
	@docker compose --profile pg down
