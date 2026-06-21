# Security model

agent-home runs **autonomous agents** — programs that read secrets, run shell commands,
and act on instructions that can arrive from untrusted content (web pages, files, tool
output). The correct assumption is that an agent **can be tricked**, so the goal is to
make a tricked agent *cheap*: short-lived scoped credentials, least privilege, and an
audit trail.

The laptop path can be lighter. The **server profile** (`--profile server`, planned) is
where the stronger controls get set up, because an always-on box running unattended
agents is the higher-stakes case.

## Threat model

1. **Prompt injection** — an agent is fed a malicious instruction and tries to read and
   exfiltrate your credentials.
2. **Escalation / lateral movement** — a compromised dependency or tool call tries to
   gain privileges or roam the host.
3. **Scale** — you run *many* agents at once (see [Herdr](#herdr-the-agent-multiplexer)),
   so any single compromise has a larger blast radius.

## Controls

### Secrets — never hand an agent a root key
- Keep secrets in **OpenBao** (or **sops + age** for a lighter, daemon-free setup),
  encrypted at rest.
- Agents authenticate with a **short-lived token** (AppRole) scoped to
  **`secret/agent/*` read-only** — never `secret/admin/*`, never the root token.
- Prefer **dynamic credentials** (e.g. per-session database creds) that auto-expire, so a
  leaked credential is both limited and short-lived.
- Inject secrets into the agent's environment at runtime; don't write them to disk.

### Least privilege
- Run agents as a **dedicated non-root user**, no `sudo`, home perms `700`.
- Optionally sandbox each agent (systemd hardening / bubblewrap / container) so a bad
  tool call can't roam the box.

### Network
- **Tailscale-only**; firewall **default-deny inbound**. No public ports.
- Bind local services to **localhost or a Unix socket**, never `0.0.0.0`
  (OpenBao → localhost + TLS; Herdr → Unix socket).
- Consider an **egress allowlist** for the agent user — the single strongest lever
  against an agent POSTing your keys to an attacker.

### Audit
- Enable an OpenBao **audit device** so every secret read is logged: if something leaks,
  you know exactly what was accessed and when.

### Host
- SSH **key-only**, no root login, automatic security updates, full-disk encryption.

### Supply chain
- Pin tool versions and verify checksums where possible.
- Review any `curl | sh` installer before piping it to a shell — including Herdr's,
  Claude Code's, and Homebrew's.

## Herdr (the agent multiplexer)

agent-home uses **[Herdr](https://herdr.dev)** ([`ogulcancelik/herdr`](https://github.com/ogulcancelik/herdr))
to run and monitor a herd of agents from one terminal. There are two sides to its
security.

**Safe by default — keep it that way**
- Herdr is driven by a **Unix domain socket** (`~/.config/herdr/*.sock`, perms `0600`,
  owner-only). It **opens no TCP port** — verified: it does not listen on the network.
- **Remote attach is over SSH**, not an exposed port. With Tailscale + SSH keys, only you
  can reach it.
- Do **not** proxy the socket to a network port, and do **not** expose the box outside
  your tailnet. The moment the control socket is reachable from the network, anyone who
  reaches it can drive your agents.

**Why the security layer matters *more* with a multiplexer**
- Herdr makes it trivial to run **many agents simultaneously**, and convenience modes —
  `claude --dangerously-skip-permissions`, `codex --dangerously-bypass-approvals-and-sandbox`
  ("YOLO") — remove the agent's own guardrails. A herd of permission-skipping agents has a
  large, parallel blast radius.
- If you use YOLO modes, run them **inside** the controls above: a dedicated
  least-privilege user, OpenBao short-lived/scoped creds (so a leaked credential is limited
  and expires), and ideally an egress allowlist. The multiplexer does not reduce risk — the
  **secrets + isolation layer is what keeps a tricked agent contained**.

## Reporting

Found a security issue in agent-home itself? Open an issue on the repository — and please
do not include any secrets in the report.
