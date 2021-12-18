# go-mingw

Docker image for building Go binaries for **Windows** with MinGW-w64 toolchain based on official Go Docker image.

The repository provides simple cross-compilation environment for windows 32 and 64bit builds.

## Usage

You can pull Docker image with desired Go version from Docker Hub:

```bash
docker pull x1unix/go-mingw:latest # or "1.17" for specific Go version
```

**Recommended:** Please take a look at [full project build example](example/sqlite-app) before starting to work.

### Building Go applications inside container

Mount directory with app source and build it:

```bash
docker run --rm -it -v /YourPackageSrc:/go/work \
    -w /go/work \
    x1unix/go-mingw go build .
```

You will get compiled Windows binary.

**For 32-bit toolchain**

To build a 32-bit executable, set `GOARCH=386` variable:

```bash
docker run --rm -it -e GOARCH=386 -v /YourPackageSrc:/go/work \
    -w /go/work \
    x1unix/go-mingw go build .
```

**Recommended:** See full project build example [here](example/sqlite-app).

### Go linker flags override

You can override Go linker flags and other flags by specifying environment variable for a container using `-e` option.

**Example:**

```bash
docker exec -it
    -e LDFLAGS="-linkmode external -extldflags '-static -s -w'"
    ...
```

### Produced files ownership

By default, the container starts as *root* user. It means, that all produced files
will be owned by `root:root` user.

To set files to be owned by your current user by default, you need to start
the container with your current **uid/gid**.

Use `-u` flag to start container with different user/group id.

```bash
# Start container as other uid/gid
docker exec --rm -it -u "$UID:$GID" ...
```

**Attention:** we recommend to mount your host GOPATH and GOCACHE instead of
separated volumes approach when using UID/GID other than root.

### Go Build Cache

In order to speed up build times and keep Go build cache, you can mount your Go build cache directory or create a separate Docker volume for it.

**Local GOPATH**

```bash
docker run --rm -it \
    -u $UID \
    -v /YourPackageSrc:/go/work \
    -v $(go env GOCACHE):/go/cache \
    -e GOCACHE=/go/cache \
    -w /go/work \
    x1unix/go-mingw go build .
```

**Volume:**

```bash
# Create Docker volume
docker volume create go-cache

# Run container with attached volume
docker run --rm -it \
    -v /YourPackageSrc:/go/work \
    -v go-cache:/go/cache \
    -e GOCACHE=/go/cache \
    -w /go/work \
    x1unix/go-mingw go build .
```

See [Docker volumes docs](https://docs.docker.com/storage/volumes/) for more info.

### Go modules cache

In addition to Go build cache, you may also want to mount Go modules cache 
to avoid modules re-download on each build.

To do this, mount your GOPATH or Go modules directory (`$GOPATH/pkg`).

### Building custom Docker image

You can build image locally with specified Go version:

```bash
make image GO_VERSION=1.17
```

Replace `1.17` with desired Go version.
