# docker pnpm

This is a docker image for [pnpm](https://pnpm.io/), which is flexible to adjust version of node and pnpm.

## Usage

To use this image, you can use it in two ways, but there will be a little different when using these two methods.

### 1. Directly use

```sh
docker run --rm -it -v $(pwd):/app moontai0724/pnpm:latest pnpm install
```

#### Specify the pnpm version

This image contains a [entrypoint script](https://docs.docker.com/engine/reference/builder/#entrypoint), which could run script when the image startup, that will re-download pnpm when startup.

So you may specify the PNPM_VERSION environment variable to download a specific version of pnpm.

```sh
docker run --rm -it -v $(pwd):/app -e PNPM_VERSION=7.33.6 moontai0724/pnpm:latest pnpm -v
```

#### Skip the re-installation of pnpm

If you do not want to re-download pnpm when startup, you can specify the SKIP_PRE_INSTALL environment variable to disable the entrypoint script.

```sh
docker run --rm -it -v $(pwd):/app -e SKIP_PRE_INSTALL=1 moontai0724/pnpm:latest pnpm -v
```

### 2. Use as a base image

```dockerfile
FROM moontai0724/pnpm

# your code
```

#### Update the pnpm to the latest version or a specific version

Please note that the entrypoint script will not be executed when using this method, so you will use the pnpm version that is pre-installed in the image. If you want to use a newer version of pnpm, please run the install script.

```dockerfile
FROM moontai0724/pnpm

RUN sh /run/install_pnpm.sh

# your code
```

If you want to install a specific version of pnpm, you can set the PNPM_VERSION environment variable.

```dockerfile
FROM moontai0724/pnpm

ENV PNPM_VERSION=7.33.6

RUN sh /run/install_pnpm.sh

# your code
```
