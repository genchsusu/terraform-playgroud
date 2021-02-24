.PHONY: lint init

lint:
	terraform fmt -check -recursive
	which tflint &>/dev/null || curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
	tflint --module || exit 1

init:
	terraform init

install:
	terraform apply

uninstall:
	terraform destroy