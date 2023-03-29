FROM alpine:3.15
WORKDIR /opt/main
ENV PATH="/opt/main/src:$PATH"

RUN apk add --update-cache \
      bats

ENTRYPOINT [ "bats" ]
CMD [ "--tap", "test" ]
