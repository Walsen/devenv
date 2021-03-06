########################################
# Install clean OS Dependencies
########################################

# all: dependencies

TOPDIR=$(shell pwd)

.PHONY: checkplatform system wm sddm iac sdkman

checkplatform:
	@echo "Checking if the platform is compatible."
ifneq ($(shell uname),Linux)
	@echo 'Platform unsupported, only available for RPM base linux' && exit 1
endif
ifeq ($(strip $(shell which dnf)),)
	@echo 'dnf not found, platform not supported' && exit 1
endif

system:
	sudo dnf -y update
	sudo dnf -y group install "Development Tools"
	sudo systemctl enable sshd
	sudo systemctl start sshd

wm:
	sudo dnf -y group install "KDE Plasma Workspaces"
	sudo systemctl disable gdm
	sudo systemctl enable sddm

sdkman:
	curl -s "https://get.sdkman.io" | bash
	source "$(HOME)/.sdkman/bin/sdkman-init.sh"
	sh $(PWD)/scripts/installGradle.sh

iac:
	sudo dnf -y install ansible
	ansible-galaxy collection install community.general
