#!/usr/bin/env bash
#
# onboarding — connect YOUR own accounts to the freshly installed workspace.
# Nothing here is stored in the agent-home repo; each login lives in that tool's
# own config/keychain on your machine.
#
set -euo pipefail

title(){ printf '\n\033[1m%s\033[0m\n' "$*"; }
have(){ command -v "$1" >/dev/null 2>&1; }

title "Log in with your own accounts"

# 1) Claude Code
title "1) Claude Code"
if have claude; then
  echo "   Run 'claude' and follow the login prompt (browser or API key)."
else
  echo "   claude isn't on PATH yet — open a new shell, then run 'claude'."
fi

# 2) GitHub CLI
title "2) GitHub CLI"
if have gh; then
  if gh auth status >/dev/null 2>&1; then
    echo "   ✓ already authenticated as $(gh api user -q .login 2>/dev/null || echo 'you')"
  else
    read -r -p "   Log in to GitHub now? [y/N] " yn
    if [ "${yn:-N}" = y ] || [ "${yn:-N}" = Y ]; then
      gh auth login || echo "   skipped — run 'gh auth login' anytime"
    else
      echo "   skipped — run 'gh auth login' anytime"
    fi
  fi
else
  echo "   gh isn't on PATH yet — open a new shell, then run 'gh auth login'."
fi

# 3) Tailscale (optional)
title "3) Tailscale  (optional — reach an always-on server privately)"
if have tailscale; then
  echo "   Run 'tailscale up' to join your tailnet."
else
  echo "   Not installed. Want it? https://tailscale.com/download , then 'tailscale up'."
fi

title "You're set."
echo "Reminder: agent-home stores no secrets — your logins live in each tool's own config."
