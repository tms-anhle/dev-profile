#!/bin/bash
set -e

REPO="tms-anhle/dev-profile"
BRANCH="master"
SKILL_NAME="generate-short-bio"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"
RAW_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/skill.md"

# Dependency: humanizer skill (https://github.com/blader/humanizer) — dùng để làm tự nhiên văn phong bio
HUMANIZER_DIR="$HOME/.claude/skills/humanizer"
HUMANIZER_URL="https://raw.githubusercontent.com/blader/humanizer/main/SKILL.md"

install_humanizer() {
  if [ -e "$HUMANIZER_DIR" ]; then
    echo "Humanizer skill already installed: $HUMANIZER_DIR (kept as is)"
    return 0
  fi
  echo "Installing dependency: humanizer skill..."
  mkdir -p "$HUMANIZER_DIR"
  if curl -fsSL "$HUMANIZER_URL" -o "$HUMANIZER_DIR/SKILL.md"; then
    echo "Installed to: $HUMANIZER_DIR/SKILL.md"
  else
    rm -rf "$HUMANIZER_DIR"
    echo "Warning: Failed to install humanizer skill. generate-short-bio will fall back to its built-in humanization rules."
  fi
}

# Uninstall mode
if [ "$1" = "--uninstall" ]; then
  if [ -e "$SKILL_DIR" ]; then
    rm -rf "$SKILL_DIR"
    echo "Uninstalled: $SKILL_DIR removed."
  else
    echo "Not installed. Nothing to remove."
  fi
  echo "Note: humanizer skill ($HUMANIZER_DIR) was kept since other skills may use it. Remove it manually if not needed."
  exit 0
fi

echo "Installing Claude Code skill: $SKILL_NAME"

# Mode: download từ GitHub
if ! command -v curl &>/dev/null; then
  echo "Error: curl is required. Please install curl and try again."
  exit 1
fi

# Nếu đang là symlink → chỉ update skill.md tại nguồn, giữ nguyên symlink
if [ -L "$SKILL_DIR" ] && [ -d "$SKILL_DIR" ]; then
  echo "Existing symlink detected — updating skill.md at source..."
  if curl -fsSL "$RAW_URL" -o "$SKILL_DIR/skill.md"; then
    echo "Updated: $(readlink "$SKILL_DIR")/skill.md"
    install_humanizer
    echo ""
    echo "Done! Restart Claude Code and run /generate-short-bio to get started."
  else
    echo "Error: Failed to download skill."
    exit 1
  fi
  exit 0
fi

mkdir -p "$SKILL_DIR"

echo "Downloading skill.md from GitHub..."
if curl -fsSL "$RAW_URL" -o "$SKILL_DIR/skill.md"; then
  echo "Installed to: $SKILL_DIR/skill.md"
  install_humanizer
  echo ""
  echo "Done! Restart Claude Code and run /generate-short-bio to get started."
else
  echo "Error: Failed to download skill. Check your internet connection or repo URL."
  exit 1
fi

