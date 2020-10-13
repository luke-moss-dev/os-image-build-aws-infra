all: centos7 rhel7 suse

centos7:
	@cd ${PWD}/packer/packer-centos-7-os-image && \
	AWS_REGION=us-east-2 packer build --var-file=../packer-global-variables.json packer.json
	
rhel7:
	@cd ${PWD}/packer/packer-rhel-7-os-image && \
	AWS_REGION=us-east-2 packer build --var-file=../packer-global-variables.json packer.json
	
suse:
	@cd ${PWD}/packer/packer-opensuse-leap-os-image && \
	AWS_REGION=us-east-2 packer build --var-file=../packer-global-variables.json packer.json

	
.PHONY: centos7 rhel7 suse