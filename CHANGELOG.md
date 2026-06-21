# Changelog

All notable changes to agent-home are documented here. Versions follow
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Cross-platform `install.sh` (Homebrew-based; macOS + Linux, no root):
  installs beads (`bd`), dolt, node, gh, jq, **Claude Code**, **Codex**, **agent-browser**,
  and **Herdr** (the agent multiplexer; `--no-herdr` to skip).
- README reframed around **agentic workflows in general** (research, writing, web
  automation, data, building) — not just coding — with a plain "what is this" intro and a
  "what you can actually do" section.
- **`SECURITY.md`** — the agentic security model (secrets via OpenBao/sops, least
  privilege, network isolation, audit) with a Herdr-specific section.
- `scripts/onboarding.sh` — bring-your-own-login checklist (claude / gh / tailscale).
- `scripts/scrub.sh` — pre-share scan that fails if secrets are about to be published.
- cc-plugins marketplace + `inbox` plugin wiring.
- `~/projects` convention with per-project beads (see `config/projects/README.md`).
- Example config templates (`.env.example`, `config/claude/settings.example.json`).
