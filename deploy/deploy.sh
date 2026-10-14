#!/usr/bin/env bash
# Publish the latest pushed commit to the VPS. Run locally after `git push`.
set -euo pipefail

HOST="${1:-keithgdr-host}"

ssh "$HOST" 'git -C /var/www/keithgdr.dev pull --ff-only'
