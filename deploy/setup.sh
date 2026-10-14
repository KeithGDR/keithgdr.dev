#!/usr/bin/env bash
# One-time server setup for keithgdr.dev. Run on the VPS as a user with sudo:
#   curl -fsSL https://raw.githubusercontent.com/KeithGDR/keithgdr.dev/main/deploy/setup.sh | bash
# Expects Caddy to be installed already, with /etc/caddy/Caddyfile containing
# `import /etc/caddy/sites/*.caddy` (the Kdex repo's Caddyfile does this).
set -euo pipefail

REPO="https://github.com/KeithGDR/keithgdr.dev.git"
ROOT="/var/www/keithgdr.dev"

command -v git >/dev/null || { sudo apt-get update && sudo apt-get install -y git; }

# Site files: a clone of the repo, owned by the current user so `git pull` needs no sudo.
if [ ! -d "$ROOT/.git" ]; then
    sudo mkdir -p "$ROOT"
    sudo chown "$USER": "$ROOT"
    git clone "$REPO" "$ROOT"
fi

sudo install -D -m 0644 "$ROOT/deploy/keithgdr.dev.caddy" /etc/caddy/sites/keithgdr.dev.caddy
sudo caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile
sudo systemctl reload caddy

echo "Done: https://keithgdr.dev"
