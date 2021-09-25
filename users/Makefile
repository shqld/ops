user: user/sho user/robot user/daemon user/app
	@touch $(BEE)/$(@)

user/sho: user/sho/add_user user/sho/add_group user/sho/add_owner user/sho/setup_ssh user/sho/setup_sudoers ## Add user user_sho
	@touch $(BEE)/$(@)

.PHONY: user/sho/add_user
user/sho/add_user: ## Add user(sho)
	getent passwd sho && $(make) __user/sho/add_user

__user/sho/add_user:
	echo "Adding user(sho) ..."
	useradd sho

.PHONY: user/sho/add_group
user/sho/add_group: ## Add user(sho) to group(docker)
	getent group docker && $(make) __user/sho/add_group

__user/sho/add_group:
	echo "Adding user(sho) to group(docker) ..."
	usermod -a -G docker sho

user/sho/add_owner: ## Set /ops owner to user&group(sho)
	echo "Setting /ops owner to user&group(sho) ..."
	chown sho -R /ops
	chmod u+rwx -R /ops

user/sho/setup_ssh: ## Set up ssh authorization for user(sho)
	echo "Setting up ssh authorization for user(sho) ..."
	mkdir -p /home/sho/.ssh
	curl https://github.com/shqld.keys > /home/sho/.ssh/authorized_keys
	chmod 600 /home/sho/.ssh/authorized_keys
	chmod 700 /home/sho/.ssh
	chown sho -R /home/sho/.ssh

user/sho/setup_sudoers: ## Set up sudoers for user(sho)
	echo "
		sho ALL=(root) $(which yum)
		sho ALL=(root) $(which git)
		sho ALL=(root) $(which systemctl)
	" > /etc/sudoers.d/sho

user/robot: user/robot/add_user user/robot/add_group user/robot/setup_ssh user/robot/setup_sudoers
	@touch $(BEE)/$(@)

.PHONY: user/robot/add_user
user/robot/add_user: ## Add user(robot)
	getent passwd robot && $(make) __user/robot/add_user

__user/robot/add_user:
	echo "Adding user(robot) ..."
	useradd robot

user/robot/add_group: ## Add user(robot) to group(sho)
	echo "Adding user(robot) to group(sho) ..."
	usermod -a -G sho robot

user/robot/setup_ssh: ## Set up ssh authorization for user(robot)
	echo "Setting up ssh authorization for user(robot) ..."
	mkdir -p /home/robot/.ssh
	echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH/YgNZJbJbyKwUG7k3i7PfdJ59CyDpSTArn/rJ/4J5I robot@shqld.dev" > /home/robot/.ssh/authorized_keys
	chmod 600 /home/robot/.ssh/authorized_keys
	chmod 700 /home/robot/.ssh
	chown robot -R /home/robot/.ssh

user/robot/setup_sudoers: ## Set up sudoers for user(robot)
	echo "Setting up sudoers for user(robot) ..."
	echo "
	# For replacing /ops
	robot ALL=(root) NOPASSWD: $(which rm) -rf /ops
	robot ALL=(root) NOPASSWD: $(which git) clone *

	robot ALL=(root) NOPASSWD: $(which make) -C /ops setup
	robot ALL=(root) NOPASSWD: $(which make) -C /ops app-update-www
	" > /etc/sudoers.d/robot

.PHONY: user/daemon
user/daemon: ## Set user(daemon)
	getent passwd daemon && $(make) __user/daemon

__user/daemon:
	echo "Adding user(daemon) ..."
	useradd daemon

.PHONY: user/app
user/app: ## Set user(app)
	getent passwd app && $(make) __user/app

__user/app:
	echo "Adding user(app) ..."
	useradd app
