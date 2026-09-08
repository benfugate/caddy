# caddy-cloudflare

[![Build and Push Docker Image](https://github.com/benfugate/caddy/actions/workflows/publish.yml/badge.svg)](https://github.com/benfugate/caddy/actions/workflows/publish.yml)
[![](https://img.shields.io/docker/pulls/benfugate/caddy)](https://hub.docker.com/r/benfugate/caddy)

Caddy with integrated support for Cloudflare DNS-01 ACME verification challenges, real IP resolution, and Cloudflare IP range support.

**Please see the official [Caddy Docker Image](https://hub.docker.com/_/caddy) for more detailed deployment instructions.**

## Images

A single image is published as `benfugate/caddy:latest`, for `linux/amd64` and `linux/arm64`. Rebuilds are event-driven: when Docker Hub updates the pinned `caddy` digest, Dependabot bumps it and CI merges and republishes automatically. Visit this repository on [Docker Hub](https://hub.docker.com/r/benfugate/caddy) to pull images.

## Modules

| Module | Description |
|--------|-------------|
| [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare) | Cloudflare DNS provider for DNS-01 ACME challenges |
| [WeidiDeng/caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip) | Fetches Cloudflare IP ranges so they can be used with `trusted_proxies cloudflare` |
| [hslatman/caddy-crowdsec-bouncer](https://github.com/hslatman/caddy-crowdsec-bouncer) | Blocks malicious traffic based on decisions made by [CrowdSec](https://crowdsec.net/) |

Real client IP behind Cloudflare is handled by Caddy's native `trusted_proxies`, which
`caddy-cloudflare-ip` feeds with Cloudflare's current ranges:

```Caddyfile
{
    servers {
        trusted_proxies cloudflare
    }
}
```

This sets `{client_ip}` for access logs, the `client_ip` matcher, and any module that reads
it. The [kirsch33/realip](https://github.com/kirsch33/realip) module was previously included
in `:latest` and has been removed - Caddy absorbed that functionality natively in v2.7.0.

## Requirements
1. A Cloudflare account
2. All domains you want to use with Caddy MUST be on your Cloudflare account. For any domains not through Cloudflare you must fall back to another verification method using the `tls` block [here](https://caddyserver.com/docs/caddyfile/directives/tls).

## Notes

Caddy will use DNS-01 ACME verification to generate certificates for any domains you specify in your Caddyfile. You can also use wildcard domains (e.g. `*.example.com`) in your Caddyfile and certificates will be obtained for them. Substitute the `:latest` tag for `:alpine` to use a smaller base image.

## Instructions

1. Obtain your Cloudflare API token by visiting your Cloudflare dashboard and creating a token with the following permissions:
	- Zone / Zone / Read
	- Zone / DNS / Edit

	The token does not need any more permissions than these for DNS-01 ACME verification.

2. Add this to your Caddyfile (or create one with this):
	```Caddyfile
	{
		acme_dns cloudflare {$CLOUDFLARE_API_TOKEN}
		email   {$ACME_EMAIL}
	}
	```

3. Start your Docker container using the following command (substituting your own token and email address):
	```
	docker run -it --name caddy \
		-p 80:80 \
		-p 443:443 \
		-v caddy_data:/data \
		-v caddy_config:/config \
		-v $PWD/Caddyfile:/etc/caddy/Caddyfile \
		-e ACME_EMAIL=me@example.com \
		-e CLOUDFLARE_API_TOKEN=123457890 \
		benfugate/caddy:latest
	```

	Or for docker-compose:
	```yaml
	version: "3.7"

	services:
	  caddy:
	    image: benfugate/caddy:latest
	    restart: unless-stopped
	    environment:
	      - ACME_EMAIL=me@example.com
	      - CLOUDFLARE_API_TOKEN=1234567890
	    ports:
	      - "80:80"
	      - "443:443"
	    volumes:
	      - caddy_data:/data
	      - caddy_config:/config
	      - $PWD/Caddyfile:/etc/caddy/Caddyfile

	volumes:
	  caddy_data:
	  caddy_config: