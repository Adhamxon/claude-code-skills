# Claude Code Skills Setup Script (PowerShell)
# Copies .claude/ directory to the current project
#
# Usage:
#   powershell -File setup.ps1              # Copy to current directory
#   powershell -File setup.ps1 -Path C:\project  # Copy to specific project

param(
  [string]$Path = (Get-Location).Path
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $scriptDir "..\.claude"
$target = Join-Path $Path ".claude"

if (-not (Test-Path $Path)) {
  Write-Error "Target directory '$Path' does not exist."
  exit 1
}

if (Test-Path $target) {
  $confirm = Read-Host "Warning: $target already exists. Overwrite? (y/N)"
  if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Aborted."
    exit 0
  }
}

Copy-Item -Path $source -Destination $target -Recurse -Force
Write-Host "✓ Copied .claude/ to $target"
Write-Host "✓ Claude Code skills are ready to use."
Write-Host ""
Write-Host "Start Claude Code in your project:"
Write-Host "  cd $Path"
Write-Host "  claude"
