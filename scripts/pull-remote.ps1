# Pull from remote repository
# Run daily at 6:00 PM

$ErrorActionPreference = "Stop"
$RepoPath = "P:\Note\zettlr"
$LogFile = "$RepoPath\logs\pull-$(Get-Date -Format 'yyyy-MM-dd').log"

# Create logs directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "$RepoPath\logs" | Out-Null

# Start logging
Start-Transcript -Path $LogFile -Append

Write-Host "=== Starting pull from remote at $(Get-Date) ==="

try {
    Set-Location $RepoPath
    
    # Check if there are uncommitted changes
    $status = git status --porcelain
    if ($status) {
        Write-Host "Warning: Uncommitted changes detected. Stashing them..."
        git stash save "Auto-stash before pull at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
    
    # Pull from remote
    Write-Host "Pulling from remote..."
    git pull origin master
    
    Write-Host "=== Pull completed successfully at $(Get-Date) ==="
}
catch {
    Write-Host "Error during pull: $_"
    exit 1
}
finally {
    Stop-Transcript
}
