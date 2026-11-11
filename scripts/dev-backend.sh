#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../backend"

if [ ! -d "node_modules" ]; then
  echo "Installing backend dependencies..."
  npm install
fi

echo "Starting NestJS in development mode..."
npm run start:dev

