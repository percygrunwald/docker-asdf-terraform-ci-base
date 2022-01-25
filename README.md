# docker-asdf-terraform-ci-base

A minimal base image for use in Terraform/Terragrunt/Terratest CI pipelines where most tools are installed with [asdf](http://asdf-vm.com/) and cached between runs. The image contains all the system level dependencies to install the following with `asdf`:

- golang (for running Terratest)
- terraform
- terragrunt
- tflint

Python3 is installed at the system level since we assume that the version of Python is irrelevant, as long as it's installed (dependency for `pre-commit`).

## Todo

- [ ] Build and upload container to docker hub

## Continuous Integration (CI)

### Testing the CI pipeline locally

You can test the CI pipeline ([Github Actions](https://docs.github.com/en/actions)) locally using [nektos/act](https://github.com/nektos/act). Requires docker.

`--reuse` reuses the containers for each workflow job, keeping all installed tools/dependencies. This is recommended for frequent runs since `act` [cannot make use of actions caching](https://github.com/nektos/act/issues/285#issuecomment-987550101), which means all tools/dependencies must be downloaded each time. If you ever want to start again from scratch (empty container), just run without `--reuse`.

```
# Install act with go (see docs for other installation options)
go install github.com/nektos/act@latest

# Run the CI pipeline locally
act --reuse
```
