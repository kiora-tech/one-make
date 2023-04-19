##@ PGSQL
load-db: ## Load database
	ssh $(PREPROD_USER)@$(PREPROD_IP) 'pg_dump -h 127.0.0.1 -p 5432 -U $(DB_USER) -W $(DB_NAME) -Fp > backup.sql'
	scp $(PREPROD_USER)@$(PREPROD_IP):backup.sql .
	ssh $(PREPROD_USER)@$(PREPROD_IP) 'rm backup.sql'
