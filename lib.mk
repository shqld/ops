OPS := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CUR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
NULL := /dev/null

MAKEFLAGS += --no-builtin-rules --no-buildint-variables --no-print-directory

define touch
	@mkdir -p $(@D); touch $(@)
endef

.DEFAULT_GOAL := help

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		$(foreach val, $(MAKEFILE_LIST), | sed 's|$(val):||') \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

force:;
