SHELL := /usr/bin/env bash -o pipefail

# This controls the location of the cache.
PROJECT := imjoshholloway/terraform-aws

# This controls the version of tools to install and use.
TERRAFORM_VERSION=0.12.24

TF_OPTS :=

### Everything below this line is meant to be static, i.e. only adjust the above variables. ###

GOOS := $(shell go env GOOS)
GOARCH := $(shell go env GOARCH)

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN := $(shell go env GOPATH)/bin
else
GOBIN := $(shell go env GOBIN)
endif

# deps will be cached to ~/.cache/<project>
CACHE_BASE := $(HOME)/.cache/$(PROJECT)
# This allows switching between i.e a Docker container and your local setup without overwriting.
CACHE := $(CACHE_BASE)/$(GOOS)/$(GOARCH)
# The location where deps will be installed.
CACHE_BIN := $(CACHE)/bin
# Marker files are put into this directory to denote the current version of binaries that are installed.
CACHE_VERSIONS := $(CACHE)/versions

# Update the $PATH so we can use deps directly
export PATH := $(abspath $(CACHE_BIN)):$(PATH)

local-env:
	@echo -e "export PATH=$(PATH)"

# TERRAFORM points to the marker file for the installed version.
#
# If TERRAFORM_VERSION is changed, the binary will be re-downloaded.
TERRAFORM := $(CACHE_VERSIONS)/terraform/$(TERRAFORM_VERSION)
$(TERRAFORM):
	@rm -f $(CACHE_BIN)/terraform
	@mkdir -p $(CACHE_BIN)
	$(eval TMP := $(shell mktemp -d))
	curl -sSL \
		"https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_$(GOOS)_$(GOARCH).zip" \
		-o "$(TMP)/terraform_${TERRAFORM_VERSION}_$(GOOS)_$(GOARCH).zip"
	unzip $(TMP)/terraform_${TERRAFORM_VERSION}_$(GOOS)_$(GOARCH).zip -d $(CACHE_BIN)
	@rm -rf $(dir $(TERRAFORM))
	@mkdir -p $(dir $(TERRAFORM))
	@touch $(TERRAFORM)

PLAN_FILE=./terraform.tfplan

.PHONY: deps
deps: $(TERRAFORM)

init:
	terraform init $(TF_OPTS)

lint:
	terraform fmt -check -diff

plan: init
	terraform plan -lock=false

apply: init
	terraform plan -out=$(PLAN_FILE)
	terraform apply -auto-approve $(PLAN_FILE)

cleanup: init
	terraform destroy -auto-approve
	rm -rf .terraform.tfstate.d/* .terraform $(WORKSPACE_FILE) $(PLAN_FILE)

output:
	terraform output -json > /tmp/terraform.json
