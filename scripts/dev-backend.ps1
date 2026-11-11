# VAYRO — Start Backend API in Development Mode
Push-Location "$PSScriptRoot\..\backend"
try {
  if (-not (Test-Path "node_modules")) {
    Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
    npm install
  }
  Write-Host "Starting NestJS in development mode..." -ForegroundColor Green
  npm run start:dev
} finally {
  Pop-Location
}
