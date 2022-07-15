FROM alpine:latest as builddeps
ARG RUN_USER=nobody

RUN apk add -U --no-cache \
        curl \
        ca-certificates \
&&  curl -sSL \
        https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz \
    | tar -zx -C /opt speedtest \
&&  chmod +x /opt/speedtest
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

LABEL usage="docker run -it --rm --cap-drop ALL your/image [...args]"

ENTRYPOINT ["/speedtest", "--ca-certificate", "/etc/ssl/certs/ca-certificates.crt"]

# Setting these flags as optional CMDs, because you should be allowed to deny.
# Also: start with --help for a usage print.
CMD ["--accept-license", "--accept-gdpr"]

