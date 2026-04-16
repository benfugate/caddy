ARG CADDY_BUILDER_IMAGE=caddy:builder

FROM ${CADDY_BUILDER_IMAGE} AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare \
    github.com/kirsch33/realip

FROM caddy:latest@sha256:22e1d921a7dd98ea722ebd6819de785fd71abdab7f7fed8a2378e96d29bb923a

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
