# VAYRO — Start Admin Dashboard in Development Mode
Push-Location "$PSScriptRoot\..\admin"
try {
  if (-not (Test-Path "node_modules")) {
    Write-Host "Installing admin dependencies..." -ForegroundColor Cyan
    npm install
  }
  Write-Host "Starting Vite development server..." -ForegroundColor Green
  npm run dev
} finally {
  Pop-Location
}

