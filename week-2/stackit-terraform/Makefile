# Makefile for Terraform with STACKIT authentication
SHELL := /bin/bash
# Default target
.PHONY: all
all: plan

# Helper: check Terraform installation and source auth
# Note: We use '&&' here so that if the script fails, the process stops.
define PREPARE_TF
	. ./scripts/check_terraform.sh && . ./scripts/stackit_auth_and_img_id.sh
endef

# Source the auth script, check Terraform, and run Terraform plan
.PHONY: plan
plan:
	@$(PREPARE_TF) && \
	echo "🔹 Running Terraform plan..." && \
	terraform init -input=false && \
	terraform plan

# Source the auth script, check Terraform, and run Terraform apply
.PHONY: apply
apply:
	@$(PREPARE_TF) && \
	echo "🔹 Running Terraform apply..." && \
	terraform init -input=false && \
	terraform apply -auto-approve

# Source the auth script, check Terraform, and run Terraform destroy
.PHONY: destroy
destroy:
	@$(PREPARE_TF) && \
	echo "🔹 Running Terraform destroy..." && \
	terraform destroy -auto-approve