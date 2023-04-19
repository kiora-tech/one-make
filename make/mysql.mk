##@ MySQL
load-db: ## Load database
	ssh $(PREPROD_USER)@$(PREPROD_IP) 'mysqldump -u $(DB_USER) -p $(DB_NAME) > backup.sql'
	scp $(PREPROD_USER)@$(PREPROD_IP):backup.sql .
	ssh $(PREPROD_USER)@$(PREPROD_IP) 'rm backup.sql'
	