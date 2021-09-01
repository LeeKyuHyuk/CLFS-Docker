include settings.mk

.PHONY: all toolchain system image clean

all:
	@make clean toolchain system image

toolchain:
	@$(SCRIPTS_DIR)/toolchain.sh

system:
	@$(SCRIPTS_DIR)/system.sh

image:
	@$(SCRIPTS_DIR)/image.sh

clean:
	@rm -rf out

download:
	@wget -c -i wget-list -P $(SOURCES_DIR)
