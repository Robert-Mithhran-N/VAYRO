#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../admin"

if [ ! -d "node_modules" ]; then
  echo "Installing admin dependencies..."
  npm install
fi

echo "Starting Vite development server..."
npm run dev
