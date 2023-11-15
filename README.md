# Docker Image for PNPM

This is a docker image for [pnpm](https://pnpm.io/), which is flexible to adjust version of node and pnpm.

## Usage

To use this image, you can use it in two ways, but there will be a little different when using these two methods.

### 1. Directly use

```sh
docker run --rm -it -v $(pwd):/app moontai0724/pnpm:latest pnpm install
```

#### Update the pnpm to the latest version or a specific version

The image should contains latest pnpm version, but if you want to re-download when startup or use a specific version of pnpm, you can specify the `PNPM_VERSION` environment variable.

This image contains an [entrypoint script](https://docs.docker.com/engine/reference/builder/#entrypoint), which could run script when the image startup, that will re-download pnpm when startup.

```sh
docker run --rm -it -v $(pwd):/app -e PNPM_VERSION=7.33.6 moontai0724/pnpm:latest pnpm install
```

### 2. Use as a base image

```dockerfile
FROM moontai0724/pnpm

# your code
```

#### Update the pnpm to the latest version or a specific version

Please note that the entrypoint script will be executed after the image built, so you will use the pnpm version that is pre-installed in the image. If you want to use another version of pnpm, please manually run the installation script.

```dockerfile
FROM moontai0724/pnpm

RUN sh /run/install_pnpm.sh

# your code
```

If you want to install a specific version of pnpm, you can set the `PNPM_VERSION` environment variable.

```dockerfile
FROM moontai0724/pnpm

RUN export PNPM_VERSION=7.33.6

RUN sh /run/install_pnpm.sh

# your code
```

## Environment Variables

| Name         | Default Value | Description                                                                                                      |
| ------------ | ------------- | ---------------------------------------------------------------------------------------------------------------- |
| PNPM_VERSION | N/A           | The version of pnpm to install. Specify `latest` to download latest version of pnpm. Will skip install if empty. |
