FROM ubuntu@sha256:d86db849e59626d94f768c679aba441163c996caf7a3426f44924d0239ffe03f

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
