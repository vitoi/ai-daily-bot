#!/bin/zsh
set -e

echo "Installing AI Daily Bot..."

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python3 is required."
  exit 1
fi

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

chmod +x scripts/*.sh

echo "Install complete."
