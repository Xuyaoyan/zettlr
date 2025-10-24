# Git Sync Scripts

This directory contains PowerShell scripts for automated Git synchronization with GitHub.

## Scripts

### `pull-remote.ps1`
Pulls changes from the remote repository to local.
- **Schedule**: Daily at 6:00 PM
- **Actions**:
  - Stashes uncommitted changes if any
  - Pulls from `origin/master`
  - Logs to `logs/pull-YYYY-MM-DD.log`

### `push-remote.ps1`
Commits and pushes local changes to the remote repository.
- **Schedule**: Daily at 6:00 AM
- **Actions**:
  - Checks for changes
  - Adds all changes (`git add -A`)
  - Commits with timestamp
  - Pushes to `origin/master`
  - Logs to `logs/push-YYYY-MM-DD.log`

### `setup-tasks.ps1`
Sets up Windows Task Scheduler tasks.
- **Usage**: Run once with Administrator privileges
- **Creates**: Two scheduled tasks (`Zettlr-PullRemote` and `Zettlr-PushRemote`)

## Setup

1. Open PowerShell as Administrator
2. Run the setup script:
```powershell
.\scripts\setup-tasks.ps1
```

## Management

### Check task status
```powershell
Get-ScheduledTask -TaskName 'Zettlr-*'
```

### Manually run a task
```powershell
Start-ScheduledTask -TaskName 'Zettlr-PullRemote'
Start-ScheduledTask -TaskName 'Zettlr-PushRemote'
```

### Disable tasks
```powershell
Disable-ScheduledTask -TaskName 'Zettlr-PullRemote'
Disable-ScheduledTask -TaskName 'Zettlr-PushRemote'
```

### Remove tasks
```powershell
Unregister-ScheduledTask -TaskName 'Zettlr-PullRemote' -Confirm:$false
Unregister-ScheduledTask -TaskName 'Zettlr-PushRemote' -Confirm:$false
```

## Logs

All script execution logs are stored in the `logs/` directory with daily rotation:
- `logs/pull-YYYY-MM-DD.log` - Pull operation logs
- `logs/push-YYYY-MM-DD.log` - Push operation logs
