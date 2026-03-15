#!/bin/bash

echo "Installing AI Daily Bot..."

python3 -m venv .venv
source .venv/bin/activate
pip install feedparser requests pyyaml

chmod +x scripts/*.sh
echo "Done."
