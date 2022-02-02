OPS := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CUR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

define touch
	@mkdir -p $(dir $@); touch $@
endef
