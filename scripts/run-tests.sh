#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

echo "============================================="
echo "       Running VAYRO Monorepo Tests          "
echo "============================================="

# 1. Backend
echo -e "\n[1/3] Running Backend Tests..."
cd "$ROOT_DIR/backend"
if [ -d "node_modules" ]; then
  npm test
else
  echo "Backend node_modules absent. Run npm install first."
fi

# 2. Admin
echo -e "\n[2/3] Running Admin Tests..."
cd "$ROOT_DIR/admin"
if [ -d "node_modules" ]; then
  npm test
else
  echo "Admin node_modules absent. Run npm install first."
fi

# 3. Mobile
echo -e "\n[3/3] Running Mobile Tests..."
cd "$ROOT_DIR/mobile"
if command -v flutter &> /dev/null; then
  flutter test
else
  echo "Flutter SDK not installed. Skipping local execution."
fi

echo -e "\nAll tests completed."

