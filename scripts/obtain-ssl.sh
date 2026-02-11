#!/usr/bin/env bash
# One-time: obtain Let's Encrypt certificate for monitoring.gametrainer.dev.
# Run on the server. Usage: CERTBOT_EMAIL=admin@example.com ./scripts/obtain-ssl.sh

set -e
DOMAIN=monitoring.gametrainer.dev
EMAIL="${CERTBOT_EMAIL:-admin@gametrainer.dev}"

cd /opt/observability
mkdir -p nginx/webroot

echo "Stopping Nginx to free port 80..."
docker compose stop nginx 2>/dev/null || true
sleep 2

echo "Obtaining certificate for $DOMAIN..."
certbot certonly --standalone -d "$DOMAIN" \
  --email "$EMAIL" \
  --agree-tos \
  --non-interactive \
  --preferred-challenges http

echo "Starting Nginx with new certificate..."
docker compose up -d nginx

echo "Done. Certificate is at /etc/letsencrypt/live/$DOMAIN/"
