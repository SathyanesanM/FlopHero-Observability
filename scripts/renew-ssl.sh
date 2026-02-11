#!/usr/bin/env bash
# Renew Let's Encrypt certificate and reload Nginx.
# Crontab: 0 0 1,16 * * /opt/observability/scripts/renew-ssl.sh

set -e
cd /opt/observability
WEBROOT="$(pwd)/nginx/webroot"
certbot renew --webroot -w "$WEBROOT" --quiet
docker exec svc-mon-nginx nginx -s reload 2>/dev/null || true
