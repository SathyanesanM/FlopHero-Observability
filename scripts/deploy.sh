#!/bin/bash
# Deployment Script for FlopHero Observability Stack
# Run this on the EC2 instance to deploy/update the stack

set -e

REPO_DIR="/opt/observability"
REPO_URL="git@github.com:algosoftware/FlopHero-Observability.git"

echo "=== FlopHero Observability Stack Deployment ==="
echo "Timestamp: $(date)"
echo ""

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed"
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "ERROR: Docker Compose is not installed"
    exit 1
fi

# Navigate to repo directory
cd "$REPO_DIR"

# Pull latest changes
echo "Pulling latest changes from Git..."
git pull origin main

# Pull latest Docker images
echo "Pulling latest Docker images..."
docker compose pull

# Restart the stack
echo "Restarting the stack..."
docker compose up -d

# Wait for services to start
echo "Waiting for services to start..."
sleep 10

# Health check
echo ""
echo "=== Health Check ==="
for service in grafana prometheus alertmanager loki yace blackbox nginx; do
    status=$(docker inspect --format='{{.State.Status}}' $service 2>/dev/null || echo "not found")
    echo "$service: $status"
done

echo ""
echo "=== Deployment Complete ==="
echo "Grafana: https://stackmonitor.gametrainer.dev"
echo "Prometheus: https://stackmonitor.gametrainer.dev/prometheus/"
echo "Alertmanager: https://stackmonitor.gametrainer.dev/alertmanager/"
