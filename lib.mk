OPS := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CUR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

MAKEFLAGS += --no-builtin-rules --no-buildint-variables --no-print-directory

define touch
	@mkdir -p $(dir $@); touch $@
endef
