# Homelab: minas-tirith

Manual / out-of-band setup notes for the homelab server `minas-tirith`.
Everything declarative lives in this repo (NixOS under `nixos/`, home-manager under
`modules/` + `hosts/`). This file only captures the **non-declarative** parts:
Cloudflare dashboard actions, credential files copied by hand, router config, and
one-time bootstrap steps.

---

## Architecture

```
laptops (rivendell, osgiliath)
   │  ssh minas-tirith.nealwang.dev  ── cloudflared access ssh (tunnel proxy)
   ▼
minas-tirith (server, 192.168.1.9, WiFi wlp0s20f0u4, NixOS)
   ├── sshd :22            (hardened, TrustedUserCAKeys = Cloudflare CA)
   ├── cloudflared tunnel  876e057d-dd25-4e7a-89c8-f242719b4a6a
   │     minas-tirith.nealwang.dev → ssh://localhost:22
   │     adguard.nealwang.dev      → http://localhost:3000
   ├── AdGuard Home :53/:3000      (Quad9 + Cloudflare DoH upstreams)
   └── icewm via startx             (TV mode, no display manager)
LAN clients
   └── router DHCP → DNS 192.168.1.9 (AdGuard) → LAN-wide ad-blocking
```

## Key identifiers

| Thing | Value |
|---|---|
| Cloudflare zone | `nealwang.dev` (Free plan) |
| Tunnel UUID | `876e057d-dd25-4e7a-89c8-f242719b4a6a` |
| CNAME target | `876e057d-dd25-4e7a-89c8-f242719b4a6a.cfargotunnel.com` |
| Zero Trust org | `icy-feather-00e9.cloudflareaccess.com` |
| Access app (SSH) | self-hosted app for `minas-tirith.nealwang.dev`, aud `9ec096866dd8cd1eb67b665daf305ab475e4dc5bbd563f3e4b1fec39c7fc72af` |
| SSH CA principal | `open-ssh-ca@cloudflareaccess.org` |
| Server LAN IP | `192.168.1.9` (router DHCP reservation) |

## Cloudflare dashboard actions (manual, one-time)

1. **DNS records** (zone `nealwang.dev`) — two CNAMEs to the tunnel target:
   - `minas-tirith.nealwang.dev` → `876e057d-....cfargotunnel.com` (proxied)
   - `adguard.nealwang.dev`      → `876e057d-....cfargotunnel.com` (proxied)
   - Use **single-level** hostnames only: Universal SSL covers `*.nealwang.dev`
     (one level). `adguard.minas-tirith.nealwang.dev` fails TLS for this reason.
2. **Tunnel** — locally-managed (NOT the dashboard wizard). Created from a machine
   that holds the account cert (`cloudflared tunnel login` → `~/.cloudflared/cert.pem`).
3. **Zero Trust → Settings → Service credentials → SSH**: created the account-level
   SSH CA. Public key (copied to server):
   ```
   ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJJmY9+hnOkIluq4jT65UEHx8y1bGYdpbxiMnj/6BTAhVtfDAxUBR+LHwAcpGjXHBqpAvx4oSeFApkr2dkzk/JE= open-ssh-ca@cloudflareaccess.org
   ```
4. **Access → Applications**: self-hosted app, type SSH, hostname
   `minas-tirith.nealwang.dev` (aud above). This powers the browser terminal and
   `cloudflared access ssh`.

## Credential files (imperative, not in the repo)

**On the server** (root-owned, never commit these):
- `/etc/cloudflared/876e057d-dd25-4e7a-89c8-f242719b4a6a.json` — tunnel credential
  JSON (`r--------`, root). Declarative config points at it via
  `services.cloudflared.tunnels."<uuid>".credentialsFile`.
- `/etc/ssh/cloudflare-ca.pub` — the CA public key above (content in section above).

**On the laptop** `~/.cloudflared/`:
- `icy-feather-00e9.cloudflareaccess.com-org-token` — from `cloudflared access login`.
- `minas-tirith.nealwang.dev-<hash>-token` + `.url` — per-app token fetched by
  `cloudflared access ssh` (url = `/cdn-cgi/access/cli?aud=9ec09686...`).
- `cert.pem` — account cert from `cloudflared tunnel login` (only on the machine
  that manages the tunnel; currently NOT on the laptop).

## Server bootstrap (imperative)

