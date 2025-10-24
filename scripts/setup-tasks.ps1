# Setup Windows Task Scheduler tasks for Git sync
# Run this script once with Administrator privileges

$ErrorActionPreference = "Stop"

$RepoPath = "P:\Note\zettlr"
$PullScript = "$RepoPath\scripts\pull-remote.ps1"
$PushScript = "$RepoPath\scripts\push-remote.ps1"

Write-Host "Setting up scheduled tasks for Git sync..."

# Task 1: Pull from remote at 6:00 PM daily
$pullAction = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PullScript`""

$pullTrigger = New-ScheduledTaskTrigger -Daily -At "18:00"

$pullSettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName "Zettlr-PullRemote" `
    -Description "Pull from GitHub repository daily at 6:00 PM" `
    -Action $pullAction `
    -Trigger $pullTrigger `
    -Settings $pullSettings `
    -User $env:USERNAME `
    -RunLevel Highest `
    -Force

Write-Host "✓ Created task: Zettlr-PullRemote (runs at 6:00 PM)"

# Task 2: Push to remote at 6:00 AM daily
$pushAction = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PushScript`""

$pushTrigger = New-ScheduledTaskTrigger -Daily -At "06:00"

$pushSettings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName "Zettlr-PushRemote" `
    -Description "Commit and push to GitHub repository daily at 6:00 AM" `
    -Action $pushAction `
    -Trigger $pushTrigger `
    -Settings $pushSettings `
    -User $env:USERNAME `
    -RunLevel Highest `
    -Force

Write-Host "✓ Created task: Zettlr-PushRemote (runs at 6:00 AM)"

Write-Host ""
Write-Host "Setup completed successfully!"
Write-Host ""
Write-Host "To verify the tasks:"
Write-Host "  Get-ScheduledTask -TaskName 'Zettlr-*'"
Write-Host ""
Write-Host "To manually run a task:"
Write-Host "  Start-ScheduledTask -TaskName 'Zettlr-PullRemote'"
Write-Host "  Start-ScheduledTask -TaskName 'Zettlr-PushRemote'"
Write-Host ""
Write-Host "To disable a task:"
Write-Host "  Disable-ScheduledTask -TaskName 'Zettlr-PullRemote'"
Write-Host "  Disable-ScheduledTask -TaskName 'Zettlr-PushRemote'"
Write-Host ""
Write-Host "To remove the tasks:"
Write-Host "  Unregister-ScheduledTask -TaskName 'Zettlr-PullRemote' -Confirm:`$false"
Write-Host "  Unregister-ScheduledTask -TaskName 'Zettlr-PushRemote' -Confirm:`$false"
