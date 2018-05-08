SHELL = /bin/sh

# version 0.0.1
# Copyright (c) 2015 Yieldbot

.PHONY: all build clean pre-build version

version_file = "VERSION"
version := $(shell cat $(version_file))

#EXTLDFLAGS=-linkmode external -X main.version $(version)
#	will set the variable 'version' in the 'main' package to the value in version
EXTLDFLAGS=
SEDSUFFIX=
ifeq ($(OS),Windows_NT)
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
	endif
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		EXTLDFLAGS += -extldflags '-static'
		SEDSUFFIX="bak"
	endif
	ifeq ($(UNAME_S),Darwin)
		SEDSUFFIX=".bak"
	endif
	UNAME_P := $(shell uname -p)
	ifeq ($(UNAME_P),x86_64)
	endif
	ifneq ($(filter %86,$(UNAME_P)),)
	endif
	ifneq ($(filter arm%,$(UNAME_P)),)
	endif
endif

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

# Set the package to build.
ifndef pkg
	pkg := $(shell pwd | awk -F/ '{print $$NF}')
endif

ifndef build_image
	build_image = docker.yb0t.cc/build-go-child:0.0.4
endif

ifndef publish_image
	publish_image = docker.yb0t.cc/build-uploader:0.0.1
endif

# Set the path that the tarball will be dropped into.
ifndef targetdir
	targetdir = pkg
endif

ifndef repo
	repo = yieldbot-golang
endif

ifndef target_arch
	target_arch = amd64
endif

ifndef target_os
	target_os = darwin
endif

ifndef pkg_override
	pkg_override = $(pkg)
endif

ifndef git_branch
	git_branch = master
endif

all: clean pre-build build-all

clean:
	@rm -rf bin pkg

pre-build: clean
	@mkdir bin pkg
	docker pull $(build_image)
	docker pull $(publish_image)

build: pre-build build-linux build-darwin

build-actual:
	@if [ "$(target_os)" == "linux" ]; then \
		GOOS=$(target_os) GOARCH=$(target_arch) go build --ldflags "$(EXTLDFLAGS)" ./...; \
	else \
		GOOS=$(target_os) GOARCH=$(target_arch) go build ./... ; \
	fi;

build-darwin:
	@if [ -z "$(workspace)" ]; then \
		docker run --rm \
		-v $(current_dir):/go/src/github.com/yieldbot/$(pkg) \
		$(build_image) \
		$(pkg) build-actual darwin; \
	else \
		docker run --rm \
		--volumes-from $(MESOS_CONTAINER_NAME) \
		$(build_image) \
		$(pkg) build-actual darwin amd64 $(current_dir); \
	fi;

build-linux:
	@if [ -z "$(workspace)" ]; then \
		docker run --rm \
		-v $(current_dir):/go/src/github.com/yieldbot/$(pkg) \
		$(build_image) \
		$(pkg) build-actual linux; \
	else \
		docker run --rm \
		--volumes-from $(MESOS_CONTAINER_NAME) \
		$(build_image) \
		$(pkg) build-actual linux amd64 $(current_dir); \
	fi;

# pack everything up neatly
package: build package-darwin package-linux

package-darwin:
	@if [ -e ./bin/$(pkg)-darwin ]; then \
		cd ./bin; \
		mv $(pkg)-darwin $(pkg_override); \
		tar czvf ../$(targetdir)/$(pkg_override)-$(version)-darwin.tar.gz $(pkg_override); \
		mv $(pkg_override) $(pkg)-darwin; \
	else \
		echo "No Darwin binary was found. No output package will be created"; \
	fi; \

package-linux:
	@if [ -e ./bin/$(pkg)-linux ]; then \
		cd ./bin; \
		mv $(pkg)-linux $(pkg_override); \
		tar czvf ../$(targetdir)/$(pkg_override)-$(version)-linux.tar.gz $(pkg_override); \
		mv $(pkg_override) $(pkg)-linux; \
	else \
		echo "No Linux binary was found. No output package will be created"; \
	fi; \

publish: package publish-darwin publish-linux

publish-darwin:
	@if [ -z "$(workspace)" ]; then \
		docker run --rm \
		-e DEPLOYABLE_USER=$(DEPLOYABLE_USER) \
		-e DEPLOYABLE_PASSWORD=$(DEPLOYABLE_PASSWORD) \
		-v $(current_dir):/go/src/github.com/yieldbot/$(pkg) \
		$(publish_image) \
		$(current_dir)/$(targetdir)/$(pkg_override)-$(version)-darwin.tar.gz $(repo)/$(pkg_override)/; \
	else \
		docker run --rm \
		--volumes-from $(MESOS_CONTAINER_NAME) \
		$(publish_image) \
		$(current_dir)/$(targetdir)/$(pkg_override)-$(version)-darwin.tar.gz $(repo)/$(pkg_override)/ $(VAULT_ADDR) $(VAULT_TOKEN); \
	fi;

publish-linux:
	@if [ -z "$(workspace)" ]; then \
		docker run --rm \
		-e DEPLOYABLE_USER=$(DEPLOYABLE_USER) \
		-e DEPLOYABLE_PASSWORD=$(DEPLOYABLE_PASSWORD) \
		-v $(current_dir):/go/src/github.com/yieldbot/$(pkg) \
		$(publish_image) \
		$(current_dir)/$(targetdir)/$(pkg_override)-$(version)-linux.tar.gz $(repo)/$(pkg_override)/; \
	else \
		docker run --rm \
		--volumes-from $(MESOS_CONTAINER_NAME) \
		$(publish_image) \
		$(current_dir)/$(targetdir)/$(pkg_override)-$(version)-linux.tar.gz $(repo)/$(pkg_override)/ $(VAULT_ADDR) $(VAULT_TOKEN); \
	fi;

test:
	go test -v -race $$(go list ./... | grep -v vendor/)

version:
	@if [ -e $(version_file) ]; then \
		ver=`cat $(version_file)`; \
		echo "$$ver"; \
	else \
		echo "No version file found"; \
		exit 1; \
	fi;

version-bump:
	@if [ -e $(version_file) ]; then \
		VER=`cat $(version_file)`; \
		MAJOR=`echo "$$VER" | cut -d. -f 1`; \
		MINOR=`echo "$$VER" | cut -d. -f 2`; \
		PATCH=`echo "$$VER" | cut -d. -f 3`; \
		NEW_PATCH=`echo "$$(( $$PATCH + 1 ))"`; \
		echo "$$MAJOR.$$MINOR.$$NEW_PATCH" > $(version_file); \
	else \
		echo "No version file found"; \
		exit 1; \
	fi;

version-push:
	@if [ -e $(version_file) ]; then \
		git commit -a -m "[$(pkg)]Version Bump"; \
		git pull --rebase origin $(git_branch); \
		git push origin HEAD:$(git_branch); \
	else \
		echo "No version file found"; \
		exit 1; \
	fi;
