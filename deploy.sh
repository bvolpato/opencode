#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/packages/opencode"

# Build the opencode binary
bun run build

# Verify it works
VERSION=$(./dist/opencode-linux-x64/bin/opencode --version)
echo "Built: $VERSION"

# The ~/bin/opencode wrapper already points to dist/opencode-linux-x64/bin/opencode
# so no copy is needed, but verify the binary is fresh
ls -lh ./dist/opencode-linux-x64/bin/opencode

echo "Deploy complete. Run 'opencode --version' to verify."
