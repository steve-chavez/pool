PROJECT_NAME            := resource-pool-fork-avanov

# https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
# https://ftp.gnu.org/old-gnu/Manuals/make-3.80/html_node/make_17.html
PROJECT_MKFILE_PATH     := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
PROJECT_MKFILE_DIR      := $(shell cd $(shell dirname $(PROJECT_MKFILE_PATH)); pwd)

PROJECT_ROOT            := $(PROJECT_MKFILE_DIR)
LOCAL_UNTRACK_DIR       := $(PROJECT_MKFILE_DIR)/.local
DISTRIBUTIONS           := $(PROJECT_MKFILE_DIR)/dist-newstyle/sdist

update:
	cabal v2-update
	cabal v2-configure

build:	$(PROJECT_ROOT)/Data \
		$(PROJECT_ROOT)/$(PROJECT_NAME).cabal
	cabal v2-build

.PHONY: distribute
distribute:
	cabal v2-sdist

.PHONY: publish
publish: | cleanall distribute
	cabal upload $(DISTRIBUTIONS)/$(PROJECT_NAME)-*.tar.gz

.PHONY: release
release:
	cabal upload $(DISTRIBUTIONS)/$(PROJECT_NAME)-*.tar.gz --publish

.PHONY: cleanall
cleanall:
	rm -r $(DISTRIBUTIONS)
