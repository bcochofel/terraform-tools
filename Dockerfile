FROM alpine:3.20
LABEL maintainer="Bruno Cochofel <bruno.cochofel@gmail.com>"

ARG ARKADE_VERSION=0.11.23
ARG TFENV_VERSION=v3.0.0
ARG TERRAFORM_VERSION=1.9.5
ARG TFLINT_VERSION=v0.53.0
ARG TFLINT_RULESET_AZURERM_VERSION=0.27.0
ARG TFLINT_RULESET_AWS_VERSION=0.32.0
ARG TFLINT_RULESET_GOOGLE_VERSION=0.30.0

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
RUN git clone -b ${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv && \
  ln -s ${WORKDIR}/.tfenv/bin/* ${INSTALL_DIR} && \
  tfenv install ${TERRAFORM_VERSION} && \
  tfenv use ${TERRAFORM_VERSION}

# install TFlint
RUN curl -s -Lo tflint.zip https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip && \
  unzip tflint.zip && \
  rm -f tflint.zip && \
  chmod +x tflint && \
  mv tflint /usr/local/bin

# install TFlint azurerm ruleset
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

RUN chown -R appuser:appgroup ${WORKDIR}
USER appuser
RUN tflint --init
