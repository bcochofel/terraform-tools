FROM alpine:3.20
LABEL maintainer="Bruno Cochofel <bruno.cochofel@gmail.com>"

ARG ARKADE_VERSION=0.11.23
ARG TFENV_VERSION=v3.0.0
ARG TERRAFORM_VERSION=1.9.5

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

# install arkade https://github.com/alexellis/arkade
RUN curl -s -Lo arkade https://github.com/alexellis/arkade/releases/download/${ARKADE_VERSION}/arkade && \
  chmod +x arkade && \
  mv arkade ${INSTALL_DIR}

# install tfenv https://github.com/tfutils/tfenv
RUN git clone -b ${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv && \
    ln -s ${WORKDIR}/.tfenv/bin/* ${INSTALL_DIR} && \
    tfenv install ${TERRAFORM_VERSION} && \
    tfenv use ${TERRAFORM_VERSION}

USER appuser
