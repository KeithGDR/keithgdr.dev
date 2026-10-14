# keithgdr.dev

My personal website which lets people find me. Plain HTML and CSS, served by Caddy on my VPS with a LetsEncrypt certificate.

## Editing

- Bio and links live in `index.html` (look for the comments).
- Colors live at the top of `style.css`.
- Images come from `Personal Branding/` and are converted to small `.webp` files in `img/`.

Preview locally with `python3 -m http.server` and open http://localhost:8000.

## Hosting

The VPS (`keithgdr-host`) serves a git clone of this repo from `/var/www/keithgdr.dev` with Caddy, which also handles the LetsEncrypt certificates. Caddy's main config comes from the Kdex repo and imports `/etc/caddy/sites/*.caddy`; this site's part is `deploy/keithgdr.dev.caddy`.

- DNS: `keithgdr.dev` and `www.keithgdr.dev` A/AAAA records point at the VPS (Cloudflare, DNS only / grey cloud).
- First time on a new server: run `deploy/setup.sh` there.
- After pushing changes: run `deploy/deploy.sh` locally to pull them onto the server.
