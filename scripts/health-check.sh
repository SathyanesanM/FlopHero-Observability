#!/bin/bash
# Health Check Script for FlopHero Observability Stack

echo "=== FlopHero Observability Stack Health Check ==="
echo "Timestamp: $(date)"
echo ""

# Check Docker containers
echo "=== Container Status ==="
docker compose ps

echo ""
echo "=== Service Health ==="

# Grafana
grafana_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health 2>/dev/null)
echo "Grafana: $grafana_status"

# Prometheus
prometheus_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090/-/healthy 2>/dev/null)
echo "Prometheus: $prometheus_status"

# Alertmanager
alertmanager_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9093/-/healthy 2>/dev/null)
echo "Alertmanager: $alertmanager_status"

# Loki
loki_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3100/ready 2>/dev/null)
echo "Loki: $loki_status"

# YACE
yace_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/metrics 2>/dev/null)
echo "YACE: $yace_status"

# Blackbox
blackbox_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9115/metrics 2>/dev/null)
echo "Blackbox: $blackbox_status"

echo ""
echo "=== Disk Usage ==="
df -h /var/lib/docker

echo ""
echo "=== Memory Usage ==="
free -h
