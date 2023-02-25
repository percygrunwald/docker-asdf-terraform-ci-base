#!/usr/bin/env bash

# Test to ensure that installation of all asdf plugins succeeds and all
# necessary commands are available and work.

set -e

git clone https://github.com/asdf-vm/asdf.git ~/.asdf
export PATH="${PATH}:${HOME}/.asdf/bin:${HOME}/.asdf/shims"

asdf --version

cat << 'EOF' > ~/.tool-versions
golang 1.20.1
terraform 1.3.9
terragrunt 0.44.0
tflint 0.45.0
EOF

while read PLUGIN VERSION; do
  asdf plugin add $PLUGIN
done < ~/.tool-versions

asdf plugin list
asdf install

pip --version
python3 --version
go version
terraform --version
tflint --version
terragrunt --version
