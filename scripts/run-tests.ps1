# VAYRO — Run All Monorepo Test Suites
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "       Running VAYRO Monorepo Tests          " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 1. Backend Tests
Push-Location "$PSScriptRoot\..\backend"
try {
  Write-Host "`n[1/3] Running Backend Tests..." -ForegroundColor Yellow
  if (Test-Path "node_modules") {
    npm test
  } else {
    Write-Host "Backend node_modules absent. Run 'npm install' in backend/ first." -ForegroundColor Red
  }
} finally {
  Pop-Location
}

# 2. Admin Tests
Push-Location "$PSScriptRoot\..\admin"
try {
  Write-Host "`n[2/3] Running Admin Tests..." -ForegroundColor Yellow
  if (Test-Path "node_modules") {
    npm test
  } else {
    Write-Host "Admin node_modules absent. Run 'npm install' in admin/ first." -ForegroundColor Red
  }
} finally {
  Pop-Location
}

# 3. Flutter Tests
Push-Location "$PSScriptRoot\..\mobile"
try {
  Write-Host "`n[3/3] Running Flutter Tests..." -ForegroundColor Yellow
  if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter test
  } else {
    Write-Host "Flutter SDK not detected in environment PATH. Skipping local execution." -ForegroundColor Yellow
  }
} finally {
  Pop-Location
}

Write-Host "`nTest execution pass complete." -ForegroundColor Green

