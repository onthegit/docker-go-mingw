GO_VERSION := 1.19 # or "latest" for bleeding-edge Go version
GO_BUILD_FLAGS := -ldflags '-w -s'
GOCACHE ?= $(shell go env GOCACHE)
GOPATH ?= $(shell go env GOPATH)

.PHONY: build
build:
	@echo ":: Building $(shell basename $(PWD)) in MinGW container..."
	docker run --rm -it \
		-u "$${UID}:$${GID}" \
		-e GOCACHE=/go/.cache \
		-v "$(GOCACHE)":/go/.cache \
		-v "$(GOPATH)/src":/go/src \
		-v "$(GOPATH)/pkg":/go/pkg \
		-v "$(PWD)":/go/work \
		-e GOARCH=amd64 \
		-w /go/work \
		docker-go-mingw:$(GO_VERSION) \
		/bin/sh -c "go build $(GO_BUILD_FLAGS) ."

# .PHONY: build-i386
# build-i386:
# 	@echo ":: Building $(shell basename $(PWD)) in MinGW container..."
# 	docker run --rm -it \
# 		-u "$${UID}:$${GID}" \
# 		-e GOCACHE=/go/.cache \
# 		-e GOARCH=386 \
# 		-v "$(GOCACHE)":/go/.cache \
# 		-v "$(GOPATH)/src":/go/src \
# 		-v "$(GOPATH)/pkg":/go/pkg \
# 		-v "$(PWD)":/go/work \
# 		-w /go/work \
# 		x1unix/go-mingw:$(GO_VERSION) \
# 		/bin/sh -c 'go build $(GO_BUILD_FLAGS) -o sqlite-app-i386.exe .'
