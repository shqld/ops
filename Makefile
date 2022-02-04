include lib.mk

setup: force
	@$(MAKE) -C $(OPS)/setup setup

update:
	@git diff --exit-code --quiet
	@git fetch origin main
	@git reset --hard origin/main
	@$(MAKE) setup
	@-docker system prune -f
	@-git gc --aggressive --prune=all
