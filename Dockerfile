FROM alpine:3

RUN apk --no-cache --update add bash git openssh curl \
  && rm -rf /var/cache/apk/*

ENV TF_IN_AUTOMATION=true

COPY src/ /

RUN /install.sh

ENTRYPOINT ["/entrypoint.sh"]
