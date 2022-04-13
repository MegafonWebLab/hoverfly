FROM golang:1.16.7-alpine AS build-client
RUN apk --no-cache add ca-certificates git make unzip openssl
WORKDIR /app
COPY . /app
RUN go get github.com/rakyll/statik
RUN make build-ui

FROM golang:1.16.7 AS build-env
WORKDIR /usr/local/go/src/github.com/SpectoLabs/hoverfly
COPY . /usr/local/go/src/github.com/SpectoLabs/hoverfly
COPY --from=build-client /app/core/statik /usr/local/go/src/github.com/SpectoLabs/hoverfly/core/statik
RUN cd core/cmd/hoverfly && CGO_ENABLED=0 GOOS=linux go install -ldflags "-s -w"

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=build-env /usr/local/go/bin/hoverfly /bin/hoverfly
ENTRYPOINT ["/bin/hoverfly", "-listen-on-host=0.0.0.0"]
CMD [""]

EXPOSE 8500 8888
