#!/bin/bash
set -e

REPO="tms-anhle/dev-profile"
BRANCH="master"
SKILL_NAME="generate-short-bio"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"
RAW_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/SKILL.md"

# Dependency: humanizer skill (https://github.com/blader/humanizer) — dùng để làm tự nhiên văn phong bio
# Pin theo commit (v3.1.0) — SKILL.md dựa vào "embedded mode" của humanizer; nâng version thì kiểm tra lại mode này
HUMANIZER_DIR="$HOME/.claude/skills/humanizer"
HUMANIZER_REF="8c307f367c91bd974002f10f2be2965d642c13df"
HUMANIZER_URL="https://raw.githubusercontent.com/blader/humanizer/$HUMANIZER_REF/SKILL.md"

# Tải $1 về file $2 qua file tạm — mạng đứt giữa chừng không làm hỏng file đang có
download() {
  local tmp
  tmp="$(mktemp)"
  if curl -fsSL "$1" -o "$tmp" && [ -s "$tmp" ]; then
    chmod 644 "$tmp"
    mv "$tmp" "$2"
  else
    rm -f "$tmp"
    return 1
  fi
}

install_humanizer() {
  if [ -e "$HUMANIZER_DIR" ]; then
    echo "Humanizer skill already installed: $HUMANIZER_DIR (kept as is)"
    return 0
  fi
  # Symlink hỏng: -e trả false nhưng mkdir -p sẽ lỗi → xóa link rồi cài mới
  if [ -L "$HUMANIZER_DIR" ]; then
    echo "Broken symlink found at $HUMANIZER_DIR -> $(readlink "$HUMANIZER_DIR"), replacing it."
    rm "$HUMANIZER_DIR"
  fi
  echo "Installing dependency: humanizer skill..."
  mkdir -p "$HUMANIZER_DIR"
  if download "$HUMANIZER_URL" "$HUMANIZER_DIR/SKILL.md"; then
    echo "Installed to: $HUMANIZER_DIR/SKILL.md"
  else
    rm -rf "$HUMANIZER_DIR"
    echo "Warning: Failed to install humanizer skill. generate-short-bio will fall back to its built-in humanization rules."
  fi
}

done_message() {
  echo ""
  echo "Done! Restart Claude Code and run /$SKILL_NAME to get started."
}

# Uninstall mode
if [ "$1" = "--uninstall" ]; then
  if [ -L "$SKILL_DIR" ]; then
    rm "$SKILL_DIR"
    echo "Uninstalled: symlink $SKILL_DIR removed (source repo kept)."
  elif [ -L "$SKILL_DIR/SKILL.md" ]; then
    rm -rf "$SKILL_DIR"
    echo "Uninstalled: $SKILL_DIR removed (source repo kept)."
  elif [ -e "$SKILL_DIR" ]; then
    rm -rf "$SKILL_DIR"
    echo "Uninstalled: $SKILL_DIR removed."
  else
    echo "Not installed. Nothing to remove."
  fi
  echo "Note: humanizer skill ($HUMANIZER_DIR) was kept since other skills may use it. Remove it manually if not needed."
  exit 0
fi

echo "Installing Claude Code skill: $SKILL_NAME"

# Mode: local — chạy `bash install.sh` trong thư mục repo → symlink SKILL.md để sửa skill có hiệu lực ngay.
# Chỉ link file SKILL.md (không link cả repo) để file short-bio-*/profile-* sinh ra khi test trong repo không lọt vào skill dir.
if [ -f "./SKILL.md" ] && grep -q "^name: $SKILL_NAME$" "./SKILL.md"; then
  if [ -L "$SKILL_DIR" ]; then
    rm "$SKILL_DIR"  # bản cũ symlink cả repo
  elif [ -e "$SKILL_DIR" ]; then
    rm -rf "$SKILL_DIR"
  fi
  mkdir -p "$SKILL_DIR"
  ln -sfn "$(pwd)/SKILL.md" "$SKILL_DIR/SKILL.md"
  echo "Local repo detected — symlinked: $SKILL_DIR/SKILL.md -> $(pwd)/SKILL.md"
  install_humanizer
  done_message
  exit 0
fi

# Đang là symlink tới repo local → không ghi đè file trong repo (tránh mất thay đổi chưa commit)
if [ -L "$SKILL_DIR" ] || [ -L "$SKILL_DIR/SKILL.md" ]; then
  if [ -L "$SKILL_DIR" ]; then
    LINK_TARGET="$(readlink "$SKILL_DIR")"
    REPO_DIR="$LINK_TARGET"
  else
    LINK_TARGET="$(readlink "$SKILL_DIR/SKILL.md")"
    REPO_DIR="$(dirname "$LINK_TARGET")"
  fi
  echo "Existing symlink detected: -> $LINK_TARGET"
  echo "Skipped download to avoid overwriting your local repo. Update it with: git -C \"$REPO_DIR\" pull"
  install_humanizer
  exit 0
fi

# Mode: download từ GitHub
if ! command -v curl &>/dev/null; then
  echo "Error: curl is required. Please install curl and try again."
  exit 1
fi

mkdir -p "$SKILL_DIR"

echo "Downloading SKILL.md from GitHub..."
NEW_FILE="$(mktemp)"
if download "$RAW_URL" "$NEW_FILE"; then
  # Bản cũ dùng tên skill.md (chữ thường) — chỉ xóa khi tên lưu trên đĩa đúng là chữ thường.
  # Không `rm -f skill.md` vô điều kiện: trên macOS (không phân biệt hoa thường) lệnh đó xóa luôn SKILL.md.
  if ls -1 "$SKILL_DIR" 2>/dev/null | grep -qx 'skill.md'; then
    rm -f "$SKILL_DIR/skill.md"
  fi
  mv "$NEW_FILE" "$SKILL_DIR/SKILL.md"
  echo "Installed to: $SKILL_DIR/SKILL.md"
  install_humanizer
  done_message
else
  rm -f "$NEW_FILE"
  echo "Error: Failed to download skill. Check your internet connection or repo URL."
  exit 1
fi
