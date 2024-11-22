deploy-infra:
	cd deployment && \
	terraform init -upgrade && \
    terraform apply
