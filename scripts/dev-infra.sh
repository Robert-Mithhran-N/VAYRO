#!/usr/bin/env bash
set -e

ACTION="${1:-start}"

case "$ACTION" in
  start)
    echo "Starting VAYRO PostgreSQL & Redis containers..."
    docker compose up -d
    docker compose ps
    ;;
  stop)
    echo "Stopping VAYRO infrastructure containers (preserving data)..."
    docker compose down
    ;;
  restart)
    echo "Restarting VAYRO infrastructure..."
    docker compose restart
    docker compose ps
    ;;
  status)
    docker compose ps
    ;;
  clean)
    read -p "WARNING: This permanently removes database volumes and data. Continue? (y/N) " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      docker compose down -v
      echo "Infrastructure volumes purged."
    fi
    ;;
  *)
    echo "Usage: ./scripts/dev-infra.sh [start|stop|restart|status|clean]"
    exit 1
    ;;
esac

