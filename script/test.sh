#!/usr/bin/env bash

set -e

git clone https://github.com/asdf-vm/asdf.git ~/.asdf
export PATH="${PATH}:${HOME}/.asdf/bin:${HOME}/.asdf/shims"

asdf --version

cat << 'EOF' > ~/.tool-versions
golang 1.17.6
terraform 1.1.3
terragrunt 0.35.20
tflint 0.34.1
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
