ARG CADDY_BUILDER_IMAGE=caddy:builder

FROM ${CADDY_BUILDER_IMAGE} AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/kirsch33/realip

FROM caddy:latest@sha256:25cdc846626b62d05f6b633b9b40c2c9f6ef89b515dc76133cefd920f7dbe562

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
