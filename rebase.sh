#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Add upstream remote if it doesn't exist
if ! git remote show upstream >/dev/null 2>&1; then
  echo "Adding upstream remote..."
  git remote add upstream https://github.com/anomalyco/opencode
fi

CURRENT_BRANCH=$(git branch --show-current)
STASHED=false

# Stash local changes if any
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Stashing local changes..."
  git stash push -m "rebase-autostash"
  STASHED=true
fi

echo "Fetching upstream..."
git fetch upstream

echo "Merging upstream/dev into local dev..."
git checkout dev
git merge upstream/dev --no-edit || true

echo "Merging dev into $CURRENT_BRANCH..."
git checkout "$CURRENT_BRANCH"
git merge dev --no-edit || true

# Restore stashed changes
if [ "$STASHED" = true ]; then
  echo "Restoring stashed changes..."
  git stash pop || true
fi

echo "Rebase complete. Current branch: $(git branch --show-current)"
