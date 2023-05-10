MYSQL ?= mysql
MYSQLDUMP ?= mysqldump

##@ MySQL
load-db: backup.sql ## Load database
	ssh $(PREPROD_USER)@$(PREPROD_IP) 'rm backup.sql'

restore-db: backup.sql ## Restore database
	cat backup.sql | $(MYSQL) $(DB_NAME)

backup.sql:
	ssh $(PREPROD_USER)@$(PREPROD_IP) '$(MYSQLDUMP) -u $(DB_USER) -p $(DB_NAME) > backup.sql'
	scp $(PREPROD_USER)@$(PREPROD_IP):backup.sql .

.PHONY: load-db restore-db
