setup: init-bee setup_sshd setup_user install_packages setup_docker setup_ipv6
	@touch $(BEE)/$(@)

.PHONY: setup_user
setup_user: setup_user_sho setup_user_robot setup_user_daemon setup_user_app

.PHONY: setup_user_sho
setup_user_sho: setup_sshd
	/ops/users/sho/setup

.PHONY: setup_user_robot
setup_user_robot: setup_sshd
	/ops/users/robot/setup

.PHONY: setup_user_daemon
setup_user_daemon: setup_sshd
	/ops/users/daemon/setup

.PHONY: setup_user_app
setup_user_app: setup_sshd
	/ops/users/app/setup
