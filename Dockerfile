#!BuildTag: rancher/hardened-build-base:latest

ARG GOLANG_VERSION=1.22.4

FROM --platform=$TARGETPLATFORM library/golang:${GOLANG_VERSION}-alpine AS golang

FROM alpine:3.18
ENV GOTOOLCHAIN=local
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
COPY --from=golang /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH

COPY scripts/ /usr/local/go/bin/

RUN set -x && \
    chmod -v +x /usr/local/go/bin/go-*.sh && \
    go version
