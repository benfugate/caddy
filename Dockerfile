ARG CADDY_BUILDER_IMAGE=caddy:builder

FROM ${CADDY_BUILDER_IMAGE} AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/kirsch33/realip

FROM caddy:latest@sha256:1e40b251ca9639ead7b5cd2cedcc8765adfbabb99450fe23f130eefabf50f4bc

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
