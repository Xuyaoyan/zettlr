# Git Sync 自动化

使用 Windows 计划任务自动同步 Git 仓库。

## 功能

- ⏰ **上午 6:00** - 自动提交本地更改并推送到 GitHub
- ⏰ **下午 6:00** - 从 GitHub 拉取最新更改
- 📝 完整的日志记录（每日日志文件）
- 🔄 智能处理冲突（自动 stash）
- ⚡ 使用 Windows 计划任务，无需后台进程

## 快速开始

### 1. 设置自动任务（一次性操作）
```powershell
.\setup-git-sync.ps1
```

### 2. 验证任务
```powershell
Get-ScheduledTask -TaskName 'Git-*'
```

### 3. 手动测试
```powershell
# 测试推送
Start-ScheduledTask -TaskName 'Git-Push'

# 测试拉取
Start-ScheduledTask -TaskName 'Git-Pull'
```

## 文件说明

- `git-push.ps1` - 推送脚本（提交并推送更改）
- `git-pull.ps1` - 拉取脚本（从远程拉取更新）
- `setup-git-sync.ps1` - 设置计划任务

## 管理任务

### 查看任务状态
```powershell
Get-ScheduledTask -TaskName 'Git-*' | Format-Table
```

### 禁用任务
```powershell
Disable-ScheduledTask -TaskName 'Git-Push'
Disable-ScheduledTask -TaskName 'Git-Pull'
```

### 启用任务
```powershell
Enable-ScheduledTask -TaskName 'Git-Push'
Enable-ScheduledTask -TaskName 'Git-Pull'
```

### 删除任务
```powershell
Unregister-ScheduledTask -TaskName 'Git-Push' -Confirm:$false
Unregister-ScheduledTask -TaskName 'Git-Pull' -Confirm:$false
```

## 日志

日志文件保存在 `logs/` 目录：
- `logs/push-YYYY-MM-DD.log` - 推送操作日志
- `logs/pull-YYYY-MM-DD.log` - 拉取操作日志

## 工作原理

- Windows 计划任务在指定时间自动触发脚本
- `git-push.ps1` 每天 06:00 运行，提交并推送更改
- `git-pull.ps1` 每天 18:00 运行，拉取远程更新
- 所有操作记录到日志文件

## 注意事项

- 确保 Git 已配置好认证（SSH 密钥或凭据管理器）
- 脚本需要持续运行才能执行定时任务
- 建议在后台或最小化窗口运行
