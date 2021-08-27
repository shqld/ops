.PHONY: setup
setup:
	make -C /ops/setup

.PHONY: update
update:
	rm -rf /ops
	git clone https://github.com/shqld/ops /ops
