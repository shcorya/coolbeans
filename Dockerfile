FROM golang:1.16.3-alpine AS builder

RUN apk update && apk add make git build-base curl protobuf && \
     rm -rf /var/cache/apk/*

RUN go get golang.org/x/tools/cmd/stringer@v0.1.1 &&\
    go get github.com/golang/protobuf/protoc-gen-go@v1.5.2 &&\
    cd /go/pkg/mod/github.com/golang/protobuf@v1.5.2/protoc-gen-go &&\
    go install

ADD . /go/src/github.com/1xyz/coolbeans
WORKDIR /go/src/github.com/1xyz/coolbeans
RUN make release/linux

###

FROM alpine:latest AS coolbeans  

RUN apk update && apk add ca-certificates bash
WORKDIR /root/
COPY --from=builder /go/src/github.com/1xyz/coolbeans/bin/linux/coolbeans /usr/local/bin/coolbeans

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
