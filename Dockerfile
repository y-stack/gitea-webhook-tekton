FROM golang:1.13.1-alpine3.10@sha256:2293e952c79b8b3a987e1e09d48b6aa403d703cef9a8fa316d30ba2918d37367 as builder
WORKDIR /build

COPY *.go go.mod go.sum config.yaml ./
RUN go get ./...  && \
    CGO_ENABLED=0 go build -o gitea-webhook *.go

FROM alpine:3.10@sha256:72c42ed48c3a2db31b7dafe17d275b634664a708d901ec9fd57b1529280f01fb
WORKDIR /app

COPY --from=builder /build/gitea-webhook /build/config.yaml ./
CMD ["./gitea-webhook"]
