NAME := lualatex

# Where to push the docker image.
REGISTRY := zidizei

# This version-strategy uses git tags to set the version string
VERSION ?= $(shell git describe --tags --always --dirty)

##
#
##

IMAGE := $(REGISTRY)/$(NAME)

default: container
container:
	@docker build -t $(IMAGE):$(VERSION) .

container-name:
	@echo "container: $(IMAGE):$(VERSION)"

push:
	@docker push $(IMAGE):$(VERSION)

version:
	@echo $(VERSION)
