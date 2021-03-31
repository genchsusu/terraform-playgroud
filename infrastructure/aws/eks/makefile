AWS_ACCESS_KEY_ID="anaccesskey"
AWS_SECRET_ACCESS_KEY="asecretkey"

install:
	@cd eks && \
	terraform init && \
	terraform apply

uninstall:
	@terraform plan -destroy && \
	terraform destroy --force

token:
	kubectl apply -f create_admin_token.yaml --kubeconfig ./*.yaml