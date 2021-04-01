AWS_ACCESS_KEY_ID		="anaccesskey"
AWS_SECRET_ACCESS_KEY	="asecretkey"

TERRAFORM_IMAGE			= "hashicorp/terraform"
TERRAFORM_VERSION		= "0.13.6"

DOCKER_OPTIONS			= -v ${PWD}:/workspace \
							-w /workspace \
							-it \
							-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"" \
							-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}""

init:
	docker run $(DOCKER_OPTIONS) $(TERRAFORM_IMAGE):$(TERRAFORM_VERSION) init --upgrade=true

plan:
	docker run ${DOCKER_OPTIONS} $(TERRAFORM_IMAGE):$(TERRAFORM_VERSION) plan

apply:
	docker run ${DOCKER_OPTIONS} $(TERRAFORM_IMAGE):$(TERRAFORM_VERSION) apply

destroy:
	docker run ${DOCKER_OPTIONS} $(TERRAFORM_IMAGE):$(TERRAFORM_VERSION) destroy --force

output: 
	docker run ${DOCKER_OPTIONS} $(TERRAFORM_IMAGE):$(TERRAFORM_VERSION) output
