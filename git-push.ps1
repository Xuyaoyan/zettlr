# Git Push Script
# Commits and pushes local changes to remote repository

$RepoPath = "P:\Note\zettlr"
$LogDir = Join-Path $RepoPath "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$LogFile = Join-Path $LogDir "push-$(Get-Date -Format 'yyyy-MM-dd').log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Add-Content -Path $LogFile -Value $logMessage
}

Write-Log "=== Starting commit and push ==="

try {
    Set-Location $RepoPath
    
    # Check for changes
    $status = git status --porcelain 2>&1
    if (-not $status) {
        Write-Log "No changes to commit"
        Write-Log "=== Nothing to push ==="
        exit 0
    }
    
    Write-Log "Changes detected, adding all files..."
    git add -A 2>&1 | Out-String | Write-Log
    
    # Commit with timestamp
    $commitMessage = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Log "Committing: $commitMessage"
    git commit -m $commitMessage 2>&1 | Out-String | Write-Log
    
    # Push to remote
    Write-Log "Pushing to origin/master..."
    $output = git push origin master 2>&1 | Out-String
    Write-Log $output
    
    Write-Log "=== Push completed successfully ==="
}
catch {
    Write-Log "ERROR: $_"
    exit 1
}
