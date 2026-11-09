ARG CADDY_BUILDER_IMAGE=caddy:builder

FROM ${CADDY_BUILDER_IMAGE} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http

FROM caddy:latest@sha256:ce773ec7a742ce15ee6bf2bb5f65882b9e2a4487b10733e6f1484f86e6b5d8bc

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
