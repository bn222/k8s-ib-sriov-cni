FROM golang:1.19-alpine as builder

COPY . /usr/src/ib-sriov-cni

ENV HTTP_PROXY $http_proxy
ENV HTTPS_PROXY $https_proxy

RUN apk add --update --virtual build-dependencies build-base linux-headers git && \
    cd /usr/src/ib-sriov-cni && \
    make clean && \
    make build

FROM alpine
COPY --from=builder /usr/src/ib-sriov-cni/build/ib-sriov /usr/bin/
WORKDIR /

LABEL io.k8s.display-name="InfiniBand SR-IOV CNI"

COPY ./images/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
