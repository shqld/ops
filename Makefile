include lib.mk

setup: force .task/login-github .task/auth-git
	@$(MAKE) -C $(OPS)/setup setup

update:
	@git-pull
	@$(MAKE) setup

git-pull:
	git diff --exit-code --quiet
	git fetch origin main
	git reset --hard origin/main
	git gc --aggressive --prune=all
	du -sh .git
