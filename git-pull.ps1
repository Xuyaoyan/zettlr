# Git Pull Script
# Pulls changes from remote repository

$RepoPath = "P:\Note\zettlr"
$LogDir = Join-Path $RepoPath "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$LogFile = Join-Path $LogDir "pull-$(Get-Date -Format 'yyyy-MM-dd').log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Add-Content -Path $LogFile -Value $logMessage
}

Write-Log "=== Starting pull from remote ==="

try {
    Set-Location $RepoPath
    
    # Check for uncommitted changes
    $status = git status --porcelain 2>&1
    if ($status) {
        Write-Log "Uncommitted changes detected, stashing..."
        git stash save "Auto-stash before pull at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>&1 | Out-String | Write-Log
    }
    
    # Pull from remote
    Write-Log "Pulling from origin/master..."
    $output = git pull origin master 2>&1 | Out-String
    Write-Log $output
    
    Write-Log "=== Pull completed successfully ==="
}
catch {
    Write-Log "ERROR: $_"
    exit 1
}
