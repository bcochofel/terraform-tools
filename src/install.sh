#!/usr/bin/env bash

set -o errexit

YQ_VERSION=3.3.0
echo "downloading yq ${YQ_VERSION}"
curl -sL https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
-o /usr/local/bin/yq && chmod +x /usr/local/bin/yq
yq --version

JQ_VERSION=1.6
echo "downloading jq ${JQ_VERSION}"
curl -sL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 \
-o /usr/local/bin/jq && chmod +x /usr/local/bin/jq
jq --version

TFLINT_VERSION=0.16.1
echo "downloading tflint ${TFLINT_VERSION}"
url="https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip"
curl -s -S -L -o /tmp/tflint_${TFLINT_VERSION} ${url} && unzip -d /usr/local/bin /tmp/tflint_${TFLINT_VERSION} &> /dev/null
tflint -v

OPA_VERSION=0.20.5
echo "downloading opa ${OPA_VERSION}"
url="https://github.com/open-policy-agent/opa/releases/download/v${OPA_VERSION}/opa_linux_amd64"
curl -s -S -L -o /usr/local/bin/opa ${url} && chmod +x /usr/local/bin/opa
opa version

TF_VERSION=0.12.26
echo "downloading terraform ${TF_VERSION}"
url="https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
curl -s -S -L -o /tmp/terraform_${TF_VERSION} ${url}
unzip -d /usr/local/bin /tmp/terraform_${TF_VERSION} &> /dev/null
terraform version

CONFTEST=0.18.2
echo "downloading conftest ${CONFTEST}"
curl -sL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST}/conftest_${CONFTEST}_Linux_x86_64.tar.gz | \
tar xz && mv conftest /usr/local/bin/conftest
conftest --version

REGULA_VERSION=0.3.0
mkdir -p /opt/regula && \
  curl -L "https://github.com/fugue/regula/archive/v${REGULA_VERSION}.tar.gz" | \
  tar -xz --strip-components=1 -C /opt/regula/
