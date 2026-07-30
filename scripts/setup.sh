#!/bin/bash
# Claude Code Skills Setup Script
# Copies .claude/ directory to the current project
#
# Usage:
#   bash setup.sh                    # Copy to current directory
#   bash setup.sh /path/to/project   # Copy to specific project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-$(pwd)}"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: Target directory '$PROJECT_DIR' does not exist."
  exit 1
fi

SOURCE="$SCRIPT_DIR/../.claude"
TARGET="$PROJECT_DIR/.claude"

if [ -d "$TARGET" ]; then
  read -p "Warning: $TARGET already exists. Overwrite? (y/N): " confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Aborted."
    exit 0
  fi
fi

cp -r "$SOURCE" "$TARGET"
echo "✓ Copied .claude/ to $TARGET"
echo "✓ Claude Code skills are ready to use."
echo ""
echo "Start Claude Code in your project:"
echo "  cd $PROJECT_DIR"
echo "  claude"
