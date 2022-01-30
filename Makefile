OPS := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: setup
setup: .task/login-github .task/auth-git
	@make -C $(OPS)/setup
	@make -C $(OPS)/services setup
	@make -C $(OPS)/monitoring setup

update:
	@git-pull
	@make setup

git-pull:
	git diff --exit-code --quiet
	git fetch origin main
	git reset --hard origin/main
	git gc --aggressive --prune=all
	du -sh .git

.task/login-github:
	@sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
	@sudo dnf install -y gh
	@gh auth login --web --scopes admin:public_key
	@mkdir -p .task; touch .task/login-github

.task/keygen:
	@mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh
	@ssh-keygen -b 4096 -t ed25519 -N '' -C 'shqld@$(shell hostname)' -f $(HOME)/.ssh/github
	@mkdir -p .task; touch .task/keygen

.task/auth-git: .task/keygen .task/login-github
	@gh api -X POST /user/keys -F title=shqld@$(shell hostname) -F key="$(file < $(HOME)/.ssh/git@github.com/id.pub)"
	@mkdir -p .task; touch .task/auth-git
