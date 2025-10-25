#!/usr/bin/env bash
# Git Pull Script
# Pulls changes from remote repository

REPO_PATH="/mnt/p/Note/zettlr"
LOG_DIR="$REPO_PATH/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/pull-$(date +%Y-%m-%d).log"

write_log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

write_log "=== Starting pull from remote ==="

cd "$REPO_PATH" || {
    write_log "ERROR: Failed to change directory to $REPO_PATH"
    exit 1
}

# Check for uncommitted changes
status=$(git status --porcelain 2>&1)
if [ -n "$status" ]; then
    write_log "Uncommitted changes detected, stashing..."
    git stash save "Auto-stash before pull at $(date '+%Y-%m-%d %H:%M:%S')" 2>&1 | while IFS= read -r line; do write_log "$line"; done
fi

# Pull from remote
write_log "Pulling from origin/master..."
git pull origin master 2>&1 | while IFS= read -r line; do write_log "$line"; done

if [ $? -eq 0 ]; then
    write_log "=== Pull completed successfully ==="
    exit 0
else
    write_log "ERROR: Pull failed"
    exit 1
fi
