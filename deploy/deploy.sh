#!/usr/bin/env bash
# Publish the latest pushed commit to the VPS. Run locally after `git push`.
set -euo pipefail

HOST="${1:-keithgdr-host}"

ssh "$HOST" 'set -e
git -C /var/www/keithgdr.dev pull --ff-only
# Reload Caddy only when the site config changed.
if ! cmp -s /var/www/keithgdr.dev/deploy/keithgdr.dev.caddy /etc/caddy/sites/keithgdr.dev.caddy; then
    sudo install -m 0644 /var/www/keithgdr.dev/deploy/keithgdr.dev.caddy /etc/caddy/sites/keithgdr.dev.caddy
    sudo caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile
    sudo systemctl reload caddy
fi'
