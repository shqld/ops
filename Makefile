.PHONY: restart-nginx
restart-nginx:
	nginx -t
	systemctl restart nginx
