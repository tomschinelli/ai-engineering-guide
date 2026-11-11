# vm-runner: Claude Code in a throwaway VM

Ansible creates a fresh VM that can reach the **public internet only** (not your host, LAN, VPN or Docker).
Inside it, Ansible clones your private repo, injects a plan or GitHub issue, runs Claude Code headless,
pushes a branch, opens a **draft PR**, and destroys the VM.

Why and how it works: [VM sandbox](../../practices/vm-sandbox.md).

## Files

| Path | Role |
|---|---|
| `run.yml` | The playbook: create VM → run → teardown |
| `down.yml` | Remove a VM that was kept (`-e keep=true`) or left behind after Ctrl-C |
| `vars.yml` | Repo, VM size, subnet, limits. **No secrets.** |
| `tasks/host-up.yml`, `host-down.yml` | Firewall, network, disk, cloud-init seed, `virt-install`, teardown |
| `tasks/vm-setup.yml`, `vm-run.yml`, `vm-fetch-logs.yml` | Inside the VM: tools, clone, Claude run, push + PR, logs |
| `templates/agent-sandbox.nft.j2` | nftables table: VM → host and VM → private ranges are dropped |
| `templates/agent-net.xml.j2` | libvirt NAT network without DHCP, DNS or IPv6 |
| `templates/user-data.j2`, `meta-data.j2`, `network-config.j2` | cloud-init: `ops` login for Ansible, static IP, public DNS |
| `templates/agent.sh.j2` | Round loop inside the VM (`claude -p`, stop conditions) |
| `prompts/*.md.j2` | Prompts for plan, issue and AFK mode (Go feedback loops) |

## Quick start

```bash
cp -r templates/vm-runner ~/repos/shorty/tools/vm-runner   # once
cd ~/repos/shorty && $EDITOR tools/vm-runner/vars.yml       # repo, subnet

CLAUDE_CODE_OAUTH_TOKEN="$(pass show claude/oauth-token)" \
GH_TOKEN="$(pass show github/shorty-agent)" \
  ansible-playbook tools/vm-runner/run.yml -K -e plan=.scratch/plans/add-expiry.md
```

| Option | Effect |
|---|---|
| `-e plan=PATH` | Implement a local plan file |
| `-e issue=42` | Implement one issue. Refused unless the token owner wrote it. |
| `-e afk=5` | Up to 5 rounds over open `afk` issues written by you, one per round |
| `-e keep=true` | Keep the VM. SSH command and `down.yml` command are printed at the end. |

Logs (stream-json per round, agent notes) land in `.scratch/vm-runs/<run_id>/`. One run at a time.
