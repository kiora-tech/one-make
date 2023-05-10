PHP ?= php

##@ Symfony
install_symfony: vendor ## install symfony
	${PHP} bin/console doctrine:database:create --if-not-exists
	@if ls migrations/*.php 1> /dev/null 2>&1; then ${PHP} bin/console doctrine:migrations:migrate --no-interaction; fi
	@if ls src/DataFixtures/*.php 1> /dev/null 2>&1; then ${PHP} bin/console doctrine:fixtures:load --no-interaction; fi

reset-db:
	$(PHP) bin/console doctrine:database:drop --force
	$(PHP) bin/console doctrine:database:create

load-external-db: reset-db backup.sql restore-db ## Load database from external server

vendor: composer.lock
	${PHP} composer install

composer.lock:
	${PHP} composer update

.PHONY: install_symfony load-external-db
