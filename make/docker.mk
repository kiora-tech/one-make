DOCKER_CMD = DOCKER_BUILDKIT=0 docker
PHP = docker compose exec -it php
JS_DEP = docker compose run --rm node yarn

##@ Docker
init: ## init docker
	${DOCKER_CMD} compose build
	${DOCKER_CMD} compose up -d

up: ## run docker
	${DOCKER_CMD} compose up -d

php: up ## run php container
	${DOCKER_CMD} compose exec php bash

.PHONY: init up php
