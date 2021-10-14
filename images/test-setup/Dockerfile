FROM centos:8-stream

RUN yum install -y git make && \
    curl --location https://taskfile.dev/install.sh -o $(TEMP_DIR)/install-taskfile.sh && \
	sh $(TEMP_DIR)/install-taskfile.sh -d -b /usr/bin && \
	rm $(TEMP_DIR)/install-taskfile.sh

CMD ["make", "-C", "/ops", "setup"]
# CMD ["ps", "aux"]
