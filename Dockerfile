ARG CADDY_BUILDER_IMAGE=caddy:builder

FROM ${CADDY_BUILDER_IMAGE} AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/kirsch33/realip

FROM caddy:latest@sha256:261437d35b88cc2f8fa1ed337ebb6b6ce2bd5cd61b2a28cdf83cb201db0a853b

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
