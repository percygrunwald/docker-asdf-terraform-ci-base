FROM ubuntu@sha256:a4fab1802f08df089c4b2e0a1c8f1a06f573bd1775687d07fef4076d3a2e4900

# https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies
ENV ASDF_DEPS="git curl"

# https://github.com/kennyp/asdf-golang
ENV GO_DEPS="coreutils curl"

# https://github.com/asdf-community/asdf-hashicorp
ENV TERRAFORM_DEPS="unzip"

# https://github.com/lotia/asdf-terragrunt
ENV TERRAGRUNT_DEPS=""

# https://github.com/skyzyx/asdf-tflint
ENV TFLINT_DEPS=""

# https://pre-commit.com/#install
ENV PRE_COMMIT_DEPS="python3 python3-pip python3-venv"

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
  ${ASDF_DEPS} \
  ${GO_DEPS} \
  ${TERRAFORM_DEPS} \
  ${TERRAGRUNT_DEPS} \
  ${TFLINT_DEPS} \
  ${PRE_COMMIT_DEPS} \
  && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
