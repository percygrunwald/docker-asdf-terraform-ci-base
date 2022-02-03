# docker-asdf-terraform-ci-base

A minimal base image for use in Terraform/Terragrunt/Terratest CI pipelines using [asdf](http://asdf-vm.com/). The following items **can be installed** (all dependencies are met, but they are not installed, so you can control the versions):

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

Images are tagged with the following tags:

- `git-$COMMIT_HASH` - the commit hash of the commit that built the image
- `YYYY-MM-DD-HHMMSS` - the date and time of the build

### In CI/CD pipelines

We suggest using this image as the base for Terraform/Terragrunt/Terratest pipelines, with steps similar to below:

- Use this image as a base
- Attempt to restore `~/.asdf` from cache
- Install [asdf](http://asdf-vm.com/) and add to the `$PATH`
- Install all tools in the `.tool-versions` file
- Install any addition dependencies with `pip` and `golang install`
- Formatting/linting/security checks with `pre-commit`
- CI/CD tasks with `terragrunt`, `terraform` and/or `terratest`
- Cache the `~/.asdf` directory based on the hash of the `.tool-versions` file(s)
- Cache the  `~/.cache/pre-commit` directory based on the hash of the `.pre-commit-config.yaml` file

## CI/CD for this repo

The images are built and pushed by Github actions. All the code is in the `.github` directory.

When do I want to build and upload an image:

- When a new ubuntu image was released
  - Scheduled
  - Script with args
    - Update Dockerfile
    - Build
    - Test
    - Commit - need to set the name and email
    - Tag
    - Docker push
  - Github actions
    - Git push
    - Release
- Manually creating a release
  - workflow dispatch
  - Script with args
    - Build
    - Test
    - Tag
    - Docker push
  - Github actions
    - Git push
    - Release
- Every push
  - push
  - Script with args
    - Build
    - Test
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
