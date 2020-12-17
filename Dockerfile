FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL org.opencontainers.image.source="https://github.com/drogue-iot/drogue-influxdb-pusher"

COPY target/release/influxdb-pusher /

ENTRYPOINT [ "/influxdb-pusher" ]
