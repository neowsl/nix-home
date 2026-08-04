# Homelab: minas-tirith

Manual / out-of-band setup notes for the homelab server `minas-tirith`.
Everything declarative lives in this repo (NixOS under `nixos/`, home-manager under
`modules/` + `hosts/`). This file only captures the **non-declarative** parts:
Cloudflare dashboard actions, credential files copied by hand, router config, and
one-time bootstrap steps.

---

## Architecture

```
laptops (rivendell, osgiliath) — Cloudflare Mesh clients (WARP)
   │  ssh neo@100.96.0.3  ── Mesh ──► Cloudflare Zero Trust (Access for Infrastructure)
   │     └─ Cloudflare SSH proxy issues short-lived cert → minas-tirith sshd :22
   │        (no SSH key or authorized_keys on either side)
   │     (at home only: ssh neo@192.168.1.12 via legacy WARP Infra Access)
   ▼
minas-tirith (server, 192.168.1.12, WiFi wlp0s20f0u4, NixOS) — Mesh node (Mesh IP 100.96.0.3)
   ├── sshd :22            (hardened, TrustedUserCAKeys = Cloudflare CA)
   ├── cloudflare-warp     (headless Mesh node, Traffic+DNS mode, owns :53)
   ├── cloudflared tunnel  876e057d-dd25-4e7a-89c8-f242719b4a6a
   │     git.nealwang.dev      → http://localhost:3001
   │     maelstrom.nealwang.dev → http://localhost:4000
   └── icewm via startx             (TV mode, no display manager)
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
| Server LAN IP | `192.168.1.12` (router DHCP reservation) |
| Mesh node IP | `100.96.0.3` (minas-tirith, Cloudflare Mesh) |
| Access-for-Infra target | hostname `minas-tirith` → IP `100.96.0.3`, port 22 |

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
5. **Mesh node** (Networking → Mesh): created a node for `minas-tirith`. On the
   server: `sudo warp-cli connector new <TOKEN> && sudo warp-cli connect` (token is
   shown once in the wizard but re-fetchable from the node detail page; the
   registration **survives reboots**). Declared via `services.cloudflare-warp`.
6. **Client split tunnels** (Zero Trust → Settings → WARP → Device profiles): the
   client profile runs in **Exclude mode** — **remove `100.64.0.0/10`** from the
   exclude list so Mesh IPs route through Cloudflare (see Gotchas).
7. **Access → Infrastructure**: added a **target** for the server
   (`minas-tirith` → `100.96.0.3`, port 22) and an SSH infrastructure application
   policy allowing the user as `neo`. Cloudflare's SSH proxy authenticates the WARP
   identity and presents a short-lived cert to sshd — **no SSH key or
   `authorized_keys` needed on either side**.

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

> The laptop files above are from the legacy Access/cloudflared flow — the WARP
> Infrastructure Access setup below needs none of them.

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
- **Do NOT follow the "short-lived certificates" link** — that's the CLI
  Infrastructure-Access flow (WARP + short-lived certs, see "Client-side SSH"
  above). For the browser terminal we keep using browser rendering + the account
  CA instead.
- Username on the server = email-prefix of the Access identity
  (`nealwang.sh@protonmail.com` → user `nealwang.sh`).
  - **TODO (pending):** `nealwang.sh` does not exist on the server yet
    (`getent passwd nealwang.sh` is empty). Create it — ideally declaratively in
    `nixos/hosts/minas-tirith.nix` via `users.users.nealwang.sh` — before the
    browser terminal can log in.

## Router (manual, external)

- **DHCP reservation**: server → `192.168.1.12` (static lease).
- **DNS**: Internet Setup → DNS → "Use These DNS Servers":
  primary `192.168.1.12`, secondary `1.1.1.1`.
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

## Forgejo Actions runner (`gimli`)

- Forgejo 15 uses the **UUID + secret connection model**: runners are pre-registered
  in the Forgejo UI ("Create new runner" dialog → UUID + secret) and connect via
  `/etc/forgejo-runner/config.yaml`. The deprecated `register --token` flow and the
  NixOS `services.gitea-actions-runner` module are **incompatible** (the module
  crash-loops with `registration token not found`). Forgejo 16 uses the same model —
  upgrading does not fix the module.
- The runner is a custom `systemd.services.forgejo-runner` (root, uses
  `pkgs.forgejo-runner`, `Restart = on-failure`), config declared in
  `nixos/hosts/minas-tirith.nix`.
- **Imperative config** (root:root `600`, never commit): `/etc/forgejo-runner/config.yaml`
  with the UUID + secret from the UI:
  ```yaml
  server:
    connections:
      forgejo:
        url: https://git.nealwang.dev
        uuid: <UUID-from-UI>
        token: <secret-from-UI>
  runner:
    labels:
      - mordor:docker://node:22-alpine
  ```
  Workflows run `runs-on: mordor`; runner display name is `gimli`.
- Deleting a runner in the admin UI orphans its UUID — delete and re-create from the
  UI, then update `config.yaml` and `systemctl restart forgejo-runner`.
- **Gotcha — cloudflared `Restart` conflict:** newer nixpkgs sets
  `Restart = "on-failure"` on the cloudflared tunnel service by default, colliding
  with the hardening override. Resolved with `Restart = lib.mkForce "always"` in
  `nixos/hosts/minas-tirith.nix` (keeps "never give up permanently" behavior).

## Verification

```sh
dig doubleclick.net @192.168.1.1      # 0.0.0.0  (router forwards to AdGuard)
dig +short adguard.nealwang.dev       # Cloudflare edge IPs
curl -sI https://adguard.nealwang.dev # 200
ssh minas-tirith hostname # minas-tirith  (direct via WARP Infra Access)
ssh minas-tirith 'sudo sshd -T | grep -i macs'
systemctl is-active cloudflared-tunnel-876e057d-dd25-4e7a-89c8-f242719b4a6a.service
systemctl status forgejo-runner        # runner gimli, label mordor
```

## Client-side SSH: Cloudflare Infrastructure Access via WARP (preferred)

The preferred SSH path to `minas-tirith` is **Cloudflare Infrastructure Access +
WARP** (enrolled device), not the legacy `cloudflared access ssh` proxy flow below.

```
laptop
  └─ ssh neo@192.168.1.12 ──(WARP tunnel)──► Cloudflare Zero Trust
     Infrastructure Access policy issues a short-lived SSH certificate
     ──► minas-tirith sshd :22  (TrustedUserCAKeys validates the Cloudflare CA)
     ──► neo shell
