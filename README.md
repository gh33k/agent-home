<div align="center">

# 🏠 agent-home

### Your home for agentic workflows.

**Put a whole herd of AI agents to work — researching, writing, automating, browsing, building —
on your laptop or an always-on server. One command sets it all up.**

[![license](https://img.shields.io/badge/license-MIT-6E56CF.svg)](LICENSE)
[![platform](https://img.shields.io/badge/platform-macOS%20·%20Linux-3FB950.svg)]()
[![install](https://img.shields.io/badge/install-no%20root%20needed-1F6FEB.svg)]()
[![shell](https://img.shields.io/badge/shell-bash-EAB308.svg)]()
[![secrets](https://img.shields.io/badge/secrets-bring%20your%20own-DB2777.svg)](SECURITY.md)

```bash
git clone https://github.com/gh33k/agent-home.git && cd agent-home && ./install.sh
```

</div>

---

## What is this?

**agent-home turns a clean machine into a place where AI agents do real, multi-step work for you** —
digging through sources, drafting and revising, driving a web browser, wrangling data, shipping code —
and lets you run **several at once** instead of babysitting one chat window.

It's not a coding tool. It's a *workspace for getting things done with agents*. It runs on your
laptop, or on an always-on server that keeps working while you sleep — and it's set up to be
**secure by default**, because agents that hold your credentials and act on their own need to be.

---

## ✨ The stack

A clean machine becomes a workspace where a *herd* of agents can actually get work done:

| | Tool | What it does for you |
|---|---|---|
| 🧠 | **[Claude Code](https://docs.claude.com/claude-code)** | a capable general-purpose agent — reasons, researches, writes, and builds |
| 🤖 | **[Codex](https://github.com/openai/codex)** | OpenAI's agent CLI — run it *alongside* Claude, pick the right one per task |
| 🌐 | **[agent-browser](https://www.npmjs.com/package/agent-browser)** | hands your agents a real web browser — research, fill forms, pull data, watch pages |
| 🐑 | **[Herdr](https://herdr.dev)** | the **multiplexer**: run & watch the whole herd from one terminal, any mix of agents, sessions that survive disconnects |
| 📿 | **[beads](https://github.com/gastownhall/beads) (`bd`)** | so your agents never lose the thread — tasks, dependencies & history, versioned next to your work |
| 🗃️ | **[dolt](https://github.com/dolthub/dolt)** | the versioned database beads runs on |
| 🔌 | **[cc-plugins](https://github.com/gh33k/cc-plugins) · `inbox`** | a workflow loop for ideas → plan → do → bank the lessons |
| 🧰 | **node · gh · jq** | the supporting toolchain |
| 📂 | **`~/projects`** | every piece of work in its own folder, with its own task db |

Everything installs **user-local via Homebrew — no root** — on **macOS and Linux**.
You bring your **own logins**. agent-home ships **zero secrets**.

---

## 🎯 What you can actually do

A few of the things a herd is good for — coding is just one of them:

- 🔎 **Research overnight** — point several agents at a question, let them read dozens of sources, come back to a cited summary.
- ✍️ **Draft & revise** — long-form writing, editing passes, turning notes into a finished piece.
- 🌐 **Web tasks** — agent-browser fills forms, scrapes data, monitors pages, checks prices.
- 🗂️ **Wrangle & organize** — sort files, reshape spreadsheets, reconcile data.
- 🛠️ **Build & ship** — Claude Code or Codex working directly on your repos.

…all tracked in **beads** and running side-by-side in one **Herdr** view — so you start a few,
detach, and check back later (from your laptop or your phone).

---

## 🚀 Quickstart

```bash
git clone https://github.com/gh33k/agent-home.git
cd agent-home
./install.sh
```

Installs the agents + toolchain, adds the plugin marketplace, creates `~/projects`, then runs a
short checklist to connect *your* accounts.

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
**agent-aware**, and **agent-agnostic** (Claude Code, Codex, whatever you add). It shows which
agents are working / blocked / done, keeps sessions alive when you disconnect, and lets you
re-attach over SSH from anywhere. **Start a herd, detach, check back from your phone.**

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

Agents read your secrets, run commands, and act on instructions that can come from **untrusted
content** (a web page, a file, another tool's output) — so assume an agent **can be tricked**, and
make that cheap. Running a herd multiplies the blast radius, so the security layer matters *more*,
not less.

**→ Full model in [`SECURITY.md`](SECURITY.md).** The short version:

- 🚫 **No secrets in this repo.** Your `claude` / `codex` / `gh` / `tailscale` logins stay in each tool's own keychain.
- 🕸️ **Off the network.** Tailscale-only, no public ports. Herdr is socket-only (no TCP); OpenBao binds localhost + TLS.
- 🎫 **Never hand an agent a root key.** Use OpenBao (or sops/age) → short-lived, `secret/agent/*`-scoped creds.
- 🧹 `scripts/scrub.sh` fails if anything secret-looking would publish — run it before sharing a fork.

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
