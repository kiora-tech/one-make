PSQL ?= psql
PGDUMP ?= mysqldump

##@ MySQL
load-db: backup.sql ## Load database
	ssh $(PREPROD_USER)@$(PREPROD_IP) 'rm backup.sql'

restore-db: backup.sql ## Restore database
	cat backup.sql | $(PSQL) -d $(DB_NAME)

backup.sql:
	ssh $(PREPROD_USER)@$(PREPROD_IP) '$(PGDUMP) -h 127.0.0.1 -p 5432 -U $(DB_USER) -W $(DB_NAME) -Fp > backup.sql'
	scp $(PREPROD_USER)@$(PREPROD_IP):backup.sql .

.PHONY: load-db restore-db