```

The client does **not** need:
- a static SSH key installed on the server,
- `ProxyCommand = cloudflared access ssh ...`,
- `~/.cloudflared/cert.pem`,
- per-device `authorized_keys` on `minas-tirith`.

The only client requirements: **WARP installed, enrolled in the right Zero Trust
org, connected**, and SSH pointed straight at the private target.

**WARP enrollment** (new device):
```sh
warp-cli registration new
warp-cli teams-enroll nealwang
warp-cli connect
warp-cli status        # Status: Connected / Organization: nealwang
```
The device must authenticate as an identity the Infrastructure Access policy allows.

**SSH config** — connect directly to the private address:
```nix
programs.ssh.settings = {
  "minas-tirith" = {
    HostName = "192.168.1.12";
    User = "neo";
  };
};
```
Do **not** add `ProxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h"` — that belongs to the separate Access → Applications → Self-hosted SSH flow. Likewise `/cdn-cgi/access/cli` tokens and `cloudflared access login/ssh` are from the browser/self-hosted flow and do **not** mean Infrastructure Access is working.

**Gotcha — WARP split tunnels:** if the target IP is excluded from the tunnel
(e.g. `192.168.0.0/16` in Exclude mode), traffic goes straight to the LAN and
bypasses Infrastructure Access. Symptoms: `ping` works, sshd answers, but
`ssh -vvv` only shows `Offering public key: ~/.ssh/id_ed25519` (no short-lived
cert). Fix: remove the exclusion from the Zero Trust device profile, then
`warp-cli disconnect` / `warp-cli connect`; verify with `ip route get 192.168.1.12`.

**Debugging checklist** (SSH fails):
1. `warp-cli status` → `Status: Connected`.
2. `warp-cli settings` → no `192.168.0.0/16` exclusion.
3. `ssh -vvv minas-tirith` → should offer a cert (`Offering ED25519-CERT public key`
   / `...-cert.pub`); if only `id_ed25519` appears, the connection is not going
   through Infrastructure Access.
4. On the server: `sudo sshd -T | grep trustedusercakeys` → `trustedusercakeys /etc/ssh/cloudflare-ca.pub`.

**Host key changes:** switching between direct LAN, Infrastructure Access, and
tunnel-based SSH can trigger a host-key warning. If the fingerprint is verified,
remove the stale entry and reconnect: `ssh-keygen -R 192.168.1.12`.

## Legacy: client-side via cloudflared Access SSH ProxyCommand (rivendell / osgiliath)

> **Legacy flow** — superseded by the Infrastructure Access + WARP setup above.
> This documents the older path: clients install `cloudflared`, run
> `cloudflared access login`, and route SSH through
> `ProxyCommand = ... cloudflared access ssh --hostname %h`, with per-device
> keys authorized on the server. The declarative config has since moved to the
> direct `minas-tirith` → `192.168.1.12` block (see above).

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
