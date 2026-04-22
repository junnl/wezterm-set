#!/usr/bin/env bash
# mac-dev-setup / scripts / install.sh
# 一键安装所有依赖。
# 使用: ./scripts/install.sh

set -e

# 1. 确认 Homebrew 存在
if ! command -v brew >/dev/null 2>&1; then
  echo "→ 安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

echo "=== 必装依赖 ==="
brew install \
  neovim \
  yazi \
  starship \
  fzf \
  ripgrep \
  eza \
  fd \
  git \
  pngpaste \
  jq \
  poppler \
  ffmpegthumbnailer \
  sevenzip \
  font-jetbrains-mono

# WezTerm nightly（稳定版更新慢，用 nightly）
echo ""
echo "=== WezTerm nightly ==="
brew install --cask wezterm@nightly

echo ""
echo "=== 可选依赖 ==="
brew install imagemagick chafa zoxide || true

# 字体（如果 cask 源报错，忽略即可）
brew tap homebrew/cask-fonts 2>/dev/null || true
brew install --cask font-jetbrains-mono 2>/dev/null || true

echo ""
echo "=== 完成 ==="
echo "下一步: ./scripts/deploy.sh"
