# Terraform Tools

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
![Publish Docker image](https://github.com/bcochofel/terraform-tools/workflows/Publish%20Docker%20image/badge.svg)
[![Docker](https://img.shields.io/badge/Docker%20Hub-bcochofel%2Fterraform--tools-blue)](https://hub.docker.com/r/bcochofel/terraform-tools)

[![GitHub license](https://img.shields.io/github/license/bcochofel/terraform-tools.svg)](https://github.com/bcochofel/terraform-tools/blob/master/LICENSE)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/bcochofel/terraform-tools)](https://github.com/bcochofel/terraform-tools/tags)
[![GitHub issues](https://img.shields.io/github/issues/bcochofel/terraform-tools.svg)](https://github.com/bcochofel/terraform-tools/issues/)
[![GitHub forks](https://img.shields.io/github/forks/bcochofel/terraform-tools.svg?style=social&label=Fork&maxAge=2592000)](https://github.com/bcochofel/terraform-tools/network/)
[![GitHub stars](https://img.shields.io/github/stars/bcochofel/terraform-tools.svg?style=social&label=Star&maxAge=2592000)](https://github.com/bcochofel/terraform-tools/stargazers/)
<!---
[![Docker Automated build](https://img.shields.io/docker/automated/linuxcontainers/alpine.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/linuxcontainers/alpine/)
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxcontainers/alpine.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/linuxcontainers/alpine/)
![Github Pulls](https://img.shields.io/github/issues-pr/linuxcontainers/alpine?style=for-the-badge&logo=github)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/linuxcontainers/alpine?logo=docker&style=for-the-badge)](https://hub.docker.com/r/linuxcontainers/alpine)
-->

Container image with Terraform tools for static code analysis.

## List of tools

The container supports the following tools:

- [arkade](https://github.com/alexellis/arkade)
- [tfenv](https://github.com/tfutils/tfenv)
- [terraform](https://developer.hashicorp.com/terraform/install)

## Build Container

To build the container run:

```bash
docker build . -t terraform-tools:latest
```

The Dockerfile uses build args, so if you want to build the image with specific version of terraform, for instance, you can run

```bash
docker build . --build-arg TERRAFORM_VERSION=1.9.0 -t terraform-tools:latest
```

## Test Container

You can test the container by running

```bash
docker run -it terraform-tools:latest terraform version
```
