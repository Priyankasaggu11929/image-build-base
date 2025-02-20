#!BuildTag: rancher/hardened-build-base:latest

ARG GOLANG_VERSION=1.22.4

FROM --platform=$TARGETPLATFORM library/golang:${GOLANG_VERSION}-alpine AS golang

FROM alpine:3.18 as trivy-amd64
ARG TRIVY_VERSION=0.56.2
#!RemoteAssetUrl: https://github.com/aquasecurity/trivy/releases/download/v0.56.2/trivy_0.56.2_Linux-64bit.tar.gz
RUN set -ex; \
    tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz; \
    mv trivy /usr/local/bin

FROM alpine:3.18 as trivy-arm64
ARG TRIVY_VERSION=0.56.2
#!RemoteAssetUrl: https://github.com/aquasecurity/trivy/releases/download/vv0.56.2/trivy_v0.56.2_Linux-ARM64.tar.gz
RUN set -ex; \
    tar -xzf trivy_${TRIVY_VERSION}_Linux-ARM64.tar.gz; \
    mv trivy /usr/local/bin

FROM trivy-amd64 as trivy-base

FROM alpine:3.18
ENV GOTOOLCHAIN=local
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
COPY --from=golang /usr/local/go/ /usr/local/go/
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH

COPY scripts/ /usr/local/go/bin/
COPY --from=trivy-base /usr/local/bin/ /usr/bin/
RUN set -x && \
    chmod -v +x /usr/local/go/bin/go-*.sh && \
    go version
