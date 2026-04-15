ARG CADDY_BUILDER_IMAGE=caddy:builder

FROM ${CADDY_BUILDER_IMAGE} AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/kirsch33/realip

FROM caddy:latest@sha256:2acb10cebb92eea91a40b76691aff73adde9151416facbeab630bbc66d0969ab

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
