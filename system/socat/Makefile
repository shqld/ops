.PHONY: setup
setup: init start

.PHONY: init
init:
	yum install socat
	ln -sf /ops/system/socat/socat.service /etc/systemd/system/socat.service
	systemctl daemon-reload

.PHONY: start
start: init
	systemctl start socat

.PHONY: stop
stop:
	systemctl stop socat
