# docker-asdf-terraform-ci-base

![build_and_test](https://github.com/percygrunwald/docker-asdf-terraform-ci-base/actions/workflows/build_and_test.yml/badge.svg)

A minimal Docker image based on [Ubuntu 20.04](https://hub.docker.com/_/ubuntu?tab=tags&page=1&name=20.04) for use in Terraform/Terragrunt/Terratest CI pipelines. The image contains alls dependencies for installing Terraform and related tools using [asdf](http://asdf-vm.com/). The following items *can* be installed (all dependencies are met, but they are not installed, so you can control the versions):

- [asdf](http://asdf-vm.com/)
- [checkov](https://github.com/bridgecrewio/checkov) (via `pip`, for use with `pre-commit`)
- [golang](https://go.dev/) (via `asdf`, for running Terratest)
- [golint](https://github.com/golang/lint) (via `go install`, for use with `pre-commit`)
- [pre-commit](https://pre-commit.com/) (via `pip`)
- [terraform](https://www.terraform.io/) (via `asdf`)
- [terragrunt](https://terragrunt.gruntwork.io/) (via `asdf`)
- [tflint](https://github.com/terraform-linters/tflint) (via `asdf`)

Python3 is installed at the system level since we assume that the version of Python is irrelevant, as long as it's installed.

## Use

Images are built in Github Actions and hosted at [hub.docker.com/r/percygrunwald/docker-asdf-terraform-ci-base](https://hub.docker.com/r/percygrunwald/docker-asdf-terraform-ci-base).

```
docker pull percygrunwald/docker-asdf-terraform-ci-base
```

### Docker tags

Each image has the following tags, which allow you to specify a specific release:

- `vYYYY-MM-DD-HHMMSS` - the main release tag, composed of the date/time of the build
- `git-$COMMIT_HASH` - the commit hash of the commit in this repository from which the image was built
- `ubuntu-$DOCKER_DIGEST` - the short digest of the underlying [Ubuntu docker image](https://hub.docker.com/_/ubuntu?tab=tags&page=1)

### In CI/CD pipelines

A suggested workflow

- Use `percygrunwald/docker-asdf-terraform-ci-base` as the base image for the CI pipeline
- Install `asdf` with `git clone` and run `asdf` install to install all tools (`terraform`, `terragrunt`, `golang`, etc.)
- Run CI tasks (lint, test, `terraform plan`, etc.)
- Cache `~/.asdf` directory for future runs (hash based on `.tool-versions` file)

## CI/CD for this repo

This repo is a "live" repo. It "follows" the [`ubuntu` repo on Docker Hub](https://hub.docker.com/_/ubuntu) and when a new version of the `20.04` (Focal) base image is released, Github Actions will update the `Dockerfile`, build and test the resulting image, commit the changes, push the new image [to Docker Hub](https://hub.docker.com/r/percygrunwald/docker-asdf-terraform-ci-base) and create a Github release. Please see the `.github` for full details.

### Testing the CI/CD pipeline locally

You can test the CI/CD pipeline ([Github Actions](https://docs.github.com/en/actions)) locally using [nektos/act](https://github.com/nektos/act). Requires docker.

`--reuse` reuses the containers for each workflow job, keeping all installed tools/dependencies. This is recommended for frequent runs since `act` [cannot make use of actions caching](https://github.com/nektos/act/issues/285#issuecomment-987550101), which means all tools/dependencies must be downloaded each time. If you ever want to start again from scratch (empty container), just run without `--reuse`.

```
# Install act with go (see act docs for other installation options)
go install github.com/nektos/act@latest
```

Run the push workflow, `DOCKER_PASSWORD` should be set to an access token and passed as a secret:

```
export DOCKER_PASSWORD=...
act push --reuse -s DOCKER_PASSWORD
act workflow_dispatch --reuse -s DOCKER_PASSWORD
act schedule --reuse -s DOCKER_PASSWORD
```
