BEE           := .bee/files
VPATH         := $(BEE)
.DEFAULT_GOAL := help

init-bee: ## Init bee
	@mkdir -p .bee/files
	@touch $(BEE)/$(@)

.PHONY: help
help: ## Show help
	@grep -E '^([^: \s\W])+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sed -E 's/\/?Makefile//' \
		| sort \
		| awk 'BEGIN {FS = ":[^:]*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Clean bee files
	@rm -rf $(BEE)/*

# .DELETE_ON_ERROR:
