#!/usr/bin/env bash
# Git Push Script
# Commits and pushes local changes to remote repository

REPO_PATH="/mnt/p/Note/zettlr"
LOG_DIR="$REPO_PATH/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/push-$(date +%Y-%m-%d).log"

write_log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

write_log "=== Starting commit and push ==="

cd "$REPO_PATH" || {
    write_log "ERROR: Failed to change directory to $REPO_PATH"
    exit 1
}

# Check for changes
status=$(git status --porcelain 2>&1)
if [ -z "$status" ]; then
    write_log "No changes to commit"
    write_log "=== Nothing to push ==="
    exit 0
fi

write_log "Changes detected, adding all files..."
git add -A 2>&1 | while IFS= read -r line; do write_log "$line"; done

# Commit with timestamp
commit_message="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
write_log "Committing: $commit_message"
git commit -m "$commit_message" 2>&1 | while IFS= read -r line; do write_log "$line"; done

# Push to remote
write_log "Pushing to origin/master..."
git push origin master 2>&1 | while IFS= read -r line; do write_log "$line"; done

if [ $? -eq 0 ]; then
    write_log "=== Push completed successfully ==="
    exit 0
else
    write_log "ERROR: Push failed"
    exit 1
fi
