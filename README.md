<div align="center">

# 🏠 agent-home

### Your home for agentic workflows.

**One command. Laptop or server. The same battle-ready agent setup, everywhere.**

[![license](https://img.shields.io/badge/license-MIT-6E56CF.svg)](LICENSE)
[![platform](https://img.shields.io/badge/platform-macOS%20·%20Linux-3FB950.svg)]()
[![install](https://img.shields.io/badge/install-no%20root%20needed-1F6FEB.svg)]()
[![shell](https://img.shields.io/badge/shell-bash-EAB308.svg)]()
[![secrets](https://img.shields.io/badge/secrets-bring%20your%20own-DB2777.svg)](SECURITY.md)

```bash
git clone https://github.com/gh33k/agent-home.git && cd agent-home && ./install.sh
```

*From a clean machine to a working agentic workspace — in minutes.*

</div>

---

## ✨ What you get

A clean machine becomes a workspace where a *herd* of agents can actually get things done:

| | Tool | Why it's here |
|---|---|---|
| 🧠 | **[Claude Code](https://docs.claude.com/claude-code)** | the agent you drive your work with |
| 🐑 | **[Herdr](https://herdr.dev)** | run & monitor a whole **herd** of agents from one terminal — sessions survive disconnects, re-attach over SSH (even from your phone) |
| 📿 | **[beads](https://github.com/gastownhall/beads) (`bd`)** | git-friendly task tracking with dependencies & history, right next to your code |
| 🗃️ | **[dolt](https://github.com/dolthub/dolt)** | the versioned database beads runs on |
| 🔌 | **[cc-plugins](https://github.com/gh33k/cc-plugins) · `inbox`** | the compound-engineering loop: capture → brainstorm → plan → activate → complete → compound |
| 🧰 | **node · gh · jq** | the supporting toolchain |
| 📂 | **`~/projects`** | every project in its own folder, with its own beads db |

Everything installs **user-local via Homebrew — no root** — on **macOS and Linux**.
You bring your **own logins**. agent-home ships **zero secrets**.

---

## 🚀 Quickstart

```bash
git clone https://github.com/gh33k/agent-home.git
cd agent-home
./install.sh
```

Sets up the toolchain, adds the plugin marketplace, creates `~/projects`, then runs a short
checklist to connect *your* accounts.

<details>
<summary><b>Install options</b></summary>

```bash
./install.sh --no-onboard   # install everything, skip the login checklist
./install.sh --no-herdr     # skip the Herdr multiplexer
./install.sh --tools-only   # just the toolchain (no plugins / projects / onboarding)
```
</details>

---

## 💻 Laptop or 🖥️ server?

Same installer, either place:

| | 💻 Laptop / desktop | 🖥️ Server (VPS) |
|---|---|---|
| **Setup** | `./install.sh` on your Mac/Linux box | `./install.sh` on a rented Linux server |
| **Agents run…** | while your machine is awake | **24/7** — even when your laptop is closed |
| **Reach it** | locally | over SSH via [Tailscale](https://tailscale.com) — private, no open ports |

> 🌱 A **VPS** is just a small Linux machine you rent in a data center. Want agents that keep
> working overnight? Run agent-home on one and connect over Tailscale.

---

## 🐑 Running the herd

[Herdr](https://herdr.dev) is how you actually *run* agents here — think `tmux`, but
**agent-aware**. It shows which agents are working / blocked / done, keeps sessions alive
when you disconnect, and lets you re-attach over SSH from anywhere. On a server, this is what
makes "agents that work overnight" real: **start a herd, detach, check back from your phone.**

Driven by a local Unix socket and a JSON/CLI API — it scripts cleanly and stays **off the
network** (see [Security](#-security) for why that's the point).

---

## 🔄 Staying current

Versioned and idempotent — pull and re-run, it skips whatever's already there:

```bash
cd agent-home && git pull && ./install.sh
```

---

## 🔐 Security

Agents read secrets, run commands, and act on instructions that can come from **untrusted
content** — so assume an agent **can be tricked**, and make that cheap. Running a herd
multiplies the blast radius, so the security layer matters *more*, not less.

**→ Full model in [`SECURITY.md`](SECURITY.md).** The short version:

- 🚫 **No secrets in this repo.** Your `claude` / `gh` / `tailscale` logins stay in each tool's own keychain.
- 🕸️ **Off the network.** Tailscale-only, no public ports. Herdr is socket-only (no TCP); OpenBao binds localhost + TLS.
- 🎫 **Never hand an agent a root key.** Use OpenBao (or sops/age) → short-lived, `secret/agent/*`-scoped creds.
- 🧹 `scripts/scrub.sh` fails the build if anything secret-looking would publish — run it before sharing a fork.

---

## 🗂️ What's here

```
install.sh                # the cross-platform installer
SECURITY.md               # the agentic security model — read this
scripts/onboarding.sh     # bring-your-own-login checklist
scripts/scrub.sh          # pre-share secret scan
config/claude/            # example Claude Code settings (no secrets)
config/projects/          # the ~/projects convention, explained
.env.example              # optional overrides
```

---

<div align="center">

**MIT** © [Per Simberg](https://github.com/gh33k) · built for the herd 🐑

</div>
