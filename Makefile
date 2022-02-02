include lib.mk

setup: force .task/login-github .task/auth-git
	@$(MAKE) -C $(OPS)/setup setup

update:
	@git diff --exit-code --quiet
	@git fetch origin main
	@git reset --hard origin/main
	@$(MAKE) setup
	@-docker system prune -f
	@-git gc --aggressive --prune=all
