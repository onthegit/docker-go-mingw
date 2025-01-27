# to build docker image use this makefile, then the name of the docker image can be used locally for cross-compiling go
# if an error shows regarding resolving apt domain from debian, then create /etc/docker/daemon.json with: 
# {
#   "dns": ["8.8.8.8", "8.8.4.4"]
# } 
IMG_NAME = docker-go-mingw

.PHONY: image
image:
	@if [ -z $(GO_VERSION) ]; then echo "usage: 'make image GO_VERSION=[GO VERSION NUMBER]'" && exit 1; fi; \
	echo ":: Building image..." &&\
	docker build --network host -t $(IMG_NAME):$(GO_VERSION) -f Dockerfile . --build-arg GO_VERSION=$(GO_VERSION)
