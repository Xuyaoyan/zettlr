# Git Sync Daemon

自动化 Git 同步守护进程，无需 Windows 计划任务。

## 功能

- ⏰ **上午 6:00** - 自动提交本地更改并推送到 GitHub
- ⏰ **下午 6:00** - 从 GitHub 拉取最新更改
- 📝 完整的日志记录（每日日志文件）
- 🔄 智能处理冲突（自动 stash）
- 🎯 单个脚本，持续运行

## 使用方法

### 基本使用
```powershell
.\git-sync.ps1
```

### 自定义时间
```powershell
# 自定义推送和拉取时间
.\git-sync.ps1 -PushTime "08:00" -PullTime "20:00"
```

### 自定义仓库路径
```powershell
.\git-sync.ps1 -RepoPath "D:\MyRepo"
```

## 后台运行

### 方法 1：使用 Start-Process
```powershell
Start-Process pwsh -ArgumentList "-NoExit", "-File", ".\git-sync.ps1" -WindowStyle Minimized
```

### 方法 2：使用 nohup（如果安装了 Git Bash）
```bash
nohup pwsh -File git-sync.ps1 &
```

### 方法 3：新窗口运行
```powershell
Start-Process pwsh -ArgumentList "-File", "P:\Note\zettlr\git-sync.ps1"
```

## 开机自启动（可选）

在 PowerShell 配置文件中添加：

1. 打开配置文件：
```powershell
notepad $PROFILE
```

2. 添加以下内容：
```powershell
# Auto-start git-sync daemon
Start-Process pwsh -ArgumentList "-File", "P:\Note\zettlr\git-sync.ps1" -WindowStyle Hidden
```

## 日志

日志文件保存在 `logs/` 目录：
- `logs/push-YYYY-MM-DD.log` - 推送操作日志
- `logs/pull-YYYY-MM-DD.log` - 拉取操作日志

## 停止守护进程

按 `Ctrl+C` 停止正在运行的守护进程。

## 工作原理

- 脚本每分钟检查一次当前时间
- 在指定时间执行相应的 Git 操作
- 每天只执行一次（通过日期追踪避免重复）
- 每 10 分钟显示下次执行时间

## 注意事项

- 确保 Git 已配置好认证（SSH 密钥或凭据管理器）
- 脚本需要持续运行才能执行定时任务
- 建议在后台或最小化窗口运行
