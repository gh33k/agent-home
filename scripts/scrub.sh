#!/usr/bin/env bash
#
# scrub — make sure no secrets are about to be shared.
# Run before pushing or publishing. Exits non-zero if anything looks sensitive.
#
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"

fail=0
bad(){ printf '  \033[31m✗ %s\033[0m\n' "$*"; fail=1; }
ok(){  printf '  \033[32m✓\033[0m %s\n' "$*"; }

echo "scrub: scanning tracked files for secrets…"

# 1) sensitive files that must never be tracked
for f in .env .env.local .env.production .npmrc id_rsa id_ed25519 \
         settings.local.json .claude/settings.local.json; do
  if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
    bad "sensitive file is tracked: $f"
  fi
done

# 2) credential-looking strings in tracked text (skip examples + this script)
patterns='sk-ant-|ghp_|github_pat_|gho_|AKIA[0-9A-Z]{16}|xox[baprs]-|-----BEGIN [A-Z ]*PRIVATE KEY-----'
if git grep -nIE "$patterns" -- . ':!*.example' ':!*.example.*' ':!scripts/scrub.sh' >/dev/null 2>&1; then
  bad "credential-looking strings found:"
  git grep -nIE "$patterns" -- . ':!*.example' ':!*.example.*' ':!scripts/scrub.sh' | sed 's/^/      /'
fi

# 3) .env must be ignored
if ! grep -qE '(^|/)\.env(\b|$)' .gitignore 2>/dev/null; then
  bad ".env is not covered by .gitignore"
fi

echo
if [ "$fail" -eq 0 ]; then
  ok "clean — safe to share"
else
  echo "scrub FAILED — fix the above before sharing."
  exit 1
fi
