include lib.mk

setup: .task/login-github .task/auth-git
	@make -C $(OPS)/setup
	@make -C $(OPS)/agent setup
	@make -C $(OPS)/monitoring setup
	@make -C $(OPS)/services setup

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
	$(touch)

.task/keygen: .ssh_config
    # Partially ported from https://github.com/shqld/dotfiles/blob/5ffe897064b81b3cfa25701fc8947a099cd1cd26/Makefile#L59-L64
	@mkdir -p $(HOME)/.ssh && chmod 700 $(HOME)/.ssh
	@cat .ssh_config > $(HOME)/.ssh/config
	@$(foreach val, $(shell grep IdentityFile .ssh_config | sed 's|IdentityFile ||g'), \
        test -f $(val) || ( \
            mkdir -p $(dir $(val)); ssh-keygen -b 4096 -t ed25519 -N '' -C 'shqld@$(shell hostname)' -f $(val) \
        ); \
    )
	$(touch)

.task/auth-git: .task/keygen .task/login-github
	@gh api -X POST /user/keys -F title=shqld@$(shell hostname) -F key="$(file < $(HOME)/.ssh/git@github.com/id.pub)"
	$(touch)
