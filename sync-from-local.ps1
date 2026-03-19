param(
  [switch]$NoPull,
  [switch]$NoPush
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

if (!(Test-Path (Join-Path $repoRoot '.git'))) {
  throw 'This script must be run from within the git backup repo.'
}

$claudeRoot = Join-Path $env:USERPROFILE '.claude'
if (!(Test-Path $claudeRoot)) {
  throw "Local Claude directory not found: $claudeRoot"
}

$copilotConfig = Join-Path $env:USERPROFILE '.copilot\config.json'

if (-not $NoPull) {
  git pull --rebase --autostash origin main
}

foreach ($dir in @('skills','agents','commands')) {
  $src = Join-Path $claudeRoot $dir
  $dst = Join-Path $repoRoot $dir

  if (!(Test-Path $src)) {
    Write-Warning "Skipping missing directory: $src"
    continue
  }

  if (Test-Path $dst) {
    Remove-Item $dst -Recurse -Force
  }

  Copy-Item $src $dst -Recurse -Force
}

foreach ($file in @('CLAUDE.md','settings.json')) {
  $src = Join-Path $claudeRoot $file
  $dst = Join-Path $repoRoot $file

  if (Test-Path $src) {
    Copy-Item $src $dst -Force
  } elseif (Test-Path $dst) {
    Remove-Item $dst -Force
  }
}

$repoCopilotConfig = Join-Path $repoRoot 'copilot-config.json'
if (Test-Path $copilotConfig) {
  Copy-Item $copilotConfig $repoCopilotConfig -Force
} elseif (Test-Path $repoCopilotConfig) {
  Remove-Item $repoCopilotConfig -Force
}

# Basic token/secret guardrail before commit.
$patterns = @(
  'ghp_[A-Za-z0-9]{36}',
  'github_pat_[A-Za-z0-9_]{20,}',
  'gho_[A-Za-z0-9]{36}',
  'sk-[A-Za-z0-9]{20,}',
  'AKIA[0-9A-Z]{16}'
)

$scanTargets = @(
  (Join-Path $repoRoot 'skills'),
  (Join-Path $repoRoot 'agents'),
  (Join-Path $repoRoot 'commands'),
  (Join-Path $repoRoot 'CLAUDE.md'),
  (Join-Path $repoRoot 'settings.json'),
  (Join-Path $repoRoot 'copilot-config.json')
)

$hits = @()
foreach ($target in $scanTargets) {
  if (!(Test-Path $target)) { continue }

  if ((Get-Item $target).PSIsContainer) {
    $files = Get-ChildItem -Path $target -Recurse -File -Force
  } else {
    $files = @(Get-Item $target)
  }

  foreach ($f in $files) {
    foreach ($pattern in $patterns) {
      $m = Select-String -Path $f.FullName -Pattern $pattern -AllMatches -ErrorAction SilentlyContinue
      if ($m) { $hits += $m }
    }
  }
}

if ($hits.Count -gt 0) {
  Write-Error 'Potential secret detected in staged backup content. Commit aborted.'
  $hits | Select-Object -First 20 | ForEach-Object { "{0}:{1}" -f $_.Path, $_.LineNumber }
  exit 1
}

git add skills agents commands CLAUDE.md settings.json copilot-config.json README.md restore-to-local.ps1 sync-from-local.ps1 .gitignore

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Host 'No backup changes detected.'
  exit 0
}

$stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
git commit -m "backup: sync Claude skills agents and commands ($stamp)"

if (-not $NoPush) {
  git push origin main
}

Write-Host 'Backup sync complete.'
