DOCKER_CMD = DOCKER_BUILDKIT=0 docker
PHP = docker compose exec -it php
JS_DEP = docker compose run --rm node yarn

DOCKERFILES_FOLDER ?= .docker
DOCKERFILES ?= $(wildcard $(DOCKERFILES_FOLDER)/Dockerfile.*)
DOCKER_SENTINELS=$(addprefix make/, $(addsuffix .sentinel, $(subst Dockerfile.,.,$(notdir $(DOCKERFILES)))))

##@ Docker
init: ${DOCKER_SENTINELS} ## init docker
	${DOCKER_CMD} compose up -d

$(DOCKER_SENTINELS): make/.%.sentinel : $(DOCKERFILES_FOLDER)/Dockerfile.%
	${DOCKER_CMD} compose build
	touch $@

up: init ## run docker

php: up ## run php container
	${DOCKER_CMD} compose exec php bash

.PHONY: init up php