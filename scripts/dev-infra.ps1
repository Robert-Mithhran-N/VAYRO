# VAYRO — Development Infrastructure Helper (PowerShell)
param(
  [Parameter(Position=0)]
  [ValidateSet("start", "stop", "restart", "status", "clean")]
  [string]$Action = "start"
)

switch ($Action) {
  "start" {
    Write-Host "Starting VAYRO PostgreSQL & Redis containers..." -ForegroundColor Cyan
    docker compose up -d
    docker compose ps
  }
  "stop" {
    Write-Host "Stopping VAYRO infrastructure containers (preserving data)..." -ForegroundColor Yellow
    docker compose down
  }
  "restart" {
    Write-Host "Restarting VAYRO infrastructure..." -ForegroundColor Cyan
    docker compose restart
    docker compose ps
  }
  "status" {
    docker compose ps
  }
  "clean" {
    $confirm = Read-Host "WARNING: This permanently removes database volumes and data. Continue? (y/N)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
      docker compose down -v
      Write-Host "Infrastructure volumes purged." -ForegroundColor Red
    }
  }
}

