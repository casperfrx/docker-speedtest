FROM alpine:latest as builddeps
ARG RUN_USER=nobody

RUN apk add -U --no-cache \
        curl \
        ca-certificates \
&&  curl -sSL \
        https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-1.0.0-x86_64-linux.tgz \
    | tar -zx -C /opt speedtest \
&&  curl -sSL -o /opt/dumb-init \
        https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
&&  chmod +x /opt/speedtest /opt/dumb-init \
&&  echo "$RUN_USER:x:65534:65534:$RUN_USER:/:/sbin/nologin" > /opt/passwd

FROM scratch
ARG RUN_USER=nobody

LABEL description="Simple out of the box Speedtest CLI script for internet speed testing." \
      note="Uses the latest alpine's distributed CA certificates bundle."

COPY --from=builddeps /opt/passwd /etc/passwd
COPY --from=builddeps /opt/speedtest /speedtest
COPY --from=builddeps /opt/dumb-init /dumb-init
COPY --from=builddeps /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

USER $RUN_USER

ENTRYPOINT ["/dumb-init", "--", "/speedtest", "--ca-certificate", "/etc/ssl/certs/ca-certificates.crt"]

# Setting these flags as optional CMDs, because you should be allowed to deny.
# Also: start with --help for a usage print.
CMD ["--accept-license", "--accept-gdpr"]

