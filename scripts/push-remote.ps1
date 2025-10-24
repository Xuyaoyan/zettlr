# Commit and push to remote repository
# Run daily at 6:00 AM

$ErrorActionPreference = "Stop"
$RepoPath = "P:\Note\zettlr"
$LogFile = "$RepoPath\logs\push-$(Get-Date -Format 'yyyy-MM-dd').log"

# Create logs directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "$RepoPath\logs" | Out-Null

# Start logging
Start-Transcript -Path $LogFile -Append

Write-Host "=== Starting commit and push at $(Get-Date) ==="

try {
    Set-Location $RepoPath
    
    # Check if there are changes to commit
    $status = git status --porcelain
    if (-not $status) {
        Write-Host "No changes to commit."
        Write-Host "=== Nothing to push at $(Get-Date) ==="
        exit 0
    }
    
    Write-Host "Changes detected:"
    git status --short
    
    # Add all changes
    Write-Host "Adding all changes..."
    git add -A
    
    # Commit with timestamp
    $commitMessage = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "Committing with message: $commitMessage"
    git commit -m $commitMessage
    
    # Push to remote
    Write-Host "Pushing to remote..."
    git push origin master
    
    Write-Host "=== Push completed successfully at $(Get-Date) ==="
}
catch {
    Write-Host "Error during commit/push: $_"
    exit 1
}
finally {
    Stop-Transcript
}
