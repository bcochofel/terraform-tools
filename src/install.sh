#!/usr/bin/env bash

set -o errexit

TFENV_VERSION=v3.0.0
TGENV_VERSION=v1.2.1
TERRAFORM_VERSION=1.5.7
TERRAGRUNT_VERSION=0.67.1
OPA_VERSION=v0.68.0
CONFTEST_VERSION=v0.55.0
CHECKOV_VERSION=3.2.242
TERRAFORM_DOCS_VERSION=v0.18.0
TFSEC_VERSION=v1.28.10
TFLINT_VERSION=v0.53.0
TFLINT_RULESET_AZURERM_VERSION=0.27.0

WORKDIR=/home/appuser
INSTALL_DIR=${WORKDIR}/.local/bin

#echo "downloading tfenv ${TFENV_VERSION}"
#git clone -b ${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv && \
#    ln -s ${WORKDIR}/.tfenv/bin/* ${INSTALL_DIR} && \
#    tfenv install ${TERRAFORM_VERSION} && \
#    tfenv use ${TERRAFORM_VERSION}
#
#echo "downloading tgenv ${TGENV_VERSION}"
#git clone -b ${TGENV_VERSION} https://github.com/tgenv/tgenv.git ${WORKDIR}/.tgenv && \
#    ln -s ${WORKDIR}/.tgenv/bin/* ${INSTALL_DIR} && \
#    tgenv install ${TERRAGRUNT_VERSION} && \
#    tgenv use ${TERRAGRUNT_VERSION}
#
#echo "downloading opa ${OPA_VERSION}"
#url="https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64"
#curl -s -Lo /usr/local/bin/opa ${url} && chmod +x /usr/local/bin/opa
#opa version
#
#echo "downloading conftest ${CONFTEST_VERSION}"
#curl -sL https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz | \
#tar xz && mv conftest /usr/local/bin/conftest
#conftest --version
#
#echo "downloading checkov ${CHECKOV_VERSION}"
#url="https://github.com/bridgecrewio/checkov/releases/download/${CHECKOV_VERSION}/checkov_linux_X86_64.zip"
#curl -s -Lo /tmp/checkov.zip ${url} && \
#    unzip /tmp/checkov.zip && \
#    mv ./dist/checkov /usr/local/bin
#checkov -v

echo "downloading terraform-docs ${TERRAFORM_DOCS_VERSION}"
url="https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz"
curl -s -Lo /tmp/terraform-docs.tar.gz ${url} && \
    tar xzf /tmp/terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin
terraform-docs version

echo "downloading tfsec ${TFSEC_VERSION}"
curl -s -Lo tfsec https://github.com/tfsec/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64 && \
    chmod +x tfsec && \
    mv tfsec /usr/local/bin
tfsec -v

echo "downloading tflint ${TFLINT_VERSION}"
url="https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip"
curl -s -Lo /tmp/tflint_${TFLINT_VERSION} ${url} && unzip -d /usr/local/bin /tmp/tflint_${TFLINT_VERSION} &> /dev/null
tflint -v

echo "initializing tflint-ruleset-azurerm ${TFLINT_RULESET_AZURERM_VERSION}"
cat << EOF > .tflint.hcl
plugin "azurerm" {
    enabled = true
    version = "${TFLINT_RULESET_AZURERM_VERSION}"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
EOF
tflint --init
tflint -v
