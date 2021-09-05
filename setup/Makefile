.PHONY: setup_global
setup_global: setup_sshd setup_user install_packages setup_docker setup_ipv6 setup_system_socat

.PHONY: setup_sshd
setup_sshd:
	grep -q 'Match User *' < /etc/ssh/sshd_config || \
	echo " \
		Match User *\
			PasswordAuthentication no\
			PubkeyAuthentication yes\
	" > /etc/ssh/sshd_config\
	systemctl restart sshd

.PHONY: install_packages
install_packages:
	/ops/setup/scripts/install_packages

.PHONY: setup_docker
setup_docker:
	/ops/setup/scripts/setup_docker

.PHONY: setup_ipv6
setup_ipv6:
	/ops/setup/scripts/setup_ipv6

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

.PHONY: setup_system_socat
setup_system_socat:
	make -C /ops/system/socat setup
