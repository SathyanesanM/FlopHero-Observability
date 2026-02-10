# FlopHero Observability Stack

Dockerized GPL (Grafana, Prometheus, Loki) monitoring stack for FlopHero infrastructure.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    FlopHero Observability                        │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────┐  ┌────────────┐  ┌──────┐  ┌──────────────┐       │
│  │ Grafana │  │ Prometheus │  │ Loki │  │ Alertmanager │       │
│  │  :3000  │  │   :9090    │  │:3100 │  │    :9093     │       │
│  └────┬────┘  └─────┬──────┘  └──┬───┘  └──────┬───────┘       │
│       │             │            │             │                │
│       └─────────────┼────────────┼─────────────┘                │
│                     │            │                              │
│  ┌──────────────────┴────────────┴──────────────────────┐      │
│  │                    Nginx (:80/:443)                   │      │
│  └───────────────────────────────────────────────────────┘      │
│                                                                 │
│  ┌────────┐  ┌──────────┐                                      │
│  │  YACE  │  │ Blackbox │                                      │
│  │ :5000  │  │  :9115   │                                      │
│  └────────┘  └──────────┘                                      │
└─────────────────────────────────────────────────────────────────┘
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| Grafana | 3000 | Dashboards and visualization |
| Prometheus | 9090 | Metrics collection and alerting |
| Loki | 3100 | Log aggregation |
| Alertmanager | 9093 | Alert routing and notifications |
| YACE | 5000 | CloudWatch metrics exporter |
| Blackbox | 9115 | Synthetic monitoring |
| Nginx | 80/443 | Reverse proxy with SSL |

## Quick Start

### Prerequisites

- Docker 24.0+
- Docker Compose 2.0+
- AWS CLI configured with cross-account access

### Deployment

1. Clone the repository:
   ```bash
   git clone git@github.com:algosoftware/FlopHero-Observability.git
   cd FlopHero-Observability
   ```

2. Copy and configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. Add SSL certificates:
   ```bash
   # Place your certificates in nginx/ssl/
   # - fullchain.pem
   # - privkey.pem
   ```

4. Start the stack:
   ```bash
   docker compose up -d
   ```

5. Check health:
   ```bash
   ./scripts/health-check.sh
   ```

## Configuration

### Prometheus

- Main config: `prometheus/prometheus.yml`
- Alert rules: `prometheus/rules/`

### Loki

- Config: `loki/loki-config.yaml`
- Alert rules: `loki/rules/`

### Alertmanager

- Config: `alertmanager/alertmanager.yml`
- Templates: `alertmanager/templates/`

### Grafana

- Datasources: `grafana/provisioning/datasources/`
- Dashboards: `grafana/dashboards/`

## Environments

| Environment | Account | Region | Services |
|-------------|---------|--------|----------|
| Production | 133585426375 | eu-west-1 | PGT Backend, Frontend, Mongo |
| Staging | 928452448115 | us-east-1 | PGT Backend, Mongo |
| Development | 928452448115 | us-east-1 | ECS containers, Feature branches |
| Monitoring | 383313559624 | us-east-1 | GPL Stack |

## Updating

```bash
cd /opt/observability
git pull
docker compose pull
docker compose up -d
```

## Troubleshooting

### Check container logs
```bash
docker compose logs -f grafana
docker compose logs -f prometheus
docker compose logs -f loki
```

### Restart a service
```bash
docker compose restart prometheus
```

### Validate Prometheus config
```bash
docker compose exec prometheus promtool check config /etc/prometheus/prometheus.yml
```

### Validate Alertmanager config
```bash
docker compose exec alertmanager amtool check-config /etc/alertmanager/alertmanager.yml
```
