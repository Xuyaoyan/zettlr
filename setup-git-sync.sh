#!/usr/bin/env bash
# Setup Git Sync with cron
# Run this script to create cron jobs

REPO_PATH="/mnt/p/Note/zettlr"
PUSH_SCRIPT="$REPO_PATH/git-push.sh"
PULL_SCRIPT="$REPO_PATH/git-pull.sh"

echo "========================================"
echo "Git Sync Cron Setup"
echo "========================================"
echo ""

# Check if scripts exist
if [ ! -f "$PUSH_SCRIPT" ]; then
    echo "ERROR: git-push.sh not found at $PUSH_SCRIPT"
    exit 1
fi

if [ ! -f "$PULL_SCRIPT" ]; then
    echo "ERROR: git-pull.sh not found at $PULL_SCRIPT"
    exit 1
fi

# Make scripts executable
chmod +x "$PUSH_SCRIPT" "$PULL_SCRIPT"
echo "✓ Scripts made executable"

# Backup existing crontab
crontab -l > /tmp/crontab.backup 2>/dev/null || true
echo "✓ Existing crontab backed up to /tmp/crontab.backup"

# Remove old entries if they exist
crontab -l 2>/dev/null | grep -v "git-push.sh" | grep -v "git-pull.sh" > /tmp/crontab.new || true

# Add new cron jobs
echo "" >> /tmp/crontab.new
echo "# Git Sync Tasks" >> /tmp/crontab.new
echo "0 6 * * * $PUSH_SCRIPT >> $REPO_PATH/logs/cron-push.log 2>&1" >> /tmp/crontab.new
echo "0 18 * * * $PULL_SCRIPT >> $REPO_PATH/logs/cron-pull.log 2>&1" >> /tmp/crontab.new

# Install new crontab
crontab /tmp/crontab.new
echo "✓ Cron jobs installed"

# Clean up
rm /tmp/crontab.new

echo ""
echo "========================================"
echo "Setup completed!"
echo "========================================"
echo ""
echo "Scheduled tasks:"
echo "  • Git-Push  - Daily at 06:00 (commits and pushes)"
echo "  • Git-Pull  - Daily at 18:00 (pulls from remote)"
echo ""
echo "Useful commands:"
echo "  View crontab:    crontab -l"
echo "  Edit crontab:    crontab -e"
echo "  Remove crontab:  crontab -r"
echo ""
echo "Test scripts manually:"
echo "  $PUSH_SCRIPT"
echo "  $PULL_SCRIPT"
echo ""
echo "Logs will be saved in: $REPO_PATH/logs/"
