# Setup Git Sync with Windows Task Scheduler
# Run this script to create scheduled tasks

$RepoPath = "P:\Note\zettlr"
$PullScript = Join-Path $RepoPath "git-pull.ps1"
$PushScript = Join-Path $RepoPath "git-push.ps1"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Git Sync Task Scheduler Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create pull task (6:00 PM daily)
Write-Host "Creating task: Git-Pull (runs daily at 18:00)..." -ForegroundColor Yellow

$pullAction = New-ScheduledTaskAction `
    -Execute "pwsh.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PullScript`""

$pullTrigger = New-ScheduledTaskTrigger -Daily -At "18:00"

$pullSettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

Register-ScheduledTask `
    -TaskName "Git-Pull" `
    -Description "Pull from GitHub repository daily at 6:00 PM" `
    -Action $pullAction `
    -Trigger $pullTrigger `
    -Settings $pullSettings `
    -Force | Out-Null

Write-Host "✓ Task 'Git-Pull' created successfully" -ForegroundColor Green

# Create push task (6:00 AM daily)
Write-Host "Creating task: Git-Push (runs daily at 06:00)..." -ForegroundColor Yellow

$pushAction = New-ScheduledTaskAction `
    -Execute "pwsh.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PushScript`""

$pushTrigger = New-ScheduledTaskTrigger -Daily -At "06:00"

$pushSettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

Register-ScheduledTask `
    -TaskName "Git-Push" `
    -Description "Commit and push to GitHub repository daily at 6:00 AM" `
    -Action $pushAction `
    -Trigger $pushTrigger `
    -Settings $pushSettings `
    -Force | Out-Null

Write-Host "✓ Task 'Git-Push' created successfully" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tasks created:" -ForegroundColor White
Write-Host "  • Git-Push  - Daily at 06:00 (commits and pushes)" -ForegroundColor White
Write-Host "  • Git-Pull  - Daily at 18:00 (pulls from remote)" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  View tasks:      " -NoNewline; Write-Host "Get-ScheduledTask -TaskName 'Git-*'" -ForegroundColor Cyan
Write-Host "  Run task now:    " -NoNewline; Write-Host "Start-ScheduledTask -TaskName 'Git-Push'" -ForegroundColor Cyan
Write-Host "  Disable task:    " -NoNewline; Write-Host "Disable-ScheduledTask -TaskName 'Git-Push'" -ForegroundColor Cyan
Write-Host "  Remove task:     " -NoNewline; Write-Host "Unregister-ScheduledTask -TaskName 'Git-Push'" -ForegroundColor Cyan
Write-Host ""
Write-Host "Logs will be saved in: $RepoPath\logs\" -ForegroundColor Gray
