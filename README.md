# keithgdr.dev

My personal website which lets people find me. Plain HTML and CSS, served by nginx on my VPS with a LetsEncrypt certificate.

## Editing

- Bio and links live in `index.html` (look for the comments).
- Colors live at the top of `style.css`.
- Images come from `Personal Branding/` and are converted to small `.webp` files in `img/`.

Preview locally with `python3 -m http.server` and open http://localhost:8000.

## Hosting

The server serves a git clone of this repo from `/var/www/keithgdr.dev`.

1. Point `keithgdr.dev` and `www.keithgdr.dev` A records at the VPS (Cloudflare: DNS only / grey cloud, at least for the first certificate).
2. On the VPS, run `deploy/setup.sh <email>` once. It installs nginx, git and certbot, clones this repo, installs `deploy/nginx.conf` and gets the certificate.
3. After pushing changes, run `deploy/deploy.sh` locally to pull them onto the server.
