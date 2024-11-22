deploy-infra:
	cd deployment && \
	terraform init
    terraform apply
    