# Claude private sync (skills/agents/commands)

This repo stores portable Claude setup content:
- `skills/`
- `agents/`
- `commands/`
- `CLAUDE.md`
- `settings.json` (safe, non-account-specific)
- `copilot-config.json`

## One-command sync from this device to GitHub

Run this whenever you change your local Claude setup and want to back it up:

```powershell
./sync-from-local.ps1
```

What it does:
- `git pull --rebase`
- copies local `C:\Users\<you>\.claude\{skills,agents,commands}` into this repo
- copies `CLAUDE.md`, `settings.json`, and `.copilot\config.json`
- runs a basic token/secret pattern scan
- commits only if content changed
- pushes to `origin/main`

Optional flags:

```powershell
./sync-from-local.ps1 -NoPull
./sync-from-local.ps1 -NoPush
```

## Restore on another device (PowerShell)

```powershell
git pull --rebase origin main
./restore-to-local.ps1
```
