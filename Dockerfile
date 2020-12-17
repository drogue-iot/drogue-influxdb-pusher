FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL org.opencontainers.image.source="https://github.com/drogue-iot/drogue-influxdb-pusher"

COPY target/release/drogue-influxdb-pusher /

ENTRYPOINT [ "/drogue-influxdb-pusher" ]
