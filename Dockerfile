#!BuildTag: test-image2:latest

FROM bci/golang:1.23 as build

ENV GOTOOLCHAIN=local
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
RUN zypper install -y \
    bash \
    coreutils \
    curl \
    docker \
    file \
    # g++ \
    gcc-c++ \
    gcc \
    git \
    make \
    # mercurial \
    rsync \
    subversion \
    trivy \
    wget \
    yq \
    zstd
COPY scripts/ /usr/local/go/bin/
RUN set -x && \
    go version
    # go version && \
    # trivy image --download-db-only --quiet

