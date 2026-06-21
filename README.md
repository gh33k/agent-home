# agent-home

> Your home for agentic workflows — one command to set up the same workspace on a laptop or a server.

agent-home installs and wires together the tools an agentic workflow needs, so you (or a friend)
go from a clean machine to a working setup in minutes:

- **[beads](https://github.com/gastownhall/beads) (`bd`)** — a git-friendly task tracker with
  dependencies and history that lives next to your code
- **[dolt](https://github.com/dolthub/dolt)** — the versioned database beads runs on
- **[Claude Code](https://docs.claude.com/claude-code)** — the agent you drive your work with
- **node · gh · jq** — the supporting toolchain
- the **[cc-plugins](https://github.com/gh33k/cc-plugins)** marketplace + the **`inbox`** plugin
  (capture → brainstorm → plan → activate → complete → compound)
- the **`~/projects`** convention — every project in its own folder with its own beads db

Everything installs **user-local via Homebrew — no root required** — and works on **macOS and Linux**.
You bring your **own logins**; agent-home ships **no secrets**.

## Quickstart

```bash
git clone https://github.com/gh33k/agent-home.git
cd agent-home
./install.sh
```

The installer sets up the toolchain, adds the plugin marketplace, creates `~/projects`,
then runs a short checklist to connect *your* accounts.

Options:

```bash
./install.sh --no-onboard   # install everything, skip the login checklist
./install.sh --tools-only   # just the toolchain (no plugins/projects/onboarding)
```

## Laptop or server?

Same installer, either place:

| | Laptop / desktop | Server (VPS) |
|---|---|---|
| Setup | `./install.sh` on your Mac/Linux box | `./install.sh` on a rented Linux server |
| Agents run… | while your machine is awake | **24/7**, even when your laptop is closed |
| Reach it | locally | over SSH, ideally via [Tailscale](https://tailscale.com) (private, no open ports) |

A **VPS** (Virtual Private Server) is just a small Linux machine you rent in a data center.
If you want agents that keep working overnight, run agent-home on one and connect over Tailscale.

## Staying current

agent-home is versioned — pull the latest and re-run the installer (it's idempotent and skips
what's already there):

```bash
cd agent-home && git pull && ./install.sh
```

## Security

- **No secrets in this repo.** Your `claude`, `gh`, and `tailscale` logins live in each tool's
  own config/keychain on your machine — agent-home never reads or writes them.
- `.env` and `*.local.json` are git-ignored; `config/*.example.*` are templates only.
- Before sharing your own fork, run `scripts/scrub.sh` — it fails if anything secret-looking
  is about to be published.

## What's here

```
install.sh                      # the cross-platform installer
scripts/onboarding.sh           # bring-your-own-login checklist
scripts/scrub.sh                # pre-share secret scan
config/claude/                  # example Claude Code settings (no secrets)
config/projects/                # the ~/projects convention, explained
.env.example                    # optional overrides
```

## License

MIT © Per Simberg
