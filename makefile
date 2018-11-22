# Makefile for shipping and testing the container image.

MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := build
.PHONY: *

## We get these from CI environment if available, otherwise from git
GIT_COMMIT ?= $(shell git rev-parse --short HEAD)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

# Other variables
namespace ?= ""
tag := $(shell basename $(GIT_BRANCH) | tr A-Z a-z)
imageName := img-consul-${tag}
imageVersion := $(shell /bin/date "+%s")
baseTemplate := img-common-app-master-1532781830

# Terraform variables
tfVars:= -var "image_name=${imageName}" -var "image_version=${imageVersion}"

# Packer variables
ifdef target
packerVars = -only=${target}
endif
ifdef folder
packerVars += -var 'folder_name=${folder}'
endif
packerVars += -var 'vsphere_cluster=${vsphere_cluster}' -var 'vsphere_resource_pool=${vsphere_resource_pool}' -var 'vsphere_datastore=${vsphere_datastore}'

## Display this help message
help:
	$(info Available targets)
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                    \
	  nb = sub( /^## /, "", helpMsg );              \
	  if(nb == 0) {                                 \
	    helpMsg = $$0;                              \
	    nb = sub( /^[^:]*:.* ## /, "", helpMsg );   \
	  }                                             \
	  if (nb)                                       \
	    print  $$1 "\t" helpMsg;                    \
	}                                               \
	{ helpMsg = $$0 }'                              \
	$(MAKEFILE_LIST) | column -ts $$'\t' |          \
	grep --color '^[^ ]*'

## Test current environment
testenv:
	@which packer > /dev/null 2>&1 && printf "\e[32;1mpacker binary found\e[0m \n" || printf "\e[31;1mpacker binary not found\e[0m \n"
	@which cfgt > /dev/null 2>&1 && printf "\e[32;1mcfgt binary found\e[0m \n" || printf "\e[31;1mcfgt binary not found\e[0m \n"
	@which terraform > /dev/null 2>&1 && printf "\e[32;1mterraform binary found\e[0m \n" || printf "\e[31;1mterraform binary not found\e[0m \n"
	@[[ ! -z "${TF_VAR_vsphere_server}" ]] && printf "\e[32;1mvariable TF_VAR_vsphere_server defined\e[0m \n" || printf "\e[31;1mvariable TF_VAR_vsphere_server not defined\e[0m \n"
	@[[ ! -z "${TF_VAR_vsphere_user}" ]] && printf "\e[32;1mvariable TF_VAR_vsphere_user defined\e[0m \n" || printf "\e[31;1mvariable TF_VAR_vsphere_user not defined\e[0m \n"
	@[[ ! -z "${TF_VAR_vsphere_password}" ]] && printf "\e[32;1mvariable TF_VAR_vsphere_password defined\e[0m \n" || printf "\e[31;1mvariable TF_VAR_vsphere_password not defined\e[0m \n"

build:
	@cd image ; cfgt -i ./packer.json5 | packer build ${packerVars} -var 'image_name=${imageName}' -var 'image_version=${imageVersion}' -var 'template_name=${baseTemplate}' -

apply-vsphere:
	@cd vsphere ; terraform init ; terraform apply ${tfVars} -auto-approve .

destroy-vsphere:
	@cd vsphere ; terraform destroy ${tfVars} -force .

apply-aws:
	@cd aws ; terraform init ; terraform apply ${tfVars} -auto-approve .

destroy-aws:
	@cd aws ; terraform destroy ${tfVars} -force .

clean: destroy-vsphere destroy-aws

## Print environment for build debugging
debug:
	@echo GIT_COMMIT=$(GIT_COMMIT)
	@echo GIT_BRANCH=$(GIT_BRANCH)
	@echo namespace=$(namespace)
	@echo tag=$(tag)
	@echo image_name=$(imageName)
	@echo image_version=$(imageVersion)

check_var = $(foreach 1,$1,$(__check_var))
__check_var = $(if $(value $1),,\
	$(error Missing $1 $(if $(value 2),$(strip $2))))
