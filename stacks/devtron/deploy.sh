#!/bin/sh

set -e

################################################################################
# repo
################################################################################
helm repo add devtron https://helm.devtron.ai
helm repo update > /dev/null

################################################################################
# chart
################################################################################
STACK="devtron"
CHART="devtron/devtron-operator"
CHART_VERSION="0.22.54"
NAMESPACE="devtroncd"

if [ -z "${MP_KUBERNETES}" ]; then
  # use local version of values.yml
  ROOT_DIR=$(git rev-parse --show-toplevel)
  values="$ROOT_DIR/stacks/devtron/values.yml"
else
  # use github hosted master version of values.yml
  values="https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/devtron/values.yml"
fi

helm upgrade "$STACK" "$CHART" \
  --create-namespace \
  --install \
  --timeout 8m0s \
  --namespace "$NAMESPACE" \
  --values "$values" \
  --version "$CHART_VERSION"