1. Copy tunnel JSON + CA pub onto the server:
   ```
   sudo mkdir -p /etc/cloudflared
   sudo install -o root -g root -m 600 <uuid>.json /etc/cloudflared/<uuid>.json
   sudo install -o root -g root -m 644 cloudflare-ca.pub /etc/ssh/cloudflare-ca.pub
   ```
2. Authorize laptop key for `neo` (via console/first boot):
   append `~/.ssh/id_ed25519.pub` to `/home/neo/.ssh/authorized_keys`.
3. Rebuild from the repo's `nixos/` subtree (the server needs its own copy of the
   flake): `sudo nixos-rebuild switch --flake .#minas-tirith`.

## Browser SSH (Access portal)

- Open `https://minas-tirith.nealwang.dev` → browser-based SSH terminal.
- At the auth screen, **paste your SSH public key** (`cat ~/.ssh/id_ed25519.pub`).
  Cloudflare never sees the private key.
- **Do NOT follow the "short-lived certificates" link** — that's Access-for-
  Infrastructure (WARP client on every device); we're using browser rendering +
  the account CA instead.
- Username on the server = email-prefix of the Access identity
  (`nealwang.sh@protonmail.com` → user `nealwang.sh`).
  - **TODO (pending):** `nealwang.sh` does not exist on the server yet
    (`getent passwd nealwang.sh` is empty). Create it — ideally declaratively in
    `nixos/hosts/minas-tirith.nix` via `users.users.nealwang.sh` — before the
    browser terminal can log in.

## Router (manual, external)

- **DHCP reservation**: server → `192.168.1.9` (static lease).
- **DNS**: Internet Setup → DNS → "Use These DNS Servers":
  primary `192.168.1.9`, secondary `1.1.1.1`.
  The router forwards all client queries to AdGuard, so filtering works LAN-wide.
- YouTube ads cannot be blocked via DNS (same domains as the content) — use
  YouTube Premium or a content blocker.

## Gotchas (learned the hard way)

- NixOS sshd module generates `Macs`/`Ciphers`/`KexAlgorithms` with **capitalized
  keys and comma-joined lists**. Set them capitalized and as a **list**; lowercase
  `macs` triggers a type error, and a list+lowercase combo collides with the default
  `Macs` → `Duplicate sshd config key` assertion.
- Browser SSH needs the **plain** `hmac-sha2-512,hmac-sha2-256` MACs appended to the
  hardened defaults (which only ship the `-etm` variants), else the handshake fails
  with `no matching MAC found`.
- `1033` from the tunnel = hostname not bound to a tunnel (missing/mistyped CNAME).
- `Bad handshake` right after a server reboot = tunnel reconnect window; wait.
- AdGuard dashboard is tunnel-only (no port 3000 in the firewall).

## Verification

```sh
dig doubleclick.net @192.168.1.1      # 0.0.0.0  (router forwards to AdGuard)
dig +short adguard.nealwang.dev       # Cloudflare edge IPs
curl -sI https://adguard.nealwang.dev # 200
ssh minas-tirith.nealwang.dev hostname # minas-tirith  (plain ssh via managed config)
ssh neo@minas-tirith.nealwang.dev 'sudo sshd -T | grep -i macs'
systemctl is-active cloudflared-tunnel-876e057d-dd25-4e7a-89c8-f242719b4a6a.service
```

## Client-side (rivendell / osgiliath)

- Declarative in home-manager: `modules/desktop.nix` (rivendell) and
  `modules/wsl.nix` (osgiliath) install `cloudflared` and manage `~/.ssh/config`
  via `programs.ssh.matchBlocks` (`attu`, `minas-tirith.nealwang.dev` proxyCommand).
- Apply with `home-manager switch --flake .#rivendell` (hostname matches, so the
  bare command picks the right configuration).
- Laptop keypair `~/.ssh/id_ed25519` (key exists; pubkey is authorized for `neo`).
- `attu` in the ssh config is the UW CSE box — unrelated to the homelab.

## Known repo gap

The deployed server currently runs the `Macs` fix (see Gotchas), but
`nixos/hosts/minas-tirith.nix` does **not** declare it yet. Add to
`services.openssh.settings` and rebuild to make the repo reproduce the server:
```nix
Macs = [
  "hmac-sha2-512-etm@openssh.com"
  "hmac-sha2-256-etm@openssh.com"
  "umac-128-etm@openssh.com"
  "hmac-sha2-512"
  "hmac-sha2-256"
];
```
