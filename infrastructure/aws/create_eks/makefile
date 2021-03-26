
install:
	@cd eks && \
	terraform init && \
	terraform apply

uninstall:
	@terraform plan -destroy && \
	terraform destroy --force

token:
	kubectl apply -f bin/create_admin_token.yaml --kubeconfig ./eks/output/*.yaml