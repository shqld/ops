system-update-nginx:
	if ! which nginx; then
		# https://copr.fedorainfracloud.org/coprs/ryoh/nginx-quic/
		dnf install -y epel-release
		dnf copr enable -y ryoh/nginx-quic
		dnf install -y nginx-quic

		systemctl enable nginx
	fi
	if ! systemctl | grep nginx -q; then
		nginx -t
		ln -sfnv /ops/system/nginx/nginx.conf /etc/nginx/nginx.conf
		systemctl start nginx
	fi
	@touch $(BEE)/$(@)
