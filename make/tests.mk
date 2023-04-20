##@ Testing

PHPUNIT = vendor/bin/phpunit

# Run tests without code coverage
test: ## Run PHPUnit tests
	$(PHP) $(PHPUNIT)

# Run a specific testsuite
test-%: ## Run a specific PHPUnit testsuite (e.g., make test-<suite_name>)
	$(if $(filter before-test-$*,$(MAKECMDGOALS)),,make before-test-$* || true)
	$(PHP) $(PHPUNIT) --testsuite $*

# Add this line to your Makefile to define a before-test-<suite_name> target
# before-test-<suite_name>:

.PHONY: test test-coverage test-%