
##@ Symfony
install_symfony: vendor ## install symfony
	${PHP} bin/console doctrine:database:create --if-not-exists
	if [ -f "src/Migrations/Version*.php" ]; then ${PHP} bin/console doctrine:migrations:diff --no-interaction; fi
	if [ -f "src/DataFixtures/AppFixtures.php" ]; then ${PHP} bin/console doctrine:fixtures:load --no-interaction; fi

load-external-db: load-db ## Load database from external server
	$(PHP) bin/console doctrine:database:drop --force
	$(PHP) bin/console doctrine:database:create
	cat backup.sql | $(PHP) bin/console doctrine:query:sql
	rm backup.sql

vendor: composer.lock
	${PHP} composer install

.PHONY: install_symfony load-external-db
