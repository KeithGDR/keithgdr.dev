#!/usr/bin/env bash
# One-time server setup for keithgdr.dev. Run on the VPS as a user with sudo:
#   curl -fsSL https://raw.githubusercontent.com/KeithGDR/keithgdr.dev/main/deploy/setup.sh | bash -s you@example.com
# Needs DNS for keithgdr.dev (and www) pointing at this server before it runs, for the certificate.
set -euo pipefail

EMAIL="${1:?usage: setup.sh <email for LetsEncrypt>}"
REPO="https://github.com/KeithGDR/keithgdr.dev.git"
ROOT="/var/www/keithgdr.dev"

# Packages (Debian/Ubuntu or Fedora/RHEL).
if command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y nginx git certbot python3-certbot-nginx
    CONF="/etc/nginx/sites-available/keithgdr.dev"
else
    sudo dnf install -y nginx git certbot python3-certbot-nginx
    CONF="/etc/nginx/conf.d/keithgdr.dev.conf"
fi

# Site files: a clone of the repo, owned by the current user so `git pull` needs no sudo.
if [ ! -d "$ROOT/.git" ]; then
    sudo mkdir -p "$ROOT"
    sudo chown "$USER": "$ROOT"
    git clone "$REPO" "$ROOT"
fi

# nginx config.
sudo cp "$ROOT/deploy/nginx.conf" "$CONF"
if [ -d /etc/nginx/sites-enabled ]; then
    sudo ln -sf "$CONF" /etc/nginx/sites-enabled/keithgdr.dev
fi
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx

# Firewall, if one is active.
if command -v ufw >/dev/null && sudo ufw status | grep -q active; then
    sudo ufw allow 'Nginx Full'
elif command -v firewall-cmd >/dev/null && sudo firewall-cmd --state >/dev/null 2>&1; then
    sudo firewall-cmd --permanent --add-service=http --add-service=https
    sudo firewall-cmd --reload
fi

# HTTPS via LetsEncrypt. Certbot installs a renewal timer automatically.
sudo certbot --nginx --non-interactive --agree-tos --redirect -m "$EMAIL" \
    -d keithgdr.dev -d www.keithgdr.dev

echo "Done: https://keithgdr.dev"
