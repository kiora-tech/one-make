JS_DEP ?= yarn

##@ Node
.PHONY: install
install_node: node_modules ## Install dependencies

.PHONY: watch_assets
watch_assets: ## Watch assets
	$(JS_DEP) watch

node_modules: yarn.lock
	$(JS_DEP) install

yarn.lock: package.json
	$(JS_DEP) install

build: public/build ## Build assets

public/build: assets/* assets/*/*
	$(JS_DEP) build