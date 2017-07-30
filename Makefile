.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

dependencies: ## Install dependencies
	composer install --prefer-dist

lint: ## Run linter and code style checker
	vendor/bin/phplint . --exclude=vendor/
	vendor/bin/phpcs -p --standard=PSR2 --extensions=php --encoding=utf-8 --ignore=*/vendor/* .

test: ## Run unit tests and generate coverage
	vendor/bin/phpunit --coverage-text --coverage-clover=coverage.xml --coverage-html=./report/

watch: ## Run make build when any of the source files change
	find . -name "*.php" -not -path "./vendor/*" -o -name "*.json" -not -path "./vendor/*" | entr -c make build

build: ## Same as make lint && make test
	make lint
	make test

all: ## Same as make dependencies && make build
	make dependencies
	make build

.PHONY: help dependencies lint test watch all