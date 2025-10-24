# Git Sync Daemon
# Automated Git synchronization with scheduled pull and push operations
# Pull: Daily at 18:00 (6:00 PM)
# Push: Daily at 06:00 (6:00 AM)

param(
    [string]$RepoPath = "P:\Note\zettlr",
    [string]$PushTime = "06:00",
    [string]$PullTime = "18:00"
)

$ErrorActionPreference = "Continue"

# Create logs directory
$LogDir = Join-Path $RepoPath "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

# Track last execution to avoid duplicate runs
$LastPush = $null
$LastPull = $null

function Write-Log {
    param([string]$Message, [string]$Type = "pull")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logFile = Join-Path $LogDir "$Type-$(Get-Date -Format 'yyyy-MM-dd').log"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

function Invoke-GitPull {
    Write-Log "=== Starting pull from remote ===" "pull"
    
    try {
        Set-Location $RepoPath
        
        # Check if there are uncommitted changes
        $status = git status --porcelain
        if ($status) {
            Write-Log "Warning: Uncommitted changes detected. Stashing them..." "pull"
            git stash save "Auto-stash before pull at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>&1 | ForEach-Object { Write-Log $_ "pull" }
        }
        
        # Pull from remote
        Write-Log "Pulling from remote..." "pull"
        $pullOutput = git pull origin master 2>&1
        $pullOutput | ForEach-Object { Write-Log $_ "pull" }
        
        Write-Log "=== Pull completed successfully ===" "pull"
        return $true
    }
    catch {
        Write-Log "Error during pull: $_" "pull"
        return $false
    }
}

function Invoke-GitPush {
    Write-Log "=== Starting commit and push ===" "push"
    
    try {
        Set-Location $RepoPath
        
        # Check if there are changes to commit
        $status = git status --porcelain
        if (-not $status) {
            Write-Log "No changes to commit." "push"
            Write-Log "=== Nothing to push ===" "push"
            return $true
        }
        
        Write-Log "Changes detected:" "push"
        git status --short | ForEach-Object { Write-Log $_ "push" }
        
        # Add all changes
        Write-Log "Adding all changes..." "push"
        git add -A 2>&1 | ForEach-Object { Write-Log $_ "push" }
        
        # Commit with timestamp
        $commitMessage = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        Write-Log "Committing with message: $commitMessage" "push"
        git commit -m $commitMessage 2>&1 | ForEach-Object { Write-Log $_ "push" }
        
        # Push to remote
        Write-Log "Pushing to remote..." "push"
        $pushOutput = git push origin master 2>&1
        $pushOutput | ForEach-Object { Write-Log $_ "push" }
        
        Write-Log "=== Push completed successfully ===" "push"
        return $true
    }
    catch {
        Write-Log "Error during commit/push: $_" "push"
        return $false
    }
}

function Get-NextScheduledTime {
    param([string]$TargetTime)
    
    $now = Get-Date
    $today = Get-Date -Hour $TargetTime.Split(':')[0] -Minute $TargetTime.Split(':')[1] -Second 0
    
    if ($now -gt $today) {
        return $today.AddDays(1)
    }
    return $today
}

# Main loop
Write-Host "========================================"
Write-Host "Git Sync Daemon Started"
Write-Host "========================================"
Write-Host "Repository: $RepoPath"
Write-Host "Push Time:  $PushTime (daily)"
Write-Host "Pull Time:  $PullTime (daily)"
Write-Host "Log Dir:    $LogDir"
Write-Host "========================================"
Write-Host "Press Ctrl+C to stop"
Write-Host ""

while ($true) {
    $now = Get-Date
    $currentTime = $now.ToString("HH:mm")
    $currentDate = $now.ToString("yyyy-MM-dd")
    
    # Check if it's time to push (6:00 AM)
    if ($currentTime -eq $PushTime -and $LastPush -ne $currentDate) {
        Write-Host "`n[$(Get-Date -Format 'HH:mm:ss')] Triggering scheduled PUSH..."
        Invoke-GitPush
        $LastPush = $currentDate
    }
    
    # Check if it's time to pull (6:00 PM)
    if ($currentTime -eq $PullTime -and $LastPull -ne $currentDate) {
        Write-Host "`n[$(Get-Date -Format 'HH:mm:ss')] Triggering scheduled PULL..."
        Invoke-GitPull
        $LastPull = $currentDate
    }
    
    # Show next scheduled times every 10 minutes
    if ($now.Minute % 10 -eq 0 -and $now.Second -lt 60) {
        $nextPush = Get-NextScheduledTime $PushTime
        $nextPull = Get-NextScheduledTime $PullTime
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Running... Next push: $($nextPush.ToString('yyyy-MM-dd HH:mm')), Next pull: $($nextPull.ToString('yyyy-MM-dd HH:mm'))"
        Start-Sleep -Seconds 60  # Sleep for a minute to avoid repeated messages
    }
    
    # Check every minute
    Start-Sleep -Seconds 60
}
