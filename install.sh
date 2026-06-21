#!/usr/bin/env bash
#
# agent-home — set up your agentic workspace on macOS or Linux.
#
# Installs (via Homebrew — no root needed, works on both platforms):
#   beads (bd) · dolt · node · gh · jq · Claude Code
# Wires in the cc-plugins marketplace (inbox plugin) and the ~/projects layout.
#
# You bring your OWN logins (claude / gh / tailscale). No secrets ship in this repo.
#
set -euo pipefail

AGENT_HOME_VERSION="0.1.0"
CC_PLUGINS="${AGENT_HOME_CC_PLUGINS:-gh33k/cc-plugins}"
BEADS_TAP="${AGENT_HOME_BEADS_TAP:-gastownhall/beads}"
PROJECTS_DIR="${AGENT_HOME_PROJECTS:-$HOME/projects}"

ONBOARD=1; TOOLS_ONLY=0; NO_HERDR=0
for a in "$@"; do case "$a" in
  --no-onboard) ONBOARD=0 ;;
  --no-herdr)   NO_HERDR=1 ;;
  --tools-only) TOOLS_ONLY=1; ONBOARD=0 ;;
  -h|--help)
    cat <<'USAGE'
agent-home installer
  ./install.sh               install missing tools, then run the login checklist
  ./install.sh --no-onboard  install everything but skip the login checklist
  ./install.sh --no-herdr    skip installing Herdr (the agent multiplexer)
  ./install.sh --tools-only  toolchain only (no plugins / projects / onboarding)
USAGE
    exit 0 ;;
  *) echo "unknown option: $a" >&2; exit 1 ;;
esac; done

bold(){ printf '\033[1m%s\033[0m\n' "$*"; }
ok(){   printf '  \033[32m✓\033[0m %s\n' "$*"; }
step(){ printf '  \033[34m•\033[0m %s\n' "$*"; }
warn(){ printf '  \033[33m!\033[0m %s\n' "$*"; }
die(){  printf '  \033[31m✗ %s\033[0m\n' "$*" >&2; exit 1; }
have(){ command -v "$1" >/dev/null 2>&1; }

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *) die "unsupported OS: $(uname -s) — macOS and Linux only" ;;
esac

bold "agent-home v$AGENT_HOME_VERSION — installing on $OS"

# 1) Homebrew (supported on macOS and Linux; installs user-local, no root)
ensure_brew(){
  if have brew; then ok "Homebrew present"; return; fi
  step "installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  local brew=""
  for p in /opt/homebrew/bin/brew /usr/local/bin/brew \
           /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
    [ -x "$p" ] && { brew="$p"; break; }
  done
  [ -n "$brew" ] || die "Homebrew installed but 'brew' not found on expected paths"
  eval "$("$brew" shellenv)"
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    grep -qF 'brew shellenv' "$rc" || echo "eval \"\$($brew shellenv)\"" >> "$rc"
  done
  ok "Homebrew installed"
}

# 2) toolchain
install_tools(){
  step "tapping $BEADS_TAP"
  brew tap "$BEADS_TAP" >/dev/null 2>&1 || warn "could not tap $BEADS_TAP (continuing)"
  for f in beads dolt node gh jq; do
    local bin="$f"; [ "$f" = beads ] && bin="bd"
    if have "$bin"; then ok "$f present"; continue; fi
    step "brew install $f"
    brew install "$f" >/dev/null 2>&1 && ok "$f installed" || warn "brew install $f failed"
  done
}

# 3) Claude Code (official native installer, user-local under ~/.local)
install_claude(){
  if have claude; then ok "Claude Code present ($(claude --version 2>/dev/null | head -1))"; return; fi
  step "installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash \
    && ok "Claude Code installed" \
    || warn "Claude Code install failed — see https://docs.claude.com/claude-code"
}

# 4) Herdr — the agent multiplexer (run/monitor a herd of agents)
install_herdr(){
  if [ "$NO_HERDR" -eq 1 ]; then return; fi
  if have herdr; then ok "Herdr present ($(herdr --version 2>/dev/null | head -1))"; return; fi
  step "installing Herdr (agent multiplexer)"
  curl -fsSL https://herdr.dev/install.sh | sh \
    && ok "Herdr installed" \
    || warn "Herdr install failed — see https://herdr.dev"
}

# 5) cc-plugins marketplace + inbox plugin
install_plugins(){
  if ! have claude; then
    warn "claude not on PATH yet — skipping plugins. After restarting your shell, run:"
    warn "  claude plugin marketplace add $CC_PLUGINS && claude plugin install inbox@cc-plugins"
    return
  fi
  step "adding marketplace $CC_PLUGINS"
  claude plugin marketplace add "$CC_PLUGINS" >/dev/null 2>&1 \
    && ok "marketplace added" \
    || warn "add later: claude plugin marketplace add $CC_PLUGINS"
  claude plugin install inbox@cc-plugins >/dev/null 2>&1 \
    && ok "inbox plugin installed" \
    || warn "install later: claude plugin install inbox@cc-plugins"
}

# 6) ~/projects convention
setup_projects(){
  mkdir -p "$PROJECTS_DIR"
  ok "projects dir ready: $PROJECTS_DIR"
}

ensure_brew
install_tools
install_claude
install_herdr
if [ "$TOOLS_ONLY" -eq 0 ]; then
  install_plugins
  setup_projects
fi

if [ "$ONBOARD" -eq 1 ]; then
  here="$(cd "$(dirname "$0")" && pwd)"
  if [ -x "$here/scripts/onboarding.sh" ]; then
    "$here/scripts/onboarding.sh" || true
  fi
fi

bold ""
ok "agent-home setup complete."
echo "  Open a new shell (or 'source' your rc) so PATH changes take effect."
