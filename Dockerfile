FROM alpine:latest
RUN apk --no-cache add ca-certificates

COPY target/bin/linux/amd64/hoverfly /bin/hoverfly
COPY target/bin/linux/amd64/hoverctl /bin/hoverctl

ENTRYPOINT ["/bin/hoverfly", "-listen-on-host=0.0.0.0"]
CMD [""]

EXPOSE 8500 8888
