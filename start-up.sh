#!/bin/bash

git_url="https://github.com/your-org/your-repo"   
git_token="YOUR_GITHUB_RUNNER_TOKEN"            
runner_name="gcp-runner-$(hostname)"
runner_label="gcp,ubuntu"

mkdir -p /actions-runner && cd /actions-runner

apt-get update
apt-get install -y curl jq git

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
  RUNNER_ARCH="x64"
elif [[ "$ARCH" == "aarch64" ]]; then
  RUNNER_ARCH="arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

GH_RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')
curl -O -L "https://github.com/actions/runner/releases/download/${GH_RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${GH_RUNNER_VERSION:1}.tar.gz"

tar xzf ./actions-runner-linux-${RUNNER_ARCH}-${GH_RUNNER_VERSION:1}.tar.gz

./config.sh --url "$git_url" \
            --token "$git_token" \
            --name "$runner_name" \
            --labels "$runner_label" \
            --unattended \
            --replace
            
./svc.sh install
./svc.sh start
