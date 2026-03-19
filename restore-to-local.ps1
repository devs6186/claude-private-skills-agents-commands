$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $env:USERPROFILE '.claude'
if (!(Test-Path $target)) { New-Item -ItemType Directory -Path $target | Out-Null }

foreach ($dir in @('skills','agents','commands')) {
  $src = Join-Path $repoRoot $dir
  if (Test-Path $src) {
    $dst = Join-Path $target $dir
    if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
    Copy-Item $src $dst -Recurse -Force
  }
}

foreach ($file in @('CLAUDE.md','settings.json')) {
  $src = Join-Path $repoRoot $file
  if (Test-Path $src) { Copy-Item $src (Join-Path $target $file) -Force }
}

Write-Host 'Restore complete to' $target
