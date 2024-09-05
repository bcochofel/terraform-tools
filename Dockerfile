FROM alpine:3.20
LABEL maintainer="Bruno Cochofel <bruno.cochofel@gmail.com>"

ARG ARKADE_VERSION=0.11.23
ARG TFENV_VERSION=3.0.0
ARG TERRAFORM_VERSION=1.9.5
ARG TGENV_VERSION=1.2.1
ARG TERRAGRUNT_VERSION=0.67.3
ARG TFLINT_VERSION=0.53.0
ARG TFLINT_RULESET_AZURERM_VERSION=0.27.0
ARG TFLINT_RULESET_AWS_VERSION=0.32.0
ARG TFLINT_RULESET_GOOGLE_VERSION=0.30.0
ARG TERRAFORM_DOCS_VERSION=0.18.0
ARG TFSEC_VERSION=1.28.10
ARG TRIVY_VERSION=0.55.0

# install dependencies
RUN apk --no-cache --update add \
  sudo \
  bash \
  git \
  openssh \
  curl \
  zip && \
  rm -rf /var/cache/apk/*

ENV WORKDIR=/home/appuser
ENV INSTALL_DIR=/usr/local/bin/

RUN addgroup -S appgroup && adduser -SDH appuser -G appgroup
RUN mkdir -p ${WORKDIR}
RUN chown -R appuser:appgroup ${WORKDIR}
WORKDIR ${WORKDIR}

# install arkade
RUN curl -s -Lo arkade https://github.com/alexellis/arkade/releases/download/${ARKADE_VERSION}/arkade && \
  chmod +x arkade && \
  mv arkade ${INSTALL_DIR}

# install tfenv
RUN git clone -b v${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv && \
  ln -s ${WORKDIR}/.tfenv/bin/* ${INSTALL_DIR} && \
  tfenv install ${TERRAFORM_VERSION} && \
  tfenv use ${TERRAFORM_VERSION}

# intall tgenv
RUN git clone -b v${TGENV_VERSION} https://github.com/tgenv/tgenv.git ${WORKDIR}/.tgenv && \
  ln -s ${WORKDIR}/.tgenv/bin/* ${INSTALL_DIR} && \
  tgenv install ${TERRAGRUNT_VERSION} && \
  tgenv use ${TERRAGRUNT_VERSION}

# install TFlint
RUN curl -s -Lo tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
  unzip tflint.zip && \
  rm -f tflint.zip && \
  chmod +x tflint && \
  mv tflint /usr/local/bin

# install TFlint rulesets for AWS, AzureRM and Google
COPY <<EOT .tflint.hcl
plugin "azurerm" {
    enabled = true
    version = "${TFLINT_RULESET_AZURERM_VERSION}"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "aws" {
    enabled = true
    version = "${TFLINT_RULESET_AWS_VERSION}"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "google" {
    enabled = true
    version = "${TFLINT_RULESET_GOOGLE_VERSION}"
    source  = "github.com/terraform-linters/tflint-ruleset-google"
}
EOT

# install terraform-docs
RUN curl -s -Lo terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz && \
  tar xzf terraform-docs.tar.gz && \
  rm -f terraform-docs.tar.gz LICENSE README.md && \
  chmod +x terraform-docs && \
  mv terraform-docs /usr/local/bin

# install TFsec
RUN curl -s -Lo tfsec https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 && \
  chmod +x tfsec && \
  mv tfsec /usr/local/bin

# install trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v${TRIVY_VERSION}

RUN chown -R appuser:appgroup ${WORKDIR}
USER appuser
RUN tflint --init
